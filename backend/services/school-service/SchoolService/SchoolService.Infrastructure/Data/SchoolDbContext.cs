using Microsoft.EntityFrameworkCore;
using SchoolService.Domain.Entities;

namespace SchoolService.Infrastructure.Data;

public class SchoolDbContext : DbContext
{
    public SchoolDbContext(DbContextOptions<SchoolDbContext> options) : base(options) { }

    public DbSet<Student>           Students           => Set<Student>();
    public DbSet<Teacher>           Teachers           => Set<Teacher>();
    public DbSet<Classroom>         Classrooms         => Set<Classroom>();
    public DbSet<StudentClassroom>  StudentClassrooms  => Set<StudentClassroom>();
    public DbSet<Subject>           Subjects           => Set<Subject>();
    public DbSet<TeacherSubject>    TeacherSubjects    => Set<TeacherSubject>();
    public DbSet<StudentGrade>      StudentGrades      => Set<StudentGrade>();
    public DbSet<Attendance>        Attendances        => Set<Attendance>();
    public DbSet<Schedule>          Schedules          => Set<Schedule>();
    public DbSet<Room>              Rooms              => Set<Room>();
    public DbSet<Material>          Materials          => Set<Material>();
    public DbSet<Submission>        Submissions        => Set<Submission>();
    public DbSet<Announcement>      Announcements      => Set<Announcement>();

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        base.OnModelCreating(modelBuilder);

        // ── Student ──────────────────────────────────────────────────────────
        var student = modelBuilder.Entity<Student>();
        student.HasKey(s => s.Id);
        student.Property(s => s.FirstName).IsRequired().HasMaxLength(100);
        student.Property(s => s.LastName).IsRequired().HasMaxLength(100);
        student.Property(s => s.Gender).HasMaxLength(20);
        student.Property(s => s.Phone).HasMaxLength(30);
        student.Property(s => s.Address).HasMaxLength(250);
        student.Property(s => s.DeletedAt).IsRequired(false);
        student.Property(s => s.AuthUserId).IsRequired(false);
        student.HasIndex(s => s.AuthUserId).IsUnique().HasFilter("\"AuthUserId\" IS NOT NULL");

        // ── Teacher ──────────────────────────────────────────────────────────
        var teacher = modelBuilder.Entity<Teacher>();
        teacher.HasKey(t => t.Id);
        teacher.Property(t => t.FirstName).IsRequired().HasMaxLength(100);
        teacher.Property(t => t.LastName).IsRequired().HasMaxLength(100);
        teacher.Property(t => t.Gender).HasMaxLength(20);
        teacher.Property(t => t.Phone).HasMaxLength(30);
        teacher.Property(t => t.Email).HasMaxLength(200);
        teacher.Property(t => t.Specialization).HasMaxLength(150);
        teacher.Property(t => t.Department).HasMaxLength(150);
        teacher.Property(t => t.DeletedAt).IsRequired(false);
        teacher.Property(t => t.AuthUserId).IsRequired(false);
        teacher.HasIndex(t => t.AuthUserId).IsUnique().HasFilter("\"AuthUserId\" IS NOT NULL");

        // ── Room ─────────────────────────────────────────────────────────────
        var room = modelBuilder.Entity<Room>();
        room.HasKey(r => r.Id);
        room.Property(r => r.Name).IsRequired().HasMaxLength(150);
        room.Property(r => r.Location).HasMaxLength(500);
        room.Property(r => r.Capacity).HasDefaultValue(0);
        room.Property(r => r.Type).HasConversion<int>();
        room.Property(r => r.DeletedAt).IsRequired(false);

        // ── Classroom ─────────────────────────────────────────────────────────
        var classroom = modelBuilder.Entity<Classroom>();
        classroom.HasKey(c => c.Id);
        classroom.Property(c => c.Name).IsRequired().HasMaxLength(100);
        classroom.Property(c => c.Grade).HasMaxLength(20);
        classroom.Property(c => c.AcademicYear).HasMaxLength(20);
        classroom.Property(c => c.Semester).HasMaxLength(20);
        classroom.Property(c => c.DeletedAt).IsRequired(false);

        classroom.HasOne(c => c.Teacher)
            .WithMany(t => t.Classrooms)
            .HasForeignKey(c => c.TeacherId)
            .OnDelete(DeleteBehavior.SetNull);

        classroom.HasOne(c => c.Room)
            .WithMany(r => r.Classrooms)
            .HasForeignKey(c => c.RoomId)
            .OnDelete(DeleteBehavior.SetNull);

