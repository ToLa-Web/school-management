using Microsoft.EntityFrameworkCore;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;
using SchoolService.Infrastructure.Data;

namespace SchoolService.Infrastructure.Repositories;

public class SubjectRepository : ISubjectRepository
{
    private readonly SchoolDbContext _context;

    public SubjectRepository(SchoolDbContext context) => _context = context;

    public async Task<List<Subject>> GetAllAsync()
        => await _context.Subjects
            .AsNoTracking()
            .Include(s => s.Department)
            .Include(s => s.TeacherSubjects).ThenInclude(ts => ts.Teacher)
            .OrderBy(s => s.SubjectName)
            .ToListAsync();

    public async Task<Subject?> GetByIdAsync(Guid id)
        => await _context.Subjects
            .Include(s => s.Department)
            .FirstOrDefaultAsync(s => s.Id == id);

    public async Task<Subject?> GetByIdWithTeachersAsync(Guid id)
        => await _context.Subjects
            .Include(s => s.Department)
            .Include(s => s.TeacherSubjects).ThenInclude(ts => ts.Teacher)
            .FirstOrDefaultAsync(s => s.Id == id);

    public async Task AddAsync(Subject subject)
    {
        await _context.Subjects.AddAsync(subject);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(Subject subject)
    {
        _context.Subjects.Update(subject);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(Subject subject)
    {
        _context.Subjects.Remove(subject);
        await _context.SaveChangesAsync();
    }

    public async Task<TeacherSubject?> GetTeacherSubjectAsync(Guid subjectId, Guid teacherId)
        => await _context.TeacherSubjects
            .FirstOrDefaultAsync(ts => ts.SubjectId == subjectId && ts.TeacherId == teacherId);

    public async Task AddTeacherSubjectAsync(TeacherSubject ts)
    {
        await _context.TeacherSubjects.AddAsync(ts);
        await _context.SaveChangesAsync();
    }

    public async Task RemoveTeacherSubjectAsync(TeacherSubject ts)
    {
        _context.TeacherSubjects.Remove(ts);
        await _context.SaveChangesAsync();
    }
}
