namespace WebApi.Controllers;

using AutoMapper;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using WebApi.Models.Profession;
using WebApi.Services;

[ApiController]
[Route("[controller]")]
public class ProfessionController : ControllerBase
{
    private IProfessionService professionService;
    private IMapper _mapper;

    public ProfessionController(
        IProfessionService _professionService,
        IMapper mapper)
    {
        professionService = _professionService; 
        _mapper = mapper;
    }
    [HttpGet]
    public IActionResult GetAll()
    {
        var professions = professionService.GetAll();
        return Ok(professions);
    }

    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        var profession = professionService.GetById(id);
        return Ok(profession);
    }
    [AllowAnonymous]
    [HttpPost("createProfession")]
    public IActionResult Create(ProfessionCustom model)
    {
        professionService.Create(model);
        return Ok(new { message = "User created" });
    }

    [AllowAnonymous]
    [HttpPost("updateProfession")]
    public IActionResult Update( ProfessionCustom model)
    {
        professionService.Update(model.Id.Value, model);
        return Ok(new { message = "Profession updated" });
    }

    [HttpPost("deleteProfession")]
    public IActionResult Delete(ProfessionCustom model)
    {
        professionService.Delete(model.Id.Value);
        return Ok(new { message = "Profession deleted" });
    }

    [AllowAnonymous]
    [HttpPost("activeProfession")]
    public IActionResult ActiveProfession(ProfessionCustom model)
    {
        professionService.ActiveProfession(model);
        return Ok(new { message = "Profession Acive" });
    }

    [AllowAnonymous]
    [HttpGet("GetProfessionByTypeId/{professionTypeId}")]
    public IActionResult GetProfessionByTypeId(int? professionTypeId)
    {
        var professionList = professionService.GetProfessionByTypeId(professionTypeId);
        return Ok(professionList);
    }

}