using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class StudentClassroomConfiguration : IEntityTypeConfiguration<StudentClassroom>
{
    public void Configure(EntityTypeBuilder<StudentClassroom> builder)
    {
        // Composite primary key
        builder.HasKey(x => new { x.StudentId, x.ClassroomId });

        builder.Property(x => x.Status)
            .HasConversion<int>();

        builder.Property(x => x.UnenrolledAt)
            .IsRequired(false);

        // One-to-many with Student
        builder.HasOne(x => x.Student)
            .WithMany(s => s.StudentClassrooms)
            .HasForeignKey(x => x.StudentId)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-many with Classroom
        builder.HasOne(x => x.Classroom)
            .WithMany(c => c.StudentClassrooms)
            .HasForeignKey(x => x.ClassroomId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
