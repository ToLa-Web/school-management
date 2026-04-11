using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SchoolService.Application.DTOs;
using SchoolService.Application.DTOs.Students;
using SchoolService.Application.Interfaces;

namespace SchoolService.API.Controllers;

[ApiController]
[Route("api/school/[controller]")]
[Authorize]
public class StudentsController : ControllerBase
{
    private readonly IStudentService _studentService;
    private readonly IClassroomService _classroomService;

    public StudentsController(IStudentService studentService, IClassroomService classroomService)
    {
        _studentService = studentService;
        _classroomService = classroomService;
    }

    [HttpGet]
    public async Task<ActionResult> GetAll(
        [FromQuery] int? page,
        [FromQuery] int? pageSize)
    {
        if (page.HasValue || pageSize.HasValue)
        {
            var paged = await _studentService.GetAllAsync(page ?? 1, pageSize ?? 20);
            return Ok(paged);
        }
        var students = await _studentService.GetAllAsync();
        return Ok(students);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<StudentResponseDto>> GetById(Guid id)
    {
        var student = await _studentService.GetByIdAsync(id);
        return Ok(student);
    }

    [HttpGet("by-auth-user/{authUserId:guid}")]
    public async Task<ActionResult<StudentResponseDto>> GetByAuthUserId(Guid authUserId)
    {
        var student = await _studentService.GetByAuthUserIdAsync(authUserId);
        if (student == null)
            return NotFound();

        return Ok(student);
    }

    [HttpGet("{id:guid}/classrooms")]
    public async Task<ActionResult> GetClassrooms(Guid id)
    {
        var classrooms = await _classroomService.GetByStudentIdAsync(id);
        return Ok(classrooms);
    }

    [HttpPost]
    public async Task<ActionResult<StudentResponseDto>> Create([FromBody] StudentCreateDto dto)
    {
        var created = await _studentService.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id:guid}")]
    public async Task<ActionResult<StudentResponseDto>> Update(Guid id, [FromBody] StudentUpdateDto dto)
    {
        var updated = await _studentService.UpdateAsync(id, dto);
        return Ok(updated);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        await _studentService.DeleteAsync(id);
        return NoContent();
    }
}
