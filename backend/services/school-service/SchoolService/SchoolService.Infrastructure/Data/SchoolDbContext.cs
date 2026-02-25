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
    public DbSet<Subject> Subjects => Set<Subject>();
    public DbSet<TeacherSubject> TeacherSubjects => Set<TeacherSubject>();
    public DbSet<Enrollment> Enrollments => Set<Enrollment>();
    public DbSet<StudentGrade> StudentGrades => Set<StudentGrade>();
    public DbSet<Attendance> Attendances => Set<Attendance>();
    public DbSet<Schedule> Schedules => Set<Schedule>();

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

        // ── Subject ──
        var subject = modelBuilder.Entity<Subject>();
        subject.HasKey(s => s.Id);
        subject.Property(s => s.SubjectName).IsRequired().HasMaxLength(150);

        // ── TeacherSubject (many-to-many join) ──
        var ts = modelBuilder.Entity<TeacherSubject>();
        ts.HasKey(x => new { x.TeacherId, x.SubjectId });

        ts.HasOne(x => x.Teacher)
            .WithMany(t => t.TeacherSubjects)
            .HasForeignKey(x => x.TeacherId)
            .OnDelete(DeleteBehavior.Cascade);

        ts.HasOne(x => x.Subject)
            .WithMany(s => s.TeacherSubjects)
            .HasForeignKey(x => x.SubjectId)
            .OnDelete(DeleteBehavior.Cascade);

        // ── Enrollment (Student ↔ Subject) ──
        var enroll = modelBuilder.Entity<Enrollment>();
        enroll.HasKey(e => e.Id);
        enroll.HasIndex(e => new { e.StudentId, e.SubjectId }).IsUnique();

        enroll.HasOne(e => e.Student)
            .WithMany(s => s.Enrollments)
            .HasForeignKey(e => e.StudentId)
            .OnDelete(DeleteBehavior.Cascade);

        enroll.HasOne(e => e.Subject)
            .WithMany(s => s.Enrollments)
            .HasForeignKey(e => e.SubjectId)
            .OnDelete(DeleteBehavior.Cascade);

        // ── StudentGrade ──
        var grade = modelBuilder.Entity<StudentGrade>();
        grade.HasKey(g => g.Id);
        grade.Property(g => g.Score).HasPrecision(5, 2);
        grade.Property(g => g.Semester).IsRequired().HasMaxLength(20);

        grade.HasOne(g => g.Student)
            .WithMany(s => s.Grades)
            .HasForeignKey(g => g.StudentId)
            .OnDelete(DeleteBehavior.Cascade);

        grade.HasOne(g => g.Subject)
            .WithMany(s => s.Grades)
            .HasForeignKey(g => g.SubjectId)
            .OnDelete(DeleteBehavior.Restrict);

        // ── Attendance ──
        var att = modelBuilder.Entity<Attendance>();
        att.HasKey(a => a.Id);
        att.Property(a => a.Status).HasConversion<int>();

        att.HasOne(a => a.Student)
            .WithMany(s => s.Attendances)
            .HasForeignKey(a => a.StudentId)
            .OnDelete(DeleteBehavior.Cascade);

        att.HasOne(a => a.Classroom)
            .WithMany()
            .HasForeignKey(a => a.ClassroomId)
            .OnDelete(DeleteBehavior.SetNull);

        // ── Schedule ──
        var sched = modelBuilder.Entity<Schedule>();
        sched.HasKey(s => s.Id);
        sched.Property(s => s.Day).IsRequired().HasMaxLength(20);
        sched.Property(s => s.Time).IsRequired().HasMaxLength(30);

        sched.HasOne(s => s.Classroom)
            .WithMany()
            .HasForeignKey(s => s.ClassroomId)
            .OnDelete(DeleteBehavior.Cascade);

        sched.HasOne(s => s.Subject)
            .WithMany(sub => sub.Schedules)
            .HasForeignKey(s => s.SubjectId)
            .OnDelete(DeleteBehavior.Restrict);

        sched.HasOne(s => s.Teacher)
            .WithMany(t => t.Schedules)
            .HasForeignKey(s => s.TeacherId)
            .OnDelete(DeleteBehavior.SetNull);
    }
}
