using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class TeacherConfiguration : IEntityTypeConfiguration<Teacher>
{
    public void Configure(EntityTypeBuilder<Teacher> builder)
    {
        builder.HasKey(t => t.Id);

        builder.Property(t => t.FirstName)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(t => t.LastName)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(t => t.Gender)
            .HasMaxLength(20);

        builder.Property(t => t.Phone)
            .HasMaxLength(30);

        builder.Property(t => t.Email)
            .HasMaxLength(200);

        builder.Property(t => t.Specialization)
            .HasMaxLength(150);

        builder.Property(t => t.DeletedAt)
            .IsRequired(false);

        builder.Property(t => t.AuthUserId)
            .IsRequired(false);

        // Unique index for AuthUserId, allowing nulls
        builder.HasIndex(t => t.AuthUserId)
            .IsUnique()
            .HasFilter("\"AuthUserId\" IS NOT NULL");
    }
}
