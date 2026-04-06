namespace SchoolService.Domain.Entities;

public class Announcement
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public string Title { get; private set; } = null!;
    public string Body { get; private set; } = null!;
    /// <summary>Null means the announcement is school-wide (not scoped to a classroom).</summary>
    public Guid? ClassroomId { get; private set; }
    public Guid AuthorTeacherId { get; private set; }
    public DateTime? PublishedAt { get; private set; }
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;

    public Classroom? Classroom { get; private set; }
    public Teacher AuthorTeacher { get; private set; } = null!;

    private Announcement() { } // EF

    public Announcement(string title, string body, Guid authorTeacherId, Guid? classroomId = null)
    {
        AuthorTeacherId = authorTeacherId;
        ClassroomId     = classroomId;
        UpdateContent(title, body);
    }

    public void UpdateContent(string title, string body)
    {
        Title = title.Trim();
        Body  = body.Trim();
    }

    public void Publish()   => PublishedAt = DateTime.UtcNow;
    public void Unpublish() => PublishedAt = null;

    public bool IsPublished => PublishedAt.HasValue && PublishedAt <= DateTime.UtcNow;
}
