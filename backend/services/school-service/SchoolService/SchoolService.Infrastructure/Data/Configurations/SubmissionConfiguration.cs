using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class SubmissionConfiguration : IEntityTypeConfiguration<Submission>
{
    public void Configure(EntityTypeBuilder<Submission> builder)
    {
        builder.HasKey(s => s.Id);

        builder.Property(s => s.SubmissionUrl)
            .HasMaxLength(1000);

        builder.Property(s => s.Grade)
            .HasPrecision(5, 2);

        // One-to-many with Material
        builder.HasOne(s => s.Material)
            .WithMany(m => m.Submissions)
            .HasForeignKey(s => s.MaterialId)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-many with Student
        builder.HasOne(s => s.Student)
            .WithMany()
            .HasForeignKey(s => s.StudentId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
