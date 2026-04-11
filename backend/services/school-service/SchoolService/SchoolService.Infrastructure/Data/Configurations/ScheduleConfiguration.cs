using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class ScheduleConfiguration : IEntityTypeConfiguration<Schedule>
{
    public void Configure(EntityTypeBuilder<Schedule> builder)
    {
        builder.HasKey(s => s.Id);

        builder.Property(s => s.DayOfWeek)
            .HasConversion<int>();

        builder.Property(s => s.Type)
            .HasConversion<int>();

        builder.Property(s => s.DeletedAt)
            .IsRequired(false);

        // One-to-many with Classroom
        builder.HasOne(s => s.Classroom)
            .WithMany()
            .HasForeignKey(s => s.ClassroomId)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-many with Subject
        builder.HasOne(s => s.Subject)
            .WithMany(sub => sub.Schedules)
            .HasForeignKey(s => s.SubjectId)
            .OnDelete(DeleteBehavior.Restrict);

        // One-to-many with Teacher (optional)
        builder.HasOne(s => s.Teacher)
            .WithMany(t => t.Schedules)
            .HasForeignKey(s => s.TeacherId)
            .OnDelete(DeleteBehavior.SetNull);
    }
}
