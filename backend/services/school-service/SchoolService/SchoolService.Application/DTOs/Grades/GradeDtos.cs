using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Grades;

public class GradeCreateDto
{
    [Required]
    public Guid StudentId { get; set; }

    [Required]
    public Guid SubjectId { get; set; }

    [Required]
    [Range(0, 100, ErrorMessage = "Score must be 0–100.")]
    public decimal Score { get; set; }

    [Required]
    [StringLength(20)]
    public string Semester { get; set; } = null!;
}

public class GradeUpdateDto
{
    [Required]
    [Range(0, 100, ErrorMessage = "Score must be 0–100.")]
    public decimal Score { get; set; }

    [Required]
    [StringLength(20)]
    public string Semester { get; set; } = null!;
}

public class GradeResponseDto
{
    public Guid Id { get; set; }
    public Guid StudentId { get; set; }
    public string StudentName { get; set; } = null!;
    public Guid SubjectId { get; set; }
    public string SubjectName { get; set; } = null!;
    public decimal Score { get; set; }
    public string Semester { get; set; } = null!;
    public DateTime CreatedAt { get; set; }
}
