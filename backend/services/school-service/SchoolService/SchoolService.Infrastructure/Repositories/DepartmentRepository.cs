using Microsoft.EntityFrameworkCore;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;
using SchoolService.Infrastructure.Data;

namespace SchoolService.Infrastructure.Repositories;

public class DepartmentRepository : IDepartmentRepository
{
    private readonly SchoolDbContext _context;

    public DepartmentRepository(SchoolDbContext context) => _context = context;

    public async Task<List<Department>> GetAllAsync()
        => await _context.Departments
            .AsNoTracking()
            .Include(d => d.Subjects)
            .Include(d => d.TeacherDepartments).ThenInclude(td => td.Teacher)
            .OrderBy(d => d.Name)
            .ToListAsync();

    public async Task<Department?> GetByIdAsync(Guid id)
        => await _context.Departments.FindAsync(id);

    public async Task<Department?> GetByIdWithRelationsAsync(Guid id)
        => await _context.Departments
            .Include(d => d.Subjects)
            .Include(d => d.TeacherDepartments).ThenInclude(td => td.Teacher)
            .FirstOrDefaultAsync(d => d.Id == id);

    public async Task AddAsync(Department department)
    {
        await _context.Departments.AddAsync(department);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(Department department)
    {
        _context.Departments.Update(department);
        await _context.SaveChangesAsync();
    }

    public async Task<TeacherDepartment?> GetTeacherDepartmentAsync(Guid teacherId, Guid departmentId)
        => await _context.TeacherDepartments
            .FirstOrDefaultAsync(td => td.TeacherId == teacherId && td.DepartmentId == departmentId);

    public async Task AddTeacherDepartmentAsync(TeacherDepartment td)
    {
        await _context.TeacherDepartments.AddAsync(td);
        await _context.SaveChangesAsync();
    }

    public async Task RemoveTeacherDepartmentAsync(TeacherDepartment td)
    {
        _context.TeacherDepartments.Remove(td);
        await _context.SaveChangesAsync();
    }
}
