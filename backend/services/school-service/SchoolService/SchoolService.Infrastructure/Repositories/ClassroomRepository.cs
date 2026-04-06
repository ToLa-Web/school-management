using Microsoft.EntityFrameworkCore;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;
using SchoolService.Infrastructure.Data;

namespace SchoolService.Infrastructure.Repositories;

public class ClassroomRepository : IClassroomRepository
{
    private readonly SchoolDbContext _context;

    public ClassroomRepository(SchoolDbContext context)
    {
        _context = context;
    }

    public async Task<List<Classroom>> GetAllAsync()
        => await _context.Classrooms
            .AsNoTracking()
            .Include(c => c.Teacher)
            .Include(c => c.Room)
            .Include(c => c.StudentClassrooms)
            .ToListAsync();

    public async Task<(List<Classroom> Items, int TotalCount)> GetPagedAsync(int page, int pageSize)
    {
        var query = _context.Classrooms
            .AsNoTracking()
            .Include(c => c.Teacher)
            .Include(c => c.Room)
            .Include(c => c.StudentClassrooms)
            .OrderBy(c => c.Name);
        var total = await query.CountAsync();
        var items = await query.Skip((page - 1) * pageSize).Take(pageSize).ToListAsync();
        return (items, total);
    }

    public async Task<Classroom?> GetByIdAsync(Guid id)
        => await _context.Classrooms.FindAsync(id);

    public async Task<Classroom?> GetByIdWithDetailsAsync(Guid id)
        => await _context.Classrooms
            .Include(c => c.Teacher)
            .Include(c => c.Room)
            .Include(c => c.StudentClassrooms)
                .ThenInclude(sc => sc.Student)
            .FirstOrDefaultAsync(c => c.Id == id);

    public async Task AddAsync(Classroom classroom)
    {
        await _context.Classrooms.AddAsync(classroom);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(Classroom classroom)
    {
        _context.Classrooms.Update(classroom);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(Classroom classroom)
    {
        _context.Classrooms.Remove(classroom);
        await _context.SaveChangesAsync();
    }

    public async Task<StudentClassroom?> GetEnrollmentAsync(Guid classroomId, Guid studentId)
        => await _context.StudentClassrooms
            .FirstOrDefaultAsync(sc => sc.ClassroomId == classroomId && sc.StudentId == studentId);

    public async Task AddEnrollmentAsync(StudentClassroom enrollment)
    {
        await _context.StudentClassrooms.AddAsync(enrollment);
        await _context.SaveChangesAsync();
    }

    public async Task RemoveEnrollmentAsync(StudentClassroom enrollment)
    {
        _context.StudentClassrooms.Remove(enrollment);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateEnrollmentAsync(StudentClassroom enrollment)
    {
        _context.StudentClassrooms.Update(enrollment);
        await _context.SaveChangesAsync();
    }
}
