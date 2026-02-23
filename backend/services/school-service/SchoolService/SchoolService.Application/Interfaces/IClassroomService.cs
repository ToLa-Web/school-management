using SchoolService.Application.DTOs.Classrooms;

namespace SchoolService.Application.Interfaces;

public interface IClassroomService
{
    Task<IReadOnlyList<ClassroomResponseDto>> GetAllAsync();
    Task<ClassroomDetailResponseDto?> GetByIdAsync(Guid id);
    Task<ClassroomResponseDto> CreateAsync(ClassroomCreateDto dto);
    Task<ClassroomResponseDto?> UpdateAsync(Guid id, ClassroomUpdateDto dto);
    Task<bool> DeleteAsync(Guid id);
    Task<bool> EnrollStudentAsync(Guid classroomId, Guid studentId);
    Task<bool> UnenrollStudentAsync(Guid classroomId, Guid studentId);
}
