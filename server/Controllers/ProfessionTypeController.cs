namespace WebApi.Controllers;

using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WebApi.Models.Profession;
using WebApi.Services;

[ApiController]
[Route("[controller]")]
public class ProfessionTypeController : ControllerBase
{
    private IProfessionTypeService professionTypeService;
    private IMapper _mapper;

    public ProfessionTypeController(
        IProfessionTypeService _professionTypeService,
        IMapper mapper)
    {
        professionTypeService = _professionTypeService; 
        _mapper = mapper;
    }
    [HttpGet]
    public IActionResult GetAll()
    {
        var professions = professionTypeService.GetAll();
        return Ok(professions);
    }

    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        var profession = professionTypeService.GetById(id);
        return Ok(profession);
    }
    [AllowAnonymous]
    [HttpPost("createProfessionType")]
    public IActionResult Create(professionC model)
    {
        professionTypeService.Create(model);
        return Ok(new { message = "User created" });
    }

    [AllowAnonymous]
    [HttpPost("updateProfessionType")]
    public IActionResult Update( professionC model)
    {
        professionTypeService.Update(model.Id.Value, model);
        return Ok(new { message = "Profession type updated" });
    }

    [HttpPost("deleteProfessionType")]
    public IActionResult Delete(professionC model)
    {
        professionTypeService.Delete(model.Id.Value);
        return Ok(new { message = "Profession type deleted" });
    }

}