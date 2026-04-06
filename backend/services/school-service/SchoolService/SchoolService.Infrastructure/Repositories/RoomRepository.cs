using Microsoft.EntityFrameworkCore;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;
using SchoolService.Infrastructure.Data;

namespace SchoolService.Infrastructure.Repositories;

public class RoomRepository : IRoomRepository
{
    private readonly SchoolDbContext _context;

    public RoomRepository(SchoolDbContext context)
    {
        _context = context;
    }

    public async Task<List<Room>> GetAllAsync()
        => await _context.Rooms.AsNoTracking().ToListAsync();

    public async Task<Room?> GetByIdAsync(Guid id)
        => await _context.Rooms.FindAsync(id);

    public async Task AddAsync(Room room)
    {
        await _context.Rooms.AddAsync(room);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(Room room)
    {
        _context.Rooms.Update(room);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(Room room)
    {
        _context.Rooms.Remove(room);
        await _context.SaveChangesAsync();
    }
}
