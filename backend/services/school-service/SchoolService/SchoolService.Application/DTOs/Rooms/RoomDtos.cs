using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Rooms;

public class RoomCreateDto
{
    [Required]
    [StringLength(100)]
    public string Name { get; set; } = null!;

    [StringLength(250)]
    public string? Location { get; set; }

    [Range(0, 10000)]
    public int Capacity { get; set; }

    /// <summary>1=Classroom, 2=Lab, 3=Gym, 4=Auditorium</summary>
    [Range(1, 4)]
    public int Type { get; set; } = 1;
}

public class RoomUpdateDto
{
    [Required]
    [StringLength(100)]
    public string Name { get; set; } = null!;

    [StringLength(250)]
    public string? Location { get; set; }

    [Range(0, 10000)]
    public int Capacity { get; set; }

    [Range(1, 4)]
    public int Type { get; set; } = 1;

    public bool IsActive { get; set; }
}

public class RoomResponseDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = null!;
    public string? Location { get; set; }
    public int Capacity { get; set; }
    public int Type { get; set; }
    public string TypeName { get; set; } = null!;
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
}
