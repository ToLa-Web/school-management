namespace SchoolService.Domain.Entities;

/// <summary>Score record for a student in a subject for a semester (named StudentGrade to avoid keyword conflict)</summary>
public class StudentGrade
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public Guid StudentId { get; private set; }
    public Guid SubjectId { get; private set; }
    public decimal Score { get; private set; }
    public string Semester { get; private set; } = null!;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;

    public Student Student { get; private set; } = null!;
    public Subject Subject { get; private set; } = null!;

    private StudentGrade() { } // EF

    public StudentGrade(Guid studentId, Guid subjectId, decimal score, string semester)
    {
        StudentId = studentId;
        SubjectId = subjectId;
        UpdateScore(score, semester);
    }

    public void UpdateScore(decimal score, string semester)
    {
        if (score < 0 || score > 100) throw new ArgumentOutOfRangeException(nameof(score), "Score must be 0–100.");
        Score = score;
        Semester = semester.Trim();
    }
}
