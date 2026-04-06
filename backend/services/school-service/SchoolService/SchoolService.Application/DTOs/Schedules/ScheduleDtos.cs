using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Schedules;

public class ScheduleCreateDto
{
    [Required]
    public Guid ClassroomId { get; set; }

    [Required]
    public Guid SubjectId { get; set; }

    public Guid? TeacherId { get; set; }

    /// <summary>1=Monday … 7=Sunday</summary>
    [Required]
    [Range(1, 7)]
    public int DayOfWeek { get; set; }

    /// <summary>Format: HH:mm (e.g. "08:00")</summary>
    [Required]
    public TimeOnly StartTime { get; set; }

    /// <summary>Format: HH:mm (e.g. "09:30")</summary>
    [Required]
    public TimeOnly EndTime { get; set; }

    /// <summary>1=Regular, 2=MakeUp, 3=Consultation</summary>
    public int Type { get; set; } = 1;
}

public class ScheduleUpdateDto
{
    public Guid? TeacherId { get; set; }

    [Required]
    [Range(1, 7)]
    public int DayOfWeek { get; set; }

    [Required]
    public TimeOnly StartTime { get; set; }

    [Required]
    public TimeOnly EndTime { get; set; }

    public int Type { get; set; } = 1;
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
    public int DayOfWeek { get; set; }
    public string DayOfWeekName { get; set; } = null!;
    public TimeOnly StartTime { get; set; }
    public TimeOnly EndTime { get; set; }
    public int Type { get; set; }
    public string TypeName { get; set; } = null!;
}
