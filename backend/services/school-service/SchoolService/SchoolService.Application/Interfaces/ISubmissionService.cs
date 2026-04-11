using SchoolService.Application.DTOs.Submissions;

namespace SchoolService.Application.Interfaces;

public interface ISubmissionService
{
    Task<SubmissionResponseDto> SubmitAsync(Guid studentId, SubmissionCreateDto dto);
    Task<bool> GradeSubmissionAsync(Guid submissionId, GradeSubmissionDto dto);
    Task<List<SubmissionResponseDto>> GetSubmissionsByMaterialAsync(Guid materialId);
    Task<List<SubmissionResponseDto>> GetSubmissionsByStudentAsync(Guid studentId);
}
