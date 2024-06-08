namespace WebApi.Services;

using AutoMapper;
using BCrypt.Net;
using Microsoft.Extensions.Options;
using WebApi.Authorization;
using WebApi.Entities;
using WebApi.Helpers;
using WebApi.Helpers.Constant;
using WebApi.Models.Users;

public interface IUserService
{
    AuthenticateResponse Authenticate(AuthenticateRequest model, string ipAddress);
    AuthenticateResponse RefreshToken(string token, string ipAddress);
    void RevokeToken(string token, string ipAddress);
    IEnumerable<User> GetAll();
    User GetById(int id);
    void Create(UserCustom model);
    void Update(int id, UpdateRequest model);
    void Delete(int id);
    User getUserByProfId(int profId);
}

public class UserService : IUserService
{
    private DataContext _context;
    private readonly IMapper _mapper;
    private readonly AppSettings _appSettings;
    private IJwtUtils _jwtUtils;

    public UserService(
        DataContext context,
        IMapper mapper,
        IOptions<AppSettings> appSettings,
        IJwtUtils jwtUtils)
    {
        _context = context;
        _mapper = mapper;
        _appSettings = appSettings.Value;
        _jwtUtils = jwtUtils;

    }
    public AuthenticateResponse Authenticate(AuthenticateRequest model, string ipAddress)
    {
        var user = _context.Users.FirstOrDefault(x => x.Username == model.Username || x.Email == model.Username);

        // validate
        if (user == null || !BCrypt.Verify(model.Password, user.PasswordHash))
            throw new AppException("Username or password is incorrect");
        if (!user.IsActive)
            throw new AppException("Is not active");

        // authentication successful so generate jwt and refresh tokens
        var jwtToken = _jwtUtils.GenerateJwtToken(user);
        var refreshToken = _jwtUtils.GenerateRefreshToken(ipAddress);
        if (user.RefreshTokens is null)
            user.RefreshTokens = new List<RefreshToken>();
        user.RefreshTokens.Add(refreshToken);

        // remove old refresh tokens from user
        removeOldRefreshTokens(user);

        // save changes to db
        _context.Update(user);
        _context.SaveChanges();

        return new AuthenticateResponse(user, jwtToken, refreshToken.Token);
    }

    public AuthenticateResponse RefreshToken(string token, string ipAddress)
    {
        var user = getUserByRefreshToken(token);
        var refreshToken = user.RefreshTokens.Single(x => x.Token == token);

        if (refreshToken.IsRevoked)
        {
            // revoke all descendant tokens in case this token has been compromised
            revokeDescendantRefreshTokens(refreshToken, user, ipAddress, $"Attempted reuse of revoked ancestor token: {token}");
            _context.Update(user);
            _context.SaveChanges();
        }

        if (!refreshToken.IsActive)
            throw new AppException("Invalid token");

        // replace old refresh token with a new one (rotate token)
        var newRefreshToken = rotateRefreshToken(refreshToken, ipAddress);
        user.RefreshTokens.Add(newRefreshToken);

        // remove old refresh tokens from user
        removeOldRefreshTokens(user);

        // save changes to db
        _context.Update(user);
        _context.SaveChanges();

        // generate new jwt
        var jwtToken = _jwtUtils.GenerateJwtToken(user);

        return new AuthenticateResponse(user, jwtToken, newRefreshToken.Token);
    }

    public void RevokeToken(string token, string ipAddress)
    {
        var user = getUserByRefreshToken(token);
        var refreshToken = user.RefreshTokens.Single(x => x.Token == token);

        if (!refreshToken.IsActive)
            throw new AppException("Invalid token");

        // revoke token and save
        revokeRefreshToken(refreshToken, ipAddress, "Revoked without replacement");
        _context.Update(user);
        _context.SaveChanges();
    }
    public IEnumerable<User> GetAll()
    {
        return _context.Users;
    }

    public User GetById(int id)
    {
        return getUser(id);
    }

    public void Create(UserCustom model)
    {
        // validate
        if (_context.Users.Any(x => x.Email == model.Email))
            throw new AppException("User with the email '" + model.Email + "' already exists");

        // map model to new user object
        var user = MappingUser(model);

        // hash password

        // save user
        _context.Users.Add(user);
        _context.SaveChanges();
    }

