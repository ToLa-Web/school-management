using SchoolService.Application.DTOs.Departments;

namespace SchoolService.Application.Interfaces;

public interface IDepartmentService
{
    Task<IReadOnlyList<DepartmentResponseDto>> GetAllAsync();
    Task<DepartmentResponseDto> GetByIdAsync(Guid id);
    Task<DepartmentDetailDto> GetByIdDetailAsync(Guid id);
    Task<DepartmentResponseDto> CreateAsync(DepartmentCreateDto dto);
    Task<DepartmentResponseDto> UpdateAsync(Guid id, DepartmentUpdateDto dto);
    Task DeleteAsync(Guid id);
    Task AssignTeacherAsync(Guid teacherId, Guid departmentId);
    Task RemoveTeacherAsync(Guid teacherId, Guid departmentId);
}
