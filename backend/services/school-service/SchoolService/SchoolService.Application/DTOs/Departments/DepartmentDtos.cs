using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Departments;

public class DepartmentCreateDto
{
    [Required(ErrorMessage = "Name is required.")]
    [StringLength(100)]
    public string Name { get; set; } = null!;

    [StringLength(500)]
    public string? Description { get; set; }
}

public class DepartmentUpdateDto
{
    [Required(ErrorMessage = "Name is required.")]
    [StringLength(100)]
    public string Name { get; set; } = null!;

    [StringLength(500)]
    public string? Description { get; set; }
}

public class DepartmentResponseDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = null!;
    public string? Description { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
}

public class DepartmentDetailDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = null!;
    public string? Description { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public int SubjectCount { get; set; }
    public int TeacherCount { get; set; }
    public List<SubjectBasicDto> Subjects { get; set; } = new();
    public List<TeacherBasicDto> Teachers { get; set; } = new();
}

public class SubjectBasicDto
{
    public Guid Id { get; set; }
    public string SubjectName { get; set; } = null!;
    public string? Code { get; set; }
}

public class TeacherBasicDto
{
    public Guid Id { get; set; }
    public string FirstName { get; set; } = null!;
    public string LastName { get; set; } = null!;
    public string? Email { get; set; }
}
