using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class TeacherSubjectConfiguration : IEntityTypeConfiguration<TeacherSubject>
{
    public void Configure(EntityTypeBuilder<TeacherSubject> builder)
    {
        // Composite primary key
        builder.HasKey(x => new { x.TeacherId, x.SubjectId });

        // One-to-many with Teacher
        builder.HasOne(x => x.Teacher)
            .WithMany(t => t.TeacherSubjects)
            .HasForeignKey(x => x.TeacherId)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-many with Subject
        builder.HasOne(x => x.Subject)
            .WithMany(s => s.TeacherSubjects)
            .HasForeignKey(x => x.SubjectId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
