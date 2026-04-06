namespace SchoolService.Domain.Entities;

public enum SchoolDayOfWeek
{
    Monday    = 1,
    Tuesday   = 2,
    Wednesday = 3,
    Thursday  = 4,
    Friday    = 5,
    Saturday  = 6,
    Sunday    = 7
}

public enum SessionType
{
    Regular      = 1,
    MakeUp       = 2,
    Consultation = 3
}

public class Schedule
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public Guid ClassroomId { get; private set; }
    public Guid SubjectId { get; private set; }
    public Guid? TeacherId { get; private set; }
    public SchoolDayOfWeek DayOfWeek { get; private set; }
    public TimeOnly StartTime { get; private set; }
    public TimeOnly EndTime { get; private set; }
    public SessionType Type { get; private set; } = SessionType.Regular;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;
    public DateTime? DeletedAt { get; private set; }

    public Classroom Classroom { get; private set; } = null!;
    public Subject Subject { get; private set; } = null!;
    public Teacher? Teacher { get; private set; }

    private Schedule() { } // EF

    public Schedule(Guid classroomId, Guid subjectId, Guid? teacherId,
        SchoolDayOfWeek dayOfWeek, TimeOnly startTime, TimeOnly endTime,
        SessionType type = SessionType.Regular)
    {
        ClassroomId = classroomId;
        SubjectId   = subjectId;
        TeacherId   = teacherId;
        UpdateInfo(dayOfWeek, startTime, endTime, type);
    }

    public void UpdateInfo(SchoolDayOfWeek dayOfWeek, TimeOnly startTime, TimeOnly endTime, SessionType type)
    {
        if (endTime <= startTime)
            throw new ArgumentException("EndTime must be after StartTime.");
        DayOfWeek = dayOfWeek;
        StartTime = startTime;
        EndTime   = endTime;
        Type      = type;
    }

    public void UpdateTeacher(Guid? teacherId) => TeacherId = teacherId;

    public void SoftDelete() => DeletedAt = DateTime.UtcNow;
    public bool IsDeleted => DeletedAt.HasValue;
}
