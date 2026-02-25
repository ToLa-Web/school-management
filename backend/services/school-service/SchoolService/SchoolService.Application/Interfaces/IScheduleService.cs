using SchoolService.Application.DTOs.Schedules;

namespace SchoolService.Application.Interfaces;

public interface IScheduleService
{
    Task<IReadOnlyList<ScheduleResponseDto>> GetByClassroomAsync(Guid classroomId);
    Task<IReadOnlyList<ScheduleResponseDto>> GetByTeacherAsync(Guid teacherId);
    Task<ScheduleResponseDto> GetByIdAsync(Guid id);
    Task<ScheduleResponseDto> CreateAsync(ScheduleCreateDto dto);
    Task<ScheduleResponseDto> UpdateAsync(Guid id, ScheduleUpdateDto dto);
    Task DeleteAsync(Guid id);
}
