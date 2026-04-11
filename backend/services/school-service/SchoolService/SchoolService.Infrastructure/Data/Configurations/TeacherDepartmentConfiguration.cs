using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class TeacherDepartmentConfiguration : IEntityTypeConfiguration<TeacherDepartment>
{
    public void Configure(EntityTypeBuilder<TeacherDepartment> builder)
    {
        // Composite primary key
        builder.HasKey(x => new { x.TeacherId, x.DepartmentId });

        // One-to-many with Teacher
        builder.HasOne(x => x.Teacher)
            .WithMany(t => t.TeacherDepartments)
            .HasForeignKey(x => x.TeacherId)
            .OnDelete(DeleteBehavior.Cascade);

        // One-to-many with Department
        builder.HasOne(x => x.Department)
            .WithMany(d => d.TeacherDepartments)
            .HasForeignKey(x => x.DepartmentId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
