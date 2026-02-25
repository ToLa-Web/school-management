namespace SchoolService.Domain.Entities;

public class Subject
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public string SubjectName { get; private set; } = null!;
    public bool IsActive { get; private set; } = true;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;

    private readonly List<TeacherSubject> _teacherSubjects = new();
    public IReadOnlyCollection<TeacherSubject> TeacherSubjects => _teacherSubjects;

    private readonly List<Enrollment> _enrollments = new();
    public IReadOnlyCollection<Enrollment> Enrollments => _enrollments;

    private readonly List<StudentGrade> _grades = new();
    public IReadOnlyCollection<StudentGrade> Grades => _grades;

    private readonly List<Schedule> _schedules = new();
    public IReadOnlyCollection<Schedule> Schedules => _schedules;

    private Subject() { } // EF

    public Subject(string subjectName)
    {
        UpdateInfo(subjectName);
    }

    public void UpdateInfo(string subjectName)
    {
        SubjectName = subjectName.Trim();
    }

    public void Deactivate() => IsActive = false;
    public void Activate() => IsActive = true;
}
