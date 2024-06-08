namespace WebApi.Controllers;

using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using WebApi.Models.Role;
using WebApi.Services;

[ApiController]
[Route("[controller]")]
public class RoleController : ControllerBase
{
    private IRoleService roleService;
    private IMapper _mapper;

    public RoleController(
        IRoleService _roleService,
        IMapper mapper)
    {
        roleService = _roleService;
        _mapper = mapper;
    }
    [HttpGet]
    public IActionResult GetAll()
    {
        var roles = roleService.GetAll();
        return Ok(roles);
    }

    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        var role = roleService.GetById(id);
        return Ok(role);
    }
    [HttpPost("createRole")]
    public IActionResult Create(RoleCustom model)
    {
        roleService.Create(model);
        return Ok(new { message = "role created" });
    }

    [HttpPost("updateRole")]
    public IActionResult Update( RoleCustom model)
    {
        roleService.Update(model.Id.Value, model);
        return Ok(new { message = "Role updated" });
    }

    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        roleService.Delete(id);
        return Ok(new { message = "User deleted" });
    }

}