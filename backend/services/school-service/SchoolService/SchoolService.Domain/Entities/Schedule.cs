namespace SchoolService.Domain.Entities;

public class Schedule
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public Guid ClassroomId { get; private set; }
    public Guid SubjectId { get; private set; }
    public Guid? TeacherId { get; private set; }
    /// <summary>e.g. "Monday", "Tuesday"</summary>
    public string Day { get; private set; } = null!;
    /// <summary>e.g. "08:00-09:00"</summary>
    public string Time { get; private set; } = null!;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;

    public Classroom Classroom { get; private set; } = null!;
    public Subject Subject { get; private set; } = null!;
    public Teacher? Teacher { get; private set; }

    private Schedule() { } // EF

    public Schedule(Guid classroomId, Guid subjectId, Guid? teacherId, string day, string time)
    {
        ClassroomId = classroomId;
        SubjectId = subjectId;
        Update(teacherId, day, time);
    }

    public void Update(Guid? teacherId, string day, string time)
    {
        TeacherId = teacherId;
        Day = day.Trim();
        Time = time.Trim();
    }
}
