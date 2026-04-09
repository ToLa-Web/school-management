namespace SchoolService.Domain.Entities;

public class Subject
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public string SubjectName { get; private set; } = null!;
    public bool IsActive { get; private set; } = true;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;
    public DateTime? DeletedAt { get; private set; }

    public string? Category { get; private set; }
    public string? Department { get; private set; }
    public string? Description { get; private set; }
    public string? Code { get; private set; }

    private readonly List<TeacherSubject> _teacherSubjects = new();
    public IReadOnlyCollection<TeacherSubject> TeacherSubjects => _teacherSubjects;

    private readonly List<StudentGrade> _grades = new();
    public IReadOnlyCollection<StudentGrade> Grades => _grades;

    private readonly List<Schedule> _schedules = new();
    public IReadOnlyCollection<Schedule> Schedules => _schedules;

    private Subject() { } // EF

    public Subject(string subjectName, string? category = null, string? department = null, string? description = null, string? code = null)
    {
        UpdateInfo(subjectName, category, department, description, code);
    }

    public void UpdateInfo(string subjectName, string? category = null, string? department = null, string? description = null, string? code = null)
    {
        SubjectName = subjectName.Trim();
        Category = category?.Trim();
        Department = department?.Trim();
        Description = description?.Trim();
        Code = code?.Trim();
    }

    public void Deactivate() => IsActive = false;
    public void Activate()   => IsActive = true;
    public void SoftDelete() => DeletedAt = DateTime.UtcNow;
    public bool IsDeleted    => DeletedAt.HasValue;
}
