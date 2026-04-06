namespace SchoolService.Domain.Entities;

public class Submission
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public Guid MaterialId { get; private set; } // Points to a Material of type Assignment
    public Guid StudentId { get; private set; }
    public string? SubmissionUrl { get; private set; }
    public DateTime SubmittedAt { get; private set; } = DateTime.UtcNow;
    public decimal? Grade { get; private set; }
    public string? Feedback { get; private set; }

    public Material Material { get; private set; } = null!;
    public Student Student { get; private set; } = null!;

    private Submission() { } // EF

    public Submission(Guid materialId, Guid studentId, string? submissionUrl = null)
    {
        MaterialId = materialId;
        StudentId = studentId;
        SubmissionUrl = submissionUrl;
    }

    public void UpdateGrade(decimal? grade, string? feedback)
    {
        Grade = grade;
        Feedback = string.IsNullOrWhiteSpace(feedback) ? null : feedback.Trim();
    }
}