    public void Update(int id, UpdateRequest model)
    {
        var user = getUser(id);

        // validate
        if (model.Email != user.Email && _context.Users.Any(x => x.Email == model.Email))
            throw new AppException("User with the email '" + model.Email + "' already exists");

        // hash password if it was entered
        if (!string.IsNullOrEmpty(model.Password))
            user.PasswordHash = BCrypt.HashPassword(model.Password);

        // copy model to user and save
        _mapper.Map(model, user);
        _context.Users.Update(user);
        _context.SaveChanges();
    }

    public void Delete(int id)
    {
        var user = getUser(id);
        _context.Users.Remove(user);
        _context.SaveChanges();
    }

    // helper methods

    private User getUser(int id)
    {
        var user = _context.Users.Find(id);
        if (user == null) throw new KeyNotFoundException("User not found");
        return user;
    }
    public User getUserByProfId(int profId)
    {
        var user = _context.Users.SingleOrDefault(u => u.professionId == profId);
        if (user == null) throw new KeyNotFoundException("proff not found");
        return user;
    }

    private User getUserByRefreshToken(string token)
    {
        var user = _context.Users.SingleOrDefault(u => u.RefreshTokens.Any(t => t.Token == token));

        if (user == null)
            throw new AppException("Invalid token");

        return user;
    }

    private RefreshToken rotateRefreshToken(RefreshToken refreshToken, string ipAddress)
    {
        var newRefreshToken = _jwtUtils.GenerateRefreshToken(ipAddress);
        revokeRefreshToken(refreshToken, ipAddress, "Replaced by new token", newRefreshToken.Token);
        return newRefreshToken;
    }

    private void removeOldRefreshTokens(User user)
    {
        // remove old inactive refresh tokens from user based on TTL in app settings
        user.RefreshTokens.RemoveAll(x =>
            !x.IsActive &&
            x.Created.AddDays(_appSettings.RefreshTokenTTL) <= DateTime.UtcNow);
    }

    private void revokeDescendantRefreshTokens(RefreshToken refreshToken, User user, string ipAddress, string reason)
    {
        // recursively traverse the refresh token chain and ensure all descendants are revoked
        if (!string.IsNullOrEmpty(refreshToken.ReplacedByToken))
        {
            var childToken = user.RefreshTokens.SingleOrDefault(x => x.Token == refreshToken.ReplacedByToken);
            if (childToken.IsActive)
                revokeRefreshToken(childToken, ipAddress, reason);
            else
                revokeDescendantRefreshTokens(childToken, user, ipAddress, reason);
        }
    }

    private void revokeRefreshToken(RefreshToken token, string ipAddress, string reason = null, string replacedByToken = null)
    {
        token.Revoked = DateTime.UtcNow;
        token.RevokedByIp = ipAddress;
        token.ReasonRevoked = reason;
        token.ReplacedByToken = replacedByToken;
    }

    private User MappingUser(UserCustom userCustom)
    {
        var user = new User();
        user.FirstName = userCustom.FirstName;
        user.LastName = userCustom.LastName;
        user.Email = userCustom.Email;
        user.Country = userCustom.Country;
        user.City = userCustom.City;
        user.PhoneNumber = userCustom.PhoneNumber;
        user.State = userCustom.State;
        user.PasswordHash = BCrypt.HashPassword(userCustom.Password);
        user.IsActive = true;

        if (userCustom.ProfessionTypeId != null)
        {
            var profession = new Profession();
            profession.TaxRegistrationNumber = userCustom.TaxRegistrationNumber;
            profession.Adress = userCustom.Adress;
            profession.ProfessionTypeId = userCustom.ProfessionTypeId;
            profession.StatusId = _context.Status.FirstOrDefault(x => x.StatusName == StatusConstant.Profession_Request &&
                                    x.StatusGroupName == StatusConstantGroup.Profession).Id;
            user.IsActive = false;
            _context.Professions.Add(profession);
            _context.SaveChanges();

            user.professionId = profession.Id;
            user.Profession = profession;
        }
        return user;
    }
}