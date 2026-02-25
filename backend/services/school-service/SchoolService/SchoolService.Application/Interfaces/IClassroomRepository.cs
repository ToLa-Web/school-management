using SchoolService.Domain.Entities;

namespace SchoolService.Application.Interfaces;

public interface IClassroomRepository
{
    Task<List<Classroom>> GetAllAsync();
    Task<(List<Classroom> Items, int TotalCount)> GetPagedAsync(int page, int pageSize);
    Task<Classroom?> GetByIdAsync(Guid id);
    Task<Classroom?> GetByIdWithDetailsAsync(Guid id);
    Task AddAsync(Classroom classroom);
    Task UpdateAsync(Classroom classroom);
    Task DeleteAsync(Classroom classroom);
    Task<StudentClassroom?> GetEnrollmentAsync(Guid classroomId, Guid studentId);
    Task AddEnrollmentAsync(StudentClassroom enrollment);
    Task RemoveEnrollmentAsync(StudentClassroom enrollment);
}
