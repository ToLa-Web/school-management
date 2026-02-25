using SchoolService.Application.DTOs.Grades;

namespace SchoolService.Application.Interfaces;

public interface IGradeService
{
    Task<IReadOnlyList<GradeResponseDto>> GetAllAsync(Guid? studentId, Guid? subjectId, string? semester);
    Task<GradeResponseDto> GetByIdAsync(Guid id);
    Task<GradeResponseDto> CreateAsync(GradeCreateDto dto);
    Task<GradeResponseDto> UpdateAsync(Guid id, GradeUpdateDto dto);
    Task DeleteAsync(Guid id);
}
