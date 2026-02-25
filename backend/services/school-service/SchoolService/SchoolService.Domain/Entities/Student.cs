namespace SchoolService.Domain.Entities;

public class Student
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public string FirstName { get; private set; } = null!;
    public string LastName { get; private set; } = null!;
    public string? Gender { get; private set; }
    public DateTime? DateOfBirth { get; private set; }
    public string? Phone { get; private set; }
    public string? Address { get; private set; }
    public string? Email { get; private set; }
    public bool IsActive { get; private set; } = true;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;

    private readonly List<StudentClassroom> _studentClassrooms = new();
    public IReadOnlyCollection<StudentClassroom> StudentClassrooms => _studentClassrooms;

    private readonly List<Enrollment> _enrollments = new();
    public IReadOnlyCollection<Enrollment> Enrollments => _enrollments;

    private readonly List<Attendance> _attendances = new();
    public IReadOnlyCollection<Attendance> Attendances => _attendances;

    private readonly List<StudentGrade> _grades = new();
    public IReadOnlyCollection<StudentGrade> Grades => _grades;

    public Student(string firstName, string lastName)
    {
        UpdateBasicInfo(firstName, lastName, null, null, null, null, null);
    }

    public void UpdateBasicInfo(
        string firstName,
        string lastName,
        string? gender,
        DateTime? dateOfBirth,
        string? phone,
        string? address,
        string? email = null)
    {
        FirstName = firstName.Trim();
        LastName = lastName.Trim();
        Gender = string.IsNullOrWhiteSpace(gender) ? null : gender.Trim();
        DateOfBirth = dateOfBirth;
        Phone = string.IsNullOrWhiteSpace(phone) ? null : phone.Trim();
        Address = string.IsNullOrWhiteSpace(address) ? null : address.Trim();
        Email = string.IsNullOrWhiteSpace(email) ? null : email.Trim();
    }

    public void Deactivate() => IsActive = false;
    public void Activate() => IsActive = true;
}

