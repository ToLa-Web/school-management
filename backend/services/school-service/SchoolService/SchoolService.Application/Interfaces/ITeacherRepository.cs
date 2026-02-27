using SchoolService.Domain.Entities;

namespace SchoolService.Application.Interfaces;

public interface ITeacherRepository
{
    Task<List<Teacher>> GetAllAsync();
    Task<(List<Teacher> Items, int TotalCount)> GetPagedAsync(int page, int pageSize);
    Task<Teacher?> GetByIdAsync(Guid id);
    Task<Teacher?> GetByAuthUserIdAsync(Guid authUserId);
    Task AddAsync(Teacher teacher);
    Task UpdateAsync(Teacher teacher);
    Task DeleteAsync(Teacher teacher);
}
