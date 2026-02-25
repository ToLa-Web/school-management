using SchoolService.Application.DTOs.Subjects;

namespace SchoolService.Application.Interfaces;

public interface ISubjectService
{
    Task<IReadOnlyList<SubjectResponseDto>> GetAllAsync();
    Task<SubjectResponseDto> GetByIdAsync(Guid id);
    Task<SubjectResponseDto> CreateAsync(SubjectCreateDto dto);
    Task<SubjectResponseDto> UpdateAsync(Guid id, SubjectUpdateDto dto);
    Task DeleteAsync(Guid id);
    Task AssignTeacherAsync(Guid subjectId, Guid teacherId);
    Task RemoveTeacherAsync(Guid subjectId, Guid teacherId);
}
