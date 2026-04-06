using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Subjects;

public class SubjectCreateDto
{
    [Required(ErrorMessage = "SubjectName is required.")]
    [StringLength(150)]
    public string SubjectName { get; set; } = null!;
    public int YearLevel { get; set; }
    public string? Category { get; set; }
    public string? Department { get; set; }
    public string? Description { get; set; }
    public string? Code { get; set; }
}

public class SubjectUpdateDto
{
    [Required(ErrorMessage = "SubjectName is required.")]
    [StringLength(150)]
    public string SubjectName { get; set; } = null!;
    public int YearLevel { get; set; }
    public string? Category { get; set; }
    public string? Department { get; set; }
    public string? Description { get; set; }
    public string? Code { get; set; }
}

public class SubjectResponseDto
{
    public Guid Id { get; set; }
    public string SubjectName { get; set; } = null!;
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<string> TeacherNames { get; set; } = new();
    public int YearLevel { get; set; }
    public string? Category { get; set; }
    public string? Department { get; set; }
    public string? Description { get; set; }
    public string? Code { get; set; }
}

public class AssignTeacherToSubjectDto
{
    [Required]
    public Guid TeacherId { get; set; }
}
