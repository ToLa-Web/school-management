using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data.Configurations;

public class RoomConfiguration : IEntityTypeConfiguration<Room>
{
    public void Configure(EntityTypeBuilder<Room> builder)
    {
        builder.HasKey(r => r.Id);

        builder.Property(r => r.Name)
            .IsRequired()
            .HasMaxLength(150);

        builder.Property(r => r.Location)
            .HasMaxLength(500);

        builder.Property(r => r.Capacity)
            .HasDefaultValue(0);

        builder.Property(r => r.Type)
            .HasConversion<int>();

        builder.Property(r => r.DeletedAt)
            .IsRequired(false);
    }
}
