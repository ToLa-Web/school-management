using Microsoft.EntityFrameworkCore;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;
using SchoolService.Infrastructure.Data;

namespace SchoolService.Infrastructure.Repositories;

public class TeacherRepository : ITeacherRepository
{
    private readonly SchoolDbContext _context;

    public TeacherRepository(SchoolDbContext context)
    {
        _context = context;
    }

    public async Task<List<Teacher>> GetAllAsync()
        => await _context.Teachers.AsNoTracking().ToListAsync();

    public async Task<Teacher?> GetByIdAsync(Guid id)
        => await _context.Teachers.FindAsync(id);

    public async Task AddAsync(Teacher teacher)
    {
        await _context.Teachers.AddAsync(teacher);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(Teacher teacher)
    {
        _context.Teachers.Update(teacher);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(Teacher teacher)
    {
        _context.Teachers.Remove(teacher);
        await _context.SaveChangesAsync();
    }
}
