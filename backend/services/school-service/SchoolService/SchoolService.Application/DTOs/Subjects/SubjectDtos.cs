using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Subjects;

public class SubjectCreateDto
{
    [Required(ErrorMessage = "SubjectName is required.")]
    [StringLength(150)]
    public string SubjectName { get; set; } = null!;
}

public class SubjectUpdateDto
{
    [Required(ErrorMessage = "SubjectName is required.")]
    [StringLength(150)]
    public string SubjectName { get; set; } = null!;
}

public class SubjectResponseDto
{
    public Guid Id { get; set; }
    public string SubjectName { get; set; } = null!;
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<string> TeacherNames { get; set; } = new();
}

public class AssignTeacherToSubjectDto
{
    [Required]
    public Guid TeacherId { get; set; }
}
