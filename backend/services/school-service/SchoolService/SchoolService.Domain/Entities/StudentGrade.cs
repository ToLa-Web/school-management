namespace SchoolService.Domain.Entities;

public enum GradingMethod
{
    /// <summary>Score is computed by averaging/weighting SUBMISSION.Grade values.</summary>
    Aggregated = 1,
    /// <summary>Score entered directly by teacher, independent of submissions.</summary>
    Manual = 2
}

/// <summary>Final subject score for a student within a specific classroom section.</summary>
public class StudentGrade
{
    public Guid Id { get; private set; } = Guid.NewGuid();
    public Guid StudentId { get; private set; }
    public Guid SubjectId { get; private set; }
    /// <summary>Scopes the grade to a specific section, not just subject + semester.</summary>
    public Guid? ClassroomId { get; private set; }
    public decimal Score { get; private set; }
    public string Semester { get; private set; } = null!;
    public GradingMethod GradingMethod { get; private set; } = GradingMethod.Manual;
    public DateTime CreatedAt { get; private set; } = DateTime.UtcNow;

    public Student Student { get; private set; } = null!;
    public Subject Subject { get; private set; } = null!;
    public Classroom? Classroom { get; private set; }

    private StudentGrade() { } // EF

    public StudentGrade(Guid studentId, Guid subjectId, decimal score, string semester,
        Guid? classroomId = null, GradingMethod gradingMethod = GradingMethod.Manual)
    {
        StudentId     = studentId;
        SubjectId     = subjectId;
        ClassroomId   = classroomId;
        GradingMethod = gradingMethod;
        UpdateScore(score, semester);
    }

    public void UpdateScore(decimal score, string semester,
        GradingMethod? gradingMethod = null)
    {
        if (score < 0 || score > 100) throw new ArgumentOutOfRangeException(nameof(score), "Score must be 0–100.");
        Score    = score;
        Semester = semester.Trim();
        if (gradingMethod.HasValue) GradingMethod = gradingMethod.Value;
    }
}
