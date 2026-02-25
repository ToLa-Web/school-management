namespace SchoolService.Domain.Entities;

public enum AttendanceStatus
{
    Present = 1,
    Absent  = 2,
    Late    = 3
}

public class Attendance
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public Guid StudentId { get; private set; }
    public Guid? ClassroomId { get; private set; }
    public DateOnly Date { get; private set; }
    public AttendanceStatus Status { get; private set; }
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;

    public Student Student { get; private set; } = null!;
    public Classroom? Classroom { get; private set; }

    private Attendance() { } // EF

    public Attendance(Guid studentId, Guid? classroomId, DateOnly date, AttendanceStatus status)
    {
        StudentId = studentId;
        ClassroomId = classroomId;
        Update(date, status);
    }

    public void Update(DateOnly date, AttendanceStatus status)
    {
        Date = date;
        Status = status;
    }
}
