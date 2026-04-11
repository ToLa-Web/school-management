using Microsoft.EntityFrameworkCore;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;
using SchoolService.Infrastructure.Data;

namespace SchoolService.Infrastructure.Repositories;

public class SubmissionRepository : ISubmissionRepository
{
    private readonly SchoolDbContext _context;

    public SubmissionRepository(SchoolDbContext context)
    {
        _context = context;
    }

    public async Task<List<Submission>> GetByMaterialAsync(Guid materialId)
        => await _context.Submissions
            .Where(s => s.MaterialId == materialId)
            .Include(s => s.Student)
            .Include(s => s.Material)
            .OrderBy(s => s.SubmittedAt)
            .ToListAsync();

    public async Task<List<Submission>> GetByStudentAsync(Guid studentId)
        => await _context.Submissions
            .Where(s => s.StudentId == studentId)
            .Include(s => s.Student)
            .Include(s => s.Material)
            .OrderByDescending(s => s.SubmittedAt)
            .ToListAsync();

    public async Task<Submission?> GetByIdAsync(Guid id)
        => await _context.Submissions.FindAsync(id);

    public async Task<Submission?> GetByIdWithDetailsAsync(Guid id)
        => await _context.Submissions
            .Include(s => s.Student)
            .Include(s => s.Material)
            .FirstOrDefaultAsync(s => s.Id == id);

    public async Task AddAsync(Submission submission)
    {
        await _context.Submissions.AddAsync(submission);
        await _context.SaveChangesAsync();
    }

    public async Task UpdateAsync(Submission submission)
    {
        _context.Submissions.Update(submission);
        await _context.SaveChangesAsync();
    }
}
