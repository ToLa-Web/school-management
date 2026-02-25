namespace SchoolService.Domain.Entities;

public class Teacher
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public string FirstName { get; private set; } = null!;
    public string LastName { get; private set; } = null!;
    public string? Gender { get; private set; }
    public DateTime? DateOfBirth { get; private set; }
    public string? Phone { get; private set; }
    public string? Email { get; private set; }
    public string? Specialization { get; private set; }
    public bool IsActive { get; private set; } = true;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;

    private readonly List<Classroom> _classrooms = new();
    public IReadOnlyCollection<Classroom> Classrooms => _classrooms;

    private readonly List<TeacherSubject> _teacherSubjects = new();
    public IReadOnlyCollection<TeacherSubject> TeacherSubjects => _teacherSubjects;

    private readonly List<Schedule> _schedules = new();
    public IReadOnlyCollection<Schedule> Schedules => _schedules;

    public Teacher(string firstName, string lastName)
    {
        UpdateBasicInfo(firstName, lastName, null, null, null, null, null);
    }

    public void UpdateBasicInfo(
        string firstName,
        string lastName,
        string? gender,
        DateTime? dateOfBirth,
        string? phone,
        string? email,
        string? specialization)
    {
        FirstName = firstName.Trim();
        LastName = lastName.Trim();
        Gender = string.IsNullOrWhiteSpace(gender) ? null : gender.Trim();
        DateOfBirth = dateOfBirth;
        Phone = string.IsNullOrWhiteSpace(phone) ? null : phone.Trim();
        Email = string.IsNullOrWhiteSpace(email) ? null : email.Trim();
        Specialization = string.IsNullOrWhiteSpace(specialization) ? null : specialization.Trim();
    }

    public void Deactivate() => IsActive = false;
    public void Activate() => IsActive = true;
}
