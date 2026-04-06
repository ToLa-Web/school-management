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
    /// <summary>
    /// Returns active schedules for the given teacher that overlap the requested day+time window.
    /// Used for teacher conflict detection before creating/updating a schedule.
    /// </summary>
    Task<List<Schedule>> GetTeacherConflictsAsync(Guid teacherId, SchoolDayOfWeek day, TimeOnly start, TimeOnly end, Guid? excludeScheduleId = null);
}
