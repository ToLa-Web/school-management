namespace SchoolService.Domain.Entities;

/// <summary>Many-to-many join: Teacher ↔ Subject</summary>
public class TeacherSubject
{
    public Guid TeacherId { get; private set; }
    public Guid SubjectId { get; private set; }

    public Teacher Teacher { get; private set; } = null!;
    public Subject Subject { get; private set; } = null!;

    private TeacherSubject() { } // EF

    public TeacherSubject(Guid teacherId, Guid subjectId)
    {
        TeacherId = teacherId;
        SubjectId = subjectId;
    }
}
