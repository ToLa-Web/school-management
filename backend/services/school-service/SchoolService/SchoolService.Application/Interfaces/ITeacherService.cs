using SchoolService.Application.DTOs.Teachers;

namespace SchoolService.Application.Interfaces;

public interface ITeacherService
{
    Task<IReadOnlyList<TeacherResponseDto>> GetAllAsync();
    Task<TeacherResponseDto?> GetByIdAsync(Guid id);
    Task<TeacherResponseDto> CreateAsync(TeacherCreateDto dto);
    Task<TeacherResponseDto?> UpdateAsync(Guid id, TeacherUpdateDto dto);
    Task<bool> DeleteAsync(Guid id);
}
