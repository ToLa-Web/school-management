using SchoolService.Application.DTOs.Attendance;

namespace SchoolService.Application.Interfaces;

public interface IAttendanceService
{
    Task<IReadOnlyList<AttendanceResponseDto>> GetByClassroomAndDateAsync(Guid classroomId, DateOnly date);
    Task<IReadOnlyList<AttendanceResponseDto>> GetStudentHistoryAsync(Guid studentId);
    Task BulkMarkAsync(BulkMarkAttendanceDto dto);
}
