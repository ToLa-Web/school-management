using SchoolService.Application.DTOs.Students;

namespace SchoolService.Application.Interfaces;

public interface IStudentService
{
    Task<IReadOnlyList<StudentResponseDto>> GetAllAsync();
    Task<StudentResponseDto?> GetByIdAsync(Guid id);
    Task<StudentResponseDto> CreateAsync(StudentCreateDto dto);
    Task<StudentResponseDto?> UpdateAsync(Guid id, StudentUpdateDto dto);
    Task<bool> DeleteAsync(Guid id);
}

