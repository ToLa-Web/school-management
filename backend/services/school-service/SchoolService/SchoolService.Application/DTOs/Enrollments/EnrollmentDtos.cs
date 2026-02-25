using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Enrollments;

public class EnrollStudentInSubjectDto
{
    [Required]
    public Guid StudentId { get; set; }

    [Required]
    public Guid SubjectId { get; set; }
}

public class EnrollmentResponseDto
{
    public Guid Id { get; set; }
    public Guid StudentId { get; set; }
    public string StudentName { get; set; } = null!;
    public Guid SubjectId { get; set; }
    public string SubjectName { get; set; } = null!;
    public DateTime EnrolledAt { get; set; }
}
