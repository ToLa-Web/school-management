using SchoolService.Domain.Entities;

namespace SchoolService.Application.Interfaces;

public interface IDepartmentRepository
{
    Task<List<Department>> GetAllAsync();
    Task<Department?> GetByIdAsync(Guid id);
    Task<Department?> GetByIdWithRelationsAsync(Guid id);
    Task AddAsync(Department department);
    Task UpdateAsync(Department department);
    Task<TeacherDepartment?> GetTeacherDepartmentAsync(Guid teacherId, Guid departmentId);
    Task AddTeacherDepartmentAsync(TeacherDepartment td);
    Task RemoveTeacherDepartmentAsync(TeacherDepartment td);
}
