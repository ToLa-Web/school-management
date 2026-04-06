using SchoolService.Application.DTOs.Materials;

namespace SchoolService.Application.Interfaces;

public interface IMaterialService
{
    Task<List<MaterialResponseDto>> GetMaterialsByClassroomAsync(Guid classroomId);
    Task<MaterialResponseDto> CreateMaterialAsync(MaterialCreateDto dto);
    Task<bool> UpdateMaterialAsync(Guid id, MaterialUpdateDto dto);
    Task<bool> DeleteMaterialAsync(Guid id);
}
