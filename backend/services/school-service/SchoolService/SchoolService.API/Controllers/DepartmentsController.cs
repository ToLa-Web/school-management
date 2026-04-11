using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SchoolService.Application.DTOs.Departments;
using SchoolService.Application.Interfaces;

namespace SchoolService.API.Controllers;

[ApiController]
[Route("api/school/[controller]")]
[Authorize]
public class DepartmentsController : ControllerBase
{
    private readonly IDepartmentService _departmentService;

    public DepartmentsController(IDepartmentService departmentService) => _departmentService = departmentService;

    [HttpGet]
    public async Task<ActionResult> GetAll()
    {
        var departments = await _departmentService.GetAllAsync();
        return Ok(departments);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<DepartmentResponseDto>> GetById(Guid id)
    {
        var department = await _departmentService.GetByIdAsync(id);
        return Ok(department);
    }

    [HttpGet("{id:guid}/detail")]
    public async Task<ActionResult<DepartmentDetailDto>> GetByIdDetail(Guid id)
    {
        var department = await _departmentService.GetByIdDetailAsync(id);
        return Ok(department);
    }

    [HttpPost]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<DepartmentResponseDto>> Create([FromBody] DepartmentCreateDto dto)
    {
        var created = await _departmentService.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id:guid}")]
    [Authorize(Roles = "Admin")]
    public async Task<ActionResult<DepartmentResponseDto>> Update(Guid id, [FromBody] DepartmentUpdateDto dto)
    {
        var updated = await _departmentService.UpdateAsync(id, dto);
        return Ok(updated);
    }

    [HttpDelete("{id:guid}")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Delete(Guid id)
    {
        await _departmentService.DeleteAsync(id);
        return NoContent();
    }

    [HttpPost("{departmentId:guid}/assign-teacher/{teacherId:guid}")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> AssignTeacher(Guid departmentId, Guid teacherId)
    {
        await _departmentService.AssignTeacherAsync(teacherId, departmentId);
        return Ok();
    }

    [HttpDelete("{departmentId:guid}/remove-teacher/{teacherId:guid}")]
    [Authorize(Roles = "Admin")]
    public async Task<IActionResult> RemoveTeacher(Guid departmentId, Guid teacherId)
    {
        await _departmentService.RemoveTeacherAsync(teacherId, departmentId);
        return NoContent();
    }
}
