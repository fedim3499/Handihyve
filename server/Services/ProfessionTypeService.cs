namespace WebApi.Services;

using AutoMapper;
using BCrypt.Net;
using Microsoft.Extensions.Options;
using WebApi.Authorization;
using WebApi.Entities;
using WebApi.Helpers;
using WebApi.Models.Profession;

public interface IProfessionTypeService
{
    IEnumerable<ProfessionType> GetAll();
    ProfessionType GetById(int id);
    void Create(professionC model);
    void Update(int id, professionC model);
   
    void Delete(int id);
}

public class ProfessionTypeService : IProfessionTypeService
{
    private DataContext _context;
    private readonly IMapper _mapper;
    private readonly AppSettings _appSettings;

    public ProfessionTypeService(
        DataContext context,
        IMapper mapper,
        IOptions<AppSettings> appSettings
         )
    {
        _context = context;
        _mapper = mapper;
        _appSettings = appSettings.Value;

    }
 
    public IEnumerable<ProfessionType> GetAll()
    {
        return _context.ProfessionTypes;
    }

    public ProfessionType GetById(int id)
    {
        return getProfession(id);
    }

    public void Create(professionC model)
    {
        
        var role = new ProfessionType();
        role.ProfessionName = model.ProfessionName;
        role.Description = model.Description;
        role.Path = model.Path;
  
        _context.ProfessionTypes.Add(role);
        _context.SaveChanges();
    }

    public void Update(int id, professionC model)
    {
        var role = getProfession(id);
        role.ProfessionName = model.ProfessionName;
        role.Description = model.Description;
        role.Path = model.Description;

        _context.ProfessionTypes.Update(role);
        _context.SaveChanges();
    }

    public void Delete(int id)
    {
        var role = getProfession(id);
        _context.ProfessionTypes.Remove(role);
        _context.SaveChanges();
    }

    // helper methods

    private ProfessionType getProfession(int id)
    {
        var role = _context.ProfessionTypes.Find(id);
        if (role == null) throw new KeyNotFoundException("profession not found");
        return role;
    }
  
     
}