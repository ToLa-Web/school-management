using Microsoft.EntityFrameworkCore;
using SchoolService.Domain.Entities;
using SchoolService.Infrastructure.Data;

namespace SchoolService.Infrastructure.Seed;

public class DataSeeder
{
    private readonly SchoolDbContext _context;

    public DataSeeder(SchoolDbContext context)
    {
        _context = context;
    }

    public async Task SeedDataAsync()
    {
        await SeedTeachersAsync();
        await SeedStudentsAsync();
        await SeedClassroomsAsync();
    }

    private async Task SeedTeachersAsync()
    {
        if (await _context.Teachers.AnyAsync()) return;

        var t1 = new Teacher("Sophea", "Mao");
        t1.UpdateBasicInfo("Sophea", "Mao", "Female", null, "012-345-678", "sophea@school.com", "Mathematics");

        var t2 = new Teacher("Dara", "Heng");
        t2.UpdateBasicInfo("Dara", "Heng", "Male", null, "012-987-654", "dara@school.com", "Science");

        await _context.Teachers.AddRangeAsync(t1, t2);
        await _context.SaveChangesAsync();
    }

    private async Task SeedStudentsAsync()
    {
        if (await _context.Students.AnyAsync()) return;

        var students = new List<Student>
        {
            new("Alice", "Johnson"),
            new("Bob", "Smith"),
            new("Chenda", "Tola"),
        };

        await _context.Students.AddRangeAsync(students);
        await _context.SaveChangesAsync();
    }

    private async Task SeedClassroomsAsync()
    {
        if (await _context.Classrooms.AnyAsync()) return;

        var teacher = await _context.Teachers.FirstOrDefaultAsync();
        var students = await _context.Students.ToListAsync();

        var classroom = new Classroom("Class 10-A");
        classroom.UpdateInfo("Class 10-A", "10", "2025-2026");
        if (teacher != null)
            classroom.AssignTeacher(teacher.Id);

        await _context.Classrooms.AddAsync(classroom);
        await _context.SaveChangesAsync();

        // Enroll all seed students
        foreach (var student in students)
        {
            var enrollment = new StudentClassroom(student.Id, classroom.Id);
            await _context.StudentClassrooms.AddAsync(enrollment);
        }
        await _context.SaveChangesAsync();
    }
}