        // ── StudentClassroom (many-to-many join) ─────────────────────────────
        var sc = modelBuilder.Entity<StudentClassroom>();
        sc.HasKey(x => new { x.StudentId, x.ClassroomId });
        sc.Property(x => x.Status).HasConversion<int>();
        sc.Property(x => x.UnenrolledAt).IsRequired(false);

        sc.HasOne(x => x.Student)
            .WithMany(s => s.StudentClassrooms)
            .HasForeignKey(x => x.StudentId)
            .OnDelete(DeleteBehavior.Cascade);

        sc.HasOne(x => x.Classroom)
            .WithMany(c => c.StudentClassrooms)
            .HasForeignKey(x => x.ClassroomId)
            .OnDelete(DeleteBehavior.Cascade);

        // ── Subject ───────────────────────────────────────────────────────────
        var subject = modelBuilder.Entity<Subject>();
        subject.HasKey(s => s.Id);
        subject.Property(s => s.SubjectName).IsRequired().HasMaxLength(150);
        subject.Property(s => s.DeletedAt).IsRequired(false);

        // ── TeacherSubject (many-to-many join) ───────────────────────────────
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

        // ── StudentGrade ──────────────────────────────────────────────────────
        var grade = modelBuilder.Entity<StudentGrade>();
        grade.HasKey(g => g.Id);
        grade.Property(g => g.Score).HasPrecision(5, 2);
        grade.Property(g => g.Semester).IsRequired().HasMaxLength(20);
        grade.Property(g => g.GradingMethod).HasConversion<int>();

        grade.HasOne(g => g.Student)
            .WithMany(s => s.Grades)
            .HasForeignKey(g => g.StudentId)
            .OnDelete(DeleteBehavior.Cascade);

        grade.HasOne(g => g.Subject)
            .WithMany(s => s.Grades)
            .HasForeignKey(g => g.SubjectId)
            .OnDelete(DeleteBehavior.Restrict);

        grade.HasOne(g => g.Classroom)
            .WithMany()
            .HasForeignKey(g => g.ClassroomId)
            .IsRequired(false)
            .OnDelete(DeleteBehavior.SetNull);

        // ── Schedule ──────────────────────────────────────────────────────────
        var sched = modelBuilder.Entity<Schedule>();
        sched.HasKey(s => s.Id);
        sched.Property(s => s.DayOfWeek).HasConversion<int>();
        sched.Property(s => s.Type).HasConversion<int>();
        sched.Property(s => s.DeletedAt).IsRequired(false);

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

        // ── Attendance ────────────────────────────────────────────────────────
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

        att.HasOne(a => a.Schedule)
            .WithMany()
            .HasForeignKey(a => a.ScheduleId)
            .IsRequired(false)
            .OnDelete(DeleteBehavior.SetNull);

        // ── Material ──────────────────────────────────────────────────────────
        var mat = modelBuilder.Entity<Material>();
        mat.HasKey(m => m.Id);
        mat.Property(m => m.Title).IsRequired().HasMaxLength(200);
        mat.Property(m => m.Url).HasMaxLength(1000);
        mat.Property(m => m.Type).HasConversion<int>();
        mat.Property(m => m.DeletedAt).IsRequired(false);

        mat.HasOne(m => m.Classroom)
            .WithMany()
            .HasForeignKey(m => m.ClassroomId)
            .OnDelete(DeleteBehavior.Cascade);

        // ── Submission ────────────────────────────────────────────────────────
        var sub = modelBuilder.Entity<Submission>();
        sub.HasKey(s => s.Id);
        sub.Property(s => s.SubmissionUrl).HasMaxLength(1000);
        sub.Property(s => s.Grade).HasPrecision(5, 2);

        sub.HasOne(s => s.Material)
            .WithMany(m => m.Submissions)
            .HasForeignKey(s => s.MaterialId)
            .OnDelete(DeleteBehavior.Cascade);

        sub.HasOne(s => s.Student)
            .WithMany()
            .HasForeignKey(s => s.StudentId)
            .OnDelete(DeleteBehavior.Cascade);

        // ── Announcement ──────────────────────────────────────────────────────
        var ann = modelBuilder.Entity<Announcement>();
        ann.HasKey(a => a.Id);
        ann.Property(a => a.Title).IsRequired().HasMaxLength(200);
        ann.Property(a => a.Body).IsRequired();
        ann.Property(a => a.PublishedAt).IsRequired(false);

        ann.HasOne(a => a.Classroom)
            .WithMany()
            .HasForeignKey(a => a.ClassroomId)
            .IsRequired(false)
            .OnDelete(DeleteBehavior.SetNull);

        ann.HasOne(a => a.AuthorTeacher)
            .WithMany()
            .HasForeignKey(a => a.AuthorTeacherId)
            .OnDelete(DeleteBehavior.Restrict);
    }
}
