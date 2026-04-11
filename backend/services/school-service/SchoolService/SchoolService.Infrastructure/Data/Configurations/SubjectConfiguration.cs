using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class SubjectConfiguration : IEntityTypeConfiguration<Subject>
{
    public void Configure(EntityTypeBuilder<Subject> builder)
    {
        builder.HasKey(s => s.Id);

        builder.Property(s => s.SubjectName)
            .IsRequired()
            .HasMaxLength(150);

        builder.Property(s => s.DepartmentId)
            .IsRequired();

        builder.Property(s => s.DeletedAt)
            .IsRequired(false);

        // One-to-many with Department
        builder.HasOne(s => s.Department)
            .WithMany(d => d.Subjects)
            .HasForeignKey(s => s.DepartmentId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
