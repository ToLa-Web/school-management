using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SchoolService.Application.DTOs.Classrooms;
using SchoolService.Application.Interfaces;

namespace SchoolService.API.Controllers;

[ApiController]
[Route("api/school/[controller]")]
[Authorize]
public class ClassroomsController : ControllerBase
{
    private readonly IClassroomService _classroomService;

    public ClassroomsController(IClassroomService classroomService)
    {
        _classroomService = classroomService;
    }

    [HttpGet]
    public async Task<ActionResult<IReadOnlyList<ClassroomResponseDto>>> GetAll()
    {
        var classrooms = await _classroomService.GetAllAsync();
        return Ok(classrooms);
    }

    [HttpGet("{id:guid}")]
    public async Task<ActionResult<ClassroomDetailResponseDto>> GetById(Guid id)
    {
        var classroom = await _classroomService.GetByIdAsync(id);
        if (classroom == null)
        {
            return NotFound();
        }

        return Ok(classroom);
    }

    [HttpPost]
    public async Task<ActionResult<ClassroomResponseDto>> Create([FromBody] ClassroomCreateDto dto)
    {
        var created = await _classroomService.CreateAsync(dto);
        return CreatedAtAction(nameof(GetById), new { id = created.Id }, created);
    }

    [HttpPut("{id:guid}")]
    public async Task<ActionResult<ClassroomResponseDto>> Update(Guid id, [FromBody] ClassroomUpdateDto dto)
    {
        var updated = await _classroomService.UpdateAsync(id, dto);
        if (updated == null)
        {
            return NotFound();
        }

        return Ok(updated);
    }

    [HttpDelete("{id:guid}")]
    public async Task<IActionResult> Delete(Guid id)
    {
        var deleted = await _classroomService.DeleteAsync(id);
        if (!deleted)
        {
            return NotFound();
        }

        return NoContent();
    }

    [HttpPost("{id:guid}/enroll")]
    public async Task<IActionResult> EnrollStudent(Guid id, [FromBody] EnrollStudentDto dto)
    {
        var result = await _classroomService.EnrollStudentAsync(id, dto.StudentId);
        if (!result)
        {
            return BadRequest(new { message = "Enrollment failed. Classroom or student not found, or student already enrolled." });
        }

        return Ok(new { message = "Student enrolled successfully." });
    }

    [HttpDelete("{id:guid}/unenroll/{studentId:guid}")]
    public async Task<IActionResult> UnenrollStudent(Guid id, Guid studentId)
    {
        var result = await _classroomService.UnenrollStudentAsync(id, studentId);
        if (!result)
        {
            return NotFound(new { message = "Enrollment not found." });
        }

        return NoContent();
    }
}
