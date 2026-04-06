using SchoolService.Domain.Entities;

namespace SchoolService.Application.Interfaces;

public interface IRoomRepository
{
    Task<List<Room>> GetAllAsync();
    Task<Room?> GetByIdAsync(Guid id);
    Task AddAsync(Room room);
    Task UpdateAsync(Room room);
    Task DeleteAsync(Room room);
}
