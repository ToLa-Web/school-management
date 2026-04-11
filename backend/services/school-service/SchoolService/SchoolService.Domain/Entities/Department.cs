namespace SchoolService.Domain.Entities;

public class Department
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public string Name { get; private set; } = null!;
    public string? Description { get; private set; }
    public bool IsActive { get; private set; } = true;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;
    public DateTime? DeletedAt { get; private set; }

    private readonly List<Subject> _subjects = new();
    public IReadOnlyCollection<Subject> Subjects => _subjects;

    private readonly List<TeacherDepartment> _teacherDepartments = new();
    public IReadOnlyCollection<TeacherDepartment> TeacherDepartments => _teacherDepartments;

    private Department() { } // EF

    public Department(string name, string? description = null)
    {
        UpdateInfo(name, description);
    }

    public void UpdateInfo(string name, string? description = null)
    {
        if (string.IsNullOrWhiteSpace(name))
            throw new ArgumentException("Department name cannot be empty", nameof(name));

        Name = name.Trim();
        if (Name.Length > 100)
            throw new ArgumentException("Department name cannot exceed 100 characters", nameof(name));

        Description = description?.Trim();
        if (Description?.Length > 500)
            throw new ArgumentException("Department description cannot exceed 500 characters", nameof(description));
    }

    public void Activate() => IsActive = true;
    public void Deactivate() => IsActive = false;
    public void SoftDelete() => DeletedAt = DateTime.UtcNow;
    public bool IsDeleted => DeletedAt.HasValue;
}
