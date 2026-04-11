using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class AnnouncementConfiguration : IEntityTypeConfiguration<Announcement>
{
    public void Configure(EntityTypeBuilder<Announcement> builder)
    {
        builder.HasKey(a => a.Id);

        builder.Property(a => a.Title)
            .IsRequired()
            .HasMaxLength(200);

        builder.Property(a => a.Body)
            .IsRequired();

        builder.Property(a => a.PublishedAt)
            .IsRequired(false);

        // One-to-many with Classroom (optional)
        builder.HasOne(a => a.Classroom)
            .WithMany()
            .HasForeignKey(a => a.ClassroomId)
            .IsRequired(false)
            .OnDelete(DeleteBehavior.SetNull);

        // One-to-many with Teacher (author)
        builder.HasOne(a => a.AuthorTeacher)
            .WithMany()
            .HasForeignKey(a => a.AuthorTeacherId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
