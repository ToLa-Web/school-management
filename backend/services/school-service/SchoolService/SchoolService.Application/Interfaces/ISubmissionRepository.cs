using SchoolService.Domain.Entities;

namespace SchoolService.Application.Interfaces;

public interface ISubmissionRepository
{
    Task<List<Submission>> GetByMaterialAsync(Guid materialId);
    Task<Submission?> GetByIdAsync(Guid id);
    Task<Submission?> GetByIdWithDetailsAsync(Guid id);
    Task AddAsync(Submission submission);
    Task UpdateAsync(Submission submission);
}
