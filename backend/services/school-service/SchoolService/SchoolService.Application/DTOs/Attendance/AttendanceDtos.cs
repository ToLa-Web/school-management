using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Attendance;

public class AttendanceMarkDto
{
    [Required]
    public Guid StudentId { get; set; }

    /// <summary>1=Present, 2=Absent, 3=Late</summary>
    [Required]
    [Range(1, 3)]
    public int Status { get; set; }
}

public class BulkMarkAttendanceDto
{
    [Required]
    public Guid ClassroomId { get; set; }

    [Required]
    public DateOnly Date { get; set; }

    [Required]
    [MinLength(1)]
    public List<AttendanceMarkDto> Records { get; set; } = new();
}

public class AttendanceResponseDto
{
    public Guid Id { get; set; }
    public Guid StudentId { get; set; }
    public string StudentName { get; set; } = null!;
    public Guid? ClassroomId { get; set; }
    public string? ClassroomName { get; set; }
    public DateOnly Date { get; set; }
    /// <summary>"Present" | "Absent" | "Late"</summary>
    public string Status { get; set; } = null!;
    public DateTime CreatedAt { get; set; }
}
