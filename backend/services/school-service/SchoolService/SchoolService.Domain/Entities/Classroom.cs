namespace SchoolService.Domain.Entities;

public class Classroom
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public string Name { get; private set; } = null!;
    public string? Grade { get; private set; }
    public string? AcademicYear { get; private set; }
    public string? Semester { get; private set; }
    public Guid? RoomId { get; private set; }
    public Guid? TeacherId { get; private set; }
    public bool IsActive { get; private set; } = true;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;
    /// <summary>Soft-delete. Cascade-deactivates linked Schedules and Materials at the service layer.</summary>
    public DateTime? DeletedAt { get; private set; }

    public Teacher? Teacher { get; private set; }
    public Room? Room { get; private set; }

    private readonly List<StudentClassroom> _studentClassrooms = new();
    public IReadOnlyCollection<StudentClassroom> StudentClassrooms => _studentClassrooms;

    public Classroom(string name)
    {
        UpdateInfo(name, null, null, null, null);
    }

    public void UpdateInfo(
        string name,
        string? grade,
        string? academicYear,
        string? semester,
        Guid? roomId)
    {
        Name         = name.Trim();
        Grade        = string.IsNullOrWhiteSpace(grade) ? null : grade.Trim();
        AcademicYear = string.IsNullOrWhiteSpace(academicYear) ? null : academicYear.Trim();
        Semester     = string.IsNullOrWhiteSpace(semester) ? null : semester.Trim();
        RoomId       = roomId;
    }

    public void AssignTeacher(Guid? teacherId) => TeacherId = teacherId;

    public void Deactivate() => IsActive = false;
    public void Activate()   => IsActive = true;

    /// <summary>Marks as soft-deleted. The service layer must also soft-delete Schedules and Materials.</summary>
    public void SoftDelete()
    {
        DeletedAt = DateTime.UtcNow;
        IsActive  = false;
    }

    public bool IsDeleted => DeletedAt.HasValue;
}
