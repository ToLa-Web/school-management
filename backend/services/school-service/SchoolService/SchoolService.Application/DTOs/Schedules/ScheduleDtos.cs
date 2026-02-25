using System.ComponentModel.DataAnnotations;
using System.Text.Json.Serialization;

namespace SchoolService.Application.DTOs.Schedules;

public class ScheduleCreateDto
{
    [Required]
    public Guid ClassroomId { get; set; }

    [Required]
    public Guid SubjectId { get; set; }

    public Guid? TeacherId { get; set; }

    [Required]
    [StringLength(20)]
    public string Day { get; set; } = null!;

    [Required]
    [StringLength(30)]
    public string Time { get; set; } = null!;
}

public class ScheduleUpdateDto
{
    public Guid? TeacherId { get; set; }

    [Required]
    [StringLength(20)]
    public string Day { get; set; } = null!;

    [Required]
    [StringLength(30)]
    public string Time { get; set; } = null!;
}

public class ScheduleResponseDto
{
    public Guid Id { get; set; }
    public Guid ClassroomId { get; set; }
    public string ClassroomName { get; set; } = null!;
    public Guid SubjectId { get; set; }
    public string SubjectName { get; set; } = null!;
    public Guid? TeacherId { get; set; }
    public string? TeacherName { get; set; }
    public string Day { get; set; } = null!;
    public string Time { get; set; } = null!;
}
