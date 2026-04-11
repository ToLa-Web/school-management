namespace SchoolService.Domain.Entities;

public class Subject
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public string SubjectName { get; private set; } = null!;
    public Guid DepartmentId { get; private set; }
    public bool IsActive { get; private set; } = true;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;
    public DateTime? DeletedAt { get; private set; }

    public string? Category { get; private set; }
    public string? Description { get; private set; }
    public string? Code { get; private set; }

    public Department Department { get; private set; } = null!;

    private readonly List<TeacherSubject> _teacherSubjects = new();
    public IReadOnlyCollection<TeacherSubject> TeacherSubjects => _teacherSubjects;

    private readonly List<StudentGrade> _grades = new();
    public IReadOnlyCollection<StudentGrade> Grades => _grades;

    private readonly List<Schedule> _schedules = new();
    public IReadOnlyCollection<Schedule> Schedules => _schedules;

    private Subject() { } // EF

    public Subject(string subjectName, Guid departmentId, string? category = null, string? description = null, string? code = null)
    {
        UpdateInfo(subjectName, departmentId, category, description, code);
    }

    public void UpdateInfo(string subjectName, Guid departmentId, string? category = null, string? description = null, string? code = null)
    {
        if (departmentId == Guid.Empty)
            throw new ArgumentException("DepartmentId cannot be empty", nameof(departmentId));

        SubjectName = subjectName.Trim();
        DepartmentId = departmentId;
        Category = category?.Trim();
        Description = description?.Trim();
        Code = code?.Trim();
    }

    public void Deactivate() => IsActive = false;
    public void Activate()   => IsActive = true;
    public void SoftDelete() => DeletedAt = DateTime.UtcNow;
    public bool IsDeleted    => DeletedAt.HasValue;
}
