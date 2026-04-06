using Microsoft.EntityFrameworkCore;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;
using SchoolService.Infrastructure.Data;

namespace SchoolService.Infrastructure.Repositories;

public class AnnouncementRepository : IAnnouncementRepository
{
    private readonly SchoolDbContext _context;

    public AnnouncementRepository(SchoolDbContext context) => _context = context;

    public async Task<List<Announcement>> GetAllAsync(Guid? classroomId = null)
    {
        var query = _context.Announcements
            .AsNoTracking()
            .Include(a => a.Classroom)
            .Include(a => a.AuthorTeacher)
            .AsQueryable();

        if (classroomId.HasValue)
            // Return school-wide OR classroom-specific
            query = query.Where(a => a.ClassroomId == null || a.ClassroomId == classroomId.Value);

        return await query.OrderByDescending(a => a.CreatedAt).ToListAsync();
    }

    public async Task<Announcement?> GetByIdAsync(Guid id)
        => await _context.Announcements
            .Include(a => a.Classroom)
            .Include(a => a.AuthorTeacher)
            .FirstOrDefaultAsync(a => a.Id == id);

    public async Task AddAsync(Announcement announcement)
    {
        await _context.Announcements.AddAsync(announcement);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(Announcement announcement)
    {
        _context.Announcements.Update(announcement);
        await _context.SaveChangesAsync();
    }

    public async Task DeleteAsync(Announcement announcement)
    {
        _context.Announcements.Remove(announcement);
        await _context.SaveChangesAsync();
    }
}
