namespace SchoolService.Domain.Entities;

public enum RoomType
{
    Classroom  = 1,
    Lab        = 2,
    Gym        = 3,
    Auditorium = 4
}

public class Room
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public string Name { get; private set; } = null!;
    public string? Location { get; private set; }
    public int Capacity { get; private set; }
    public RoomType Type { get; private set; } = RoomType.Classroom;
    public bool IsActive { get; private set; } = true;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;
    public DateTime? DeletedAt { get; private set; }

    private readonly List<Classroom> _classrooms = new();
    public IReadOnlyCollection<Classroom> Classrooms => _classrooms;

    private Room() { } // EF

    public Room(string name, string? location = null, int capacity = 0, RoomType type = RoomType.Classroom)
    {
        UpdateInfo(name, location, capacity, type);
    }

    public void UpdateInfo(string name, string? location, int capacity = 0, RoomType type = RoomType.Classroom)
    {
        Name     = name.Trim();
        Location = string.IsNullOrWhiteSpace(location) ? null : location.Trim();
        Capacity = capacity < 0 ? 0 : capacity;
        Type     = type;
    }

    public void Deactivate() => IsActive = false;
    public void Activate()   => IsActive = true;
    public void SoftDelete() => DeletedAt = DateTime.UtcNow;
    public bool IsDeleted    => DeletedAt.HasValue;
}
