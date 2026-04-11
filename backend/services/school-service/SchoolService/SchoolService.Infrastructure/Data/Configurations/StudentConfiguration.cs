using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class StudentConfiguration : IEntityTypeConfiguration<Student>
{
    public void Configure(EntityTypeBuilder<Student> builder)
    {
        builder.HasKey(s => s.Id);

        builder.Property(s => s.FirstName)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(s => s.LastName)
            .IsRequired()
            .HasMaxLength(100);

        builder.Property(s => s.Gender)
            .HasMaxLength(20);

        builder.Property(s => s.Phone)
            .HasMaxLength(30);

        builder.Property(s => s.Address)
            .HasMaxLength(250);

        builder.Property(s => s.DeletedAt)
            .IsRequired(false);

        builder.Property(s => s.AuthUserId)
            .IsRequired(false);

        // Unique index for AuthUserId, allowing nulls
        builder.HasIndex(s => s.AuthUserId)
            .IsUnique()
            .HasFilter("\"AuthUserId\" IS NOT NULL");
    }
}
