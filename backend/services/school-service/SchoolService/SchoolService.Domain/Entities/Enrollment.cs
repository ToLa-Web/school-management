namespace SchoolService.Domain.Entities;

/// <summary>Many-to-many join: Student ↔ Subject</summary>
public class Enrollment
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public Guid StudentId { get; private set; }
    public Guid SubjectId { get; private set; }
    public DateTime EnrolledAt { get; private set; } = DateTime.UtcNow;

    public Student Student { get; private set; } = null!;
    public Subject Subject { get; private set; } = null!;

    private Enrollment() { } // EF

    public Enrollment(Guid studentId, Guid subjectId)
    {
        StudentId = studentId;
        SubjectId = subjectId;
    }
}
