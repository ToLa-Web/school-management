using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SchoolService.Application.DTOs;
using SchoolService.Application.DTOs.Teachers;
using SchoolService.Application.Interfaces;

namespace SchoolService.API.Controllers;

[ApiController]
[Route("api/school/[controller]")]
[Authorize]
public class TeachersController : ControllerBase
{
    private readonly ITeacherService _teacherService;

    public TeachersController(ITeacherService teacherService)
    {
        _teacherService = teacherService;
    }

    [HttpGet]
    public async Task<ActionResult> GetAll(
        [FromQuery] int? page,
        [FromQuery] int? pageSize)
    {
        if (page.HasValue || pageSize.HasValue)
        {
            var paged = await _teacherService.GetAllAsync(page ?? 1, pageSize ?? 20);
            return Ok(paged);
        }
        var teachers = await _teacherService.GetAllAsync();
        return Ok(teachers);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<TeacherResponseDto>> GetById(Guid id)
    {
        var teacher = await _teacherService.GetByIdAsync(id);
        return Ok(teacher);
    }

    [HttpPost]
    public async Task<ActionResult<TeacherResponseDto>> Create([FromBody] TeacherCreateDto dto)
    {
        var created = await _teacherService.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id:guid}")]
    public async Task<ActionResult<TeacherResponseDto>> Update(Guid id, [FromBody] TeacherUpdateDto dto)
    {
        var updated = await _teacherService.UpdateAsync(id, dto);
        return Ok(updated);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        await _teacherService.DeleteAsync(id);
        return NoContent();
    }
}
