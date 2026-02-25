using Microsoft.EntityFrameworkCore;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;
using SchoolService.Infrastructure.Data;

namespace SchoolService.Infrastructure.Repositories;

public class AttendanceRepository : IAttendanceRepository
{
    private readonly SchoolDbContext _context;

    public AttendanceRepository(SchoolDbContext context) => _context = context;

    public async Task<List<Attendance>> GetByClassroomAndDateAsync(Guid classroomId, DateOnly date)
        => await _context.Attendances
            .AsNoTracking()
            .Include(a => a.Student)
            .Include(a => a.Classroom)
            .Where(a => a.ClassroomId == classroomId && a.Date == date)
            .ToListAsync();

    public async Task<List<Attendance>> GetByStudentAsync(Guid studentId)
        => await _context.Attendances
            .AsNoTracking()
            .Include(a => a.Classroom)
            .Where(a => a.StudentId == studentId)
            .OrderByDescending(a => a.Date)
            .ToListAsync();

    public async Task<Attendance?> GetByStudentClassroomDateAsync(Guid studentId, Guid classroomId, DateOnly date)
        => await _context.Attendances
            .FirstOrDefaultAsync(a =>
                a.StudentId == studentId &&
                a.ClassroomId == classroomId &&
                a.Date == date);

    public async Task AddAsync(Attendance attendance)
    {
        await _context.Attendances.AddAsync(attendance);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(Attendance attendance)
    {
        _context.Attendances.Update(attendance);
        await _context.SaveChangesAsync();
    }

    public async Task AddRangeAsync(IEnumerable<Attendance> attendances)
    {
        await _context.Attendances.AddRangeAsync(attendances);
        await _context.SaveChangesAsync();
    }
}
