using SchoolService.Domain.Entities;

namespace SchoolService.Application.Interfaces;

public interface IMaterialRepository
{
    Task<List<Material>> GetByClassroomAsync(Guid classroomId);
    Task<Material?> GetByIdAsync(Guid id);
    Task AddAsync(Material material);
    Task UpdateAsync(Material material);
    Task DeleteAsync(Material material);
}
