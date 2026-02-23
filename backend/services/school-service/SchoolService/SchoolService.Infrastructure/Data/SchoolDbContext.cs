using Microsoft.EntityFrameworkCore;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data;

public class SchoolDbContext : DbContext
{
    public SchoolDbContext(DbContextOptions<SchoolDbContext> options) : base(options)
    {
    }

    public DbSet<Student> Students => Set<Student>();
    public DbSet<Teacher> Teachers => Set<Teacher>();
    public DbSet<Classroom> Classrooms => Set<Classroom>();
    public DbSet<StudentClassroom> StudentClassrooms => Set<StudentClassroom>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // ── Student ──
        var student = modelBuilder.Entity<Student>();
        student.HasKey(s => s.Id);
        student.Property(s => s.FirstName).IsRequired().HasMaxLength(100);
        student.Property(s => s.LastName).IsRequired().HasMaxLength(100);
        student.Property(s => s.Gender).HasMaxLength(20);
        student.Property(s => s.Phone).HasMaxLength(30);
        student.Property(s => s.Address).HasMaxLength(250);

        // ── Teacher ──
        var teacher = modelBuilder.Entity<Teacher>();
        teacher.HasKey(t => t.Id);
        teacher.Property(t => t.FirstName).IsRequired().HasMaxLength(100);
        teacher.Property(t => t.LastName).IsRequired().HasMaxLength(100);
        teacher.Property(t => t.Gender).HasMaxLength(20);
        teacher.Property(t => t.Phone).HasMaxLength(30);
        teacher.Property(t => t.Email).HasMaxLength(200);
        teacher.Property(t => t.Specialization).HasMaxLength(150);

        // ── Classroom ──
        var classroom = modelBuilder.Entity<Classroom>();
        classroom.HasKey(c => c.Id);
        classroom.Property(c => c.Name).IsRequired().HasMaxLength(100);
        classroom.Property(c => c.Grade).HasMaxLength(20);
        classroom.Property(c => c.AcademicYear).HasMaxLength(20);

        classroom.HasOne(c => c.Teacher)
            .WithMany(t => t.Classrooms)
            .HasForeignKey(c => c.TeacherId)
            .OnDelete(DeleteBehavior.SetNull);

        // ── StudentClassroom (many-to-many join) ──
        var sc = modelBuilder.Entity<StudentClassroom>();
        sc.HasKey(x => new { x.StudentId, x.ClassroomId });

        sc.HasOne(x => x.Student)
            .WithMany(s => s.StudentClassrooms)
            .HasForeignKey(x => x.StudentId)
            .OnDelete(DeleteBehavior.Cascade);

        sc.HasOne(x => x.Classroom)
            .WithMany(c => c.StudentClassrooms)
            .HasForeignKey(x => x.ClassroomId)
            .OnDelete(DeleteBehavior.Cascade);
    }
}
