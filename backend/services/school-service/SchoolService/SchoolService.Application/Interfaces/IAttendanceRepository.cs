using SchoolService.Domain.Entities;

namespace SchoolService.Application.Interfaces;

public interface IAttendanceRepository
{
    Task<List<Attendance>> GetByClassroomAndDateAsync(Guid classroomId, DateOnly date);
    Task<List<Attendance>> GetByStudentAsync(Guid studentId);
    Task<Attendance?> GetByStudentClassroomDateAsync(Guid studentId, Guid classroomId, DateOnly date);
    Task AddAsync(Attendance attendance);
    Task UpdateAsync(Attendance attendance);
    Task AddRangeAsync(IEnumerable<Attendance> attendances);
}
