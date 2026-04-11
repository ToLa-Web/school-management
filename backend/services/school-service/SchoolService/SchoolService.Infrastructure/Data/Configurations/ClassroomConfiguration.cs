using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class ClassroomConfiguration : IEntityTypeConfiguration<Classroom>
{
    public void Configure(EntityTypeBuilder<Classroom> builder)
    {
        builder.HasKey(c => c.Id);

        builder.Property(c => c.Name)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(c => c.Grade)
            .HasMaxLength(20);

        builder.Property(c => c.AcademicYear)
            .HasMaxLength(20);

        builder.Property(c => c.Semester)
            .HasMaxLength(20);

        builder.Property(c => c.DeletedAt)
            .IsRequired(false);

        // One-to-many with Teacher (optional)
        builder.HasOne(c => c.Teacher)
            .WithMany(t => t.Classrooms)
            .HasForeignKey(c => c.TeacherId)
            .OnDelete(DeleteBehavior.SetNull);

        // One-to-many with Room (optional)
        builder.HasOne(c => c.Room)
            .WithMany(r => r.Classrooms)
            .HasForeignKey(c => c.RoomId)
            .OnDelete(DeleteBehavior.SetNull);
    }
}
