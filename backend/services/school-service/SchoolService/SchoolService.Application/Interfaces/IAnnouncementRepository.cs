using SchoolService.Domain.Entities;

namespace SchoolService.Application.Interfaces;

public interface IAnnouncementRepository
{
    Task<List<Announcement>> GetAllAsync(Guid? classroomId = null);
    Task<Announcement?> GetByIdAsync(Guid id);
    Task AddAsync(Announcement announcement);
    Task UpdateAsync(Announcement announcement);
    Task DeleteAsync(Announcement announcement);
}
