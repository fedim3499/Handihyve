namespace WebApi.Services;

using AutoMapper;
using BCrypt.Net;
using Microsoft.Extensions.Options;
using WebApi.Authorization;
using WebApi.Entities;
using WebApi.Helpers;
using WebApi.Models.Profession;

public interface IProfessionService
{
    IEnumerable<ProfessionCustom> GetAll();
    Profession GetById(int id);
    void Create(ProfessionCustom model);
    void Update(int id, ProfessionCustom model);
    void ActiveProfession(ProfessionCustom model);
    IEnumerable<ProfessionCustom> GetProfessionByTypeId(int? professionTypeId);

    void Delete(int id);
}

public class ProfessionService : IProfessionService
{
    private DataContext _context;
    private readonly IMapper _mapper;
    private readonly AppSettings _appSettings;

    public ProfessionService(
        DataContext context,
        IMapper mapper,
        IOptions<AppSettings> appSettings
         )
    {
        _context = context;
        _mapper = mapper;
        _appSettings = appSettings.Value;

    }

    public IEnumerable<ProfessionCustom> GetAll()
    {
        var query = from profession in _context.Professions
                    from user in _context.Users.Where(x => x.professionId == profession.Id)
                    from professionType in _context.ProfessionTypes.Where(x => x.Id == profession.ProfessionTypeId)
                    select new ProfessionCustom
                    {
                        Id = profession.Id,
                        ProfessionName = professionType.ProfessionName,
                        UserName = user.Username,
                        FirstName = user.FirstName,
                        TaxRegistrationNumber = profession.TaxRegistrationNumber,
                        IsActive = user.IsActive,
                    };
        return query.ToList();
    }

    public IEnumerable<ProfessionCustom> GetProfessionByTypeId(int? professionTypeId)
    {
        var query = from profession in _context.Professions.Where(x=> x.ProfessionTypeId == professionTypeId)
                    from user in _context.Users.Where(x => x.professionId == profession.Id && x.IsActive == true)
                    from professionType in _context.ProfessionTypes.Where(x => x.Id == profession.ProfessionTypeId)
                    select new ProfessionCustom
                    {
                        Id = profession.Id,
                        ProfessionName = professionType.ProfessionName,
                        UserName = user.FirstName+" "+ user.Username,
                        TaxRegistrationNumber = profession.TaxRegistrationNumber,
                        IsActive = user.IsActive,
                    };
        return query.ToList();
    }

    public Profession GetById(int id)
    {
        return getProfession(id);
    }

    public void Create(ProfessionCustom model)
    {
        var profession = new Profession();   
        profession.TaxRegistrationNumber = model.TaxRegistrationNumber;

        _context.Professions.Add(profession);
        _context.SaveChanges();
    }

    public void Update(int id, ProfessionCustom model)
    {
        var profession = getProfession(id);      
        profession.TaxRegistrationNumber = model.TaxRegistrationNumber;

        _context.Professions.Update(profession);
        _context.SaveChanges();
    }

    public void Delete(int id)
    {
        var profession = getProfession(id);
        _context.Professions.Remove(profession);
        _context.SaveChanges();
    }

    public void ActiveProfession(ProfessionCustom model) {
        var user = _context.Users.FirstOrDefault(x=>x.professionId == model.Id.Value);
        user.IsActive = true;

        _context.Users.Update(user);
        _context.SaveChanges();
    }

    // helper methods

    private Profession getProfession(int id)
    {
        var profession = _context.Professions.Find(id);
        if (profession == null) throw new KeyNotFoundException("profession not found");
        return profession;
    }


}