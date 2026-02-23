namespace SchoolService.Domain.Entities;

public class StudentClassroom
{
    public Guid StudentId { get; private set; }
    public Guid ClassroomId { get; private set; }
    public DateTime EnrolledAt { get; private set; } = DateTime.UtcNow;

    public Student Student { get; private set; } = null!;
    public Classroom Classroom { get; private set; } = null!;

    private StudentClassroom() { } // EF

    public StudentClassroom(Guid studentId, Guid classroomId)
    {
        StudentId = studentId;
        ClassroomId = classroomId;
    }
}
