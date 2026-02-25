using SchoolService.Domain.Entities;

namespace SchoolService.Application.Interfaces;

public interface IScheduleRepository
{
    Task<List<Schedule>> GetByClassroomAsync(Guid classroomId);
    Task<List<Schedule>> GetByTeacherAsync(Guid teacherId);
    Task<Schedule?> GetByIdAsync(Guid id);
    Task AddAsync(Schedule schedule);
    Task UpdateAsync(Schedule schedule);
    Task DeleteAsync(Schedule schedule);
}
