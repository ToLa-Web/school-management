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
    public bool IsActive { get; private set; } = true;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;

    private readonly List<StudentClassroom> _studentClassrooms = new();
    public IReadOnlyCollection<StudentClassroom> StudentClassrooms => _studentClassrooms;

    public Student(string firstName, string lastName)
    {
        UpdateBasicInfo(firstName, lastName, null, null, null, null);
    }

    public void UpdateBasicInfo(
        string firstName,
        string lastName,
        string? gender,
        DateTime? dateOfBirth,
        string? phone,
        string? address)
    {
        FirstName = firstName.Trim();
        LastName = lastName.Trim();
        Gender = string.IsNullOrWhiteSpace(gender) ? null : gender.Trim();
        DateOfBirth = dateOfBirth;
        Phone = string.IsNullOrWhiteSpace(phone) ? null : phone.Trim();
        Address = string.IsNullOrWhiteSpace(address) ? null : address.Trim();
    }

    public void Deactivate() => IsActive = false;
    public void Activate() => IsActive = true;
}

