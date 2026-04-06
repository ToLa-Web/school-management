using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Announcements;

public class AnnouncementCreateDto
{
    [Required]
    [StringLength(200)]
    public string Title { get; set; } = null!;

    [Required]
    public string Body { get; set; } = null!;

    /// <summary>Null = school-wide announcement.</summary>
    public Guid? ClassroomId { get; set; }

    [Required]
    public Guid AuthorTeacherId { get; set; }

    /// <summary>If true, sets PublishedAt to now upon creation.</summary>
    public bool PublishImmediately { get; set; } = false;
}

public class AnnouncementUpdateDto
{
    [Required]
    [StringLength(200)]
    public string Title { get; set; } = null!;

    [Required]
    public string Body { get; set; } = null!;
}

public class AnnouncementResponseDto
{
    public Guid Id { get; set; }
    public string Title { get; set; } = null!;
    public string Body { get; set; } = null!;
    public Guid? ClassroomId { get; set; }
    public string? ClassroomName { get; set; }
    public Guid AuthorTeacherId { get; set; }
    public string AuthorTeacherName { get; set; } = null!;
    public DateTime? PublishedAt { get; set; }
    public bool IsPublished { get; set; }
    public DateTime CreatedAt { get; set; }
}
