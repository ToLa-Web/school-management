using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Teachers;

public class TeacherDepartmentAssignDto
{
    [Required(ErrorMessage = "DepartmentId is required.")]
    public Guid DepartmentId { get; set; }
}

public class TeacherDepartmentResponseDto
{
    public Guid DepartmentId { get; set; }
    public string DepartmentName { get; set; } = null!;
}
