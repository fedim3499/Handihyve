namespace WebApi.Services;

using AutoMapper;
using BCrypt.Net;
using Microsoft.Extensions.Options;
using WebApi.Authorization;
using WebApi.Entities;
using WebApi.Helpers;
using WebApi.Models.Role;

public interface IRoleService
{
    IEnumerable<Role> GetAll();
    Role GetById(int id);
    void Create(RoleCustom model);
    void Update(int id, RoleCustom model);
    void Delete(int id);
}

public class RoleService : IRoleService
{
    private DataContext context;
    private readonly IMapper mapper;
    private readonly AppSettings appSettings;

    public RoleService(
        DataContext _context,
        IMapper _mapper,
        IOptions<AppSettings> _appSettings
         )
    {
        context = _context;
        mapper = _mapper;
        appSettings = _appSettings.Value;

    }
 
    public IEnumerable<Role> GetAll()
    {
        return context.Roles;
    }

    public Role GetById(int id)
    {
        return GetRole(id);
    }

    public void Create(RoleCustom model)
    {
        
        var role = new Role();
        role.RoleName = model.RoleName;
        role.Description = model.Description;
  
        context.Roles.Add(role);
        context.SaveChanges();
    }

    public void Update(int id, RoleCustom model)
    {
        var role = GetRole(id);
        role.RoleName = model.RoleName;
        role.Description = model.Description;

        context.Roles.Update(role);
        context.SaveChanges();
    }

    public void Delete(int id)
    {
        var role = GetRole(id);
        context.Roles.Remove(role);
        context.SaveChanges();
    }

    // helper methods

    private Role GetRole(int id)
    {
        var role = context.Roles.Find(id);
        if (role == null) throw new KeyNotFoundException("role not found");
        return role;
    }
  
     
}