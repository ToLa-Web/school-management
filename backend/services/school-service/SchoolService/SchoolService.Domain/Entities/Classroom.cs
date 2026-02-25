namespace SchoolService.Domain.Entities;

public class Classroom
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public string Name { get; private set; } = null!;
    public string? Grade { get; private set; }
    public string? AcademicYear { get; private set; }
    public Guid? TeacherId { get; private set; }
    public bool IsActive { get; private set; } = true;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;

    public Teacher? Teacher { get; private set; }

    private readonly List<StudentClassroom> _studentClassrooms = new();
    public IReadOnlyCollection<StudentClassroom> StudentClassrooms => _studentClassrooms;

    public Classroom(string name)
    {
        UpdateInfo(name, null, null);
    }

    public void UpdateInfo(
        string name,
        string? grade,
        string? academicYear)
    {
        Name = name.Trim();
        Grade = string.IsNullOrWhiteSpace(grade) ? null : grade.Trim();
        AcademicYear = string.IsNullOrWhiteSpace(academicYear) ? null : academicYear.Trim();
    }

    public void AssignTeacher(Guid? teacherId)
    {
        TeacherId = teacherId;
    }

    public void Deactivate() => IsActive = false;
    public void Activate() => IsActive = true;
}
