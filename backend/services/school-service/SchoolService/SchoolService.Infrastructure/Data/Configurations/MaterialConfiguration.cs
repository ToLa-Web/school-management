using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class MaterialConfiguration : IEntityTypeConfiguration<Material>
{
    public void Configure(EntityTypeBuilder<Material> builder)
    {
        builder.HasKey(m => m.Id);

        builder.Property(m => m.Title)
            .IsRequired()
            .HasMaxLength(200);

        builder.Property(m => m.Url)
            .HasMaxLength(1000);

        builder.Property(m => m.Type)
            .HasConversion<int>();

        builder.Property(m => m.DeletedAt)
            .IsRequired(false);

        // One-to-many with Classroom
        builder.HasOne(m => m.Classroom)
            .WithMany()
            .HasForeignKey(m => m.ClassroomId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
