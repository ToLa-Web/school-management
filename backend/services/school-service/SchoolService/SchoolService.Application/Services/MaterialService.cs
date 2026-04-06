using SchoolService.Application.DTOs.Materials;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;

namespace SchoolService.Application.Services;

public class MaterialService : IMaterialService
{
    private readonly IMaterialRepository _materialRepository;

    public MaterialService(IMaterialRepository materialRepository)
    {
        _materialRepository = materialRepository;
    }

    public async Task<List<MaterialResponseDto>> GetMaterialsByClassroomAsync(Guid classroomId)
    {
        var materials = await _materialRepository.GetByClassroomAsync(classroomId);
        return materials
            .Select(m => new MaterialResponseDto
            {
                Id = m.Id,
                ClassroomId = m.ClassroomId,
                Title = m.Title,
                Description = m.Description,
                Url = m.Url,
                Type = m.Type,
                IsActive = m.IsActive,
                CreatedAt = m.CreatedAt
            })
            .ToList();
    }

    public async Task<MaterialResponseDto> CreateMaterialAsync(MaterialCreateDto dto)
    {
        var material = new Material(dto.ClassroomId, dto.Title, dto.Type, dto.Url, dto.Description);
        await _materialRepository.AddAsync(material);

        return new MaterialResponseDto
        {
            Id = material.Id,
            ClassroomId = material.ClassroomId,
            Title = material.Title,
            Description = material.Description,
            Url = material.Url,
            Type = material.Type,
            IsActive = material.IsActive,
            CreatedAt = material.CreatedAt
        };
    }

    public async Task<bool> UpdateMaterialAsync(Guid id, MaterialUpdateDto dto)
    {
        var material = await _materialRepository.GetByIdAsync(id);
        if (material == null) return false;

        material.UpdateInfo(dto.Title, dto.Type, dto.Url, dto.Description);
        if (dto.IsActive) material.Activate(); else material.Deactivate();

        await _materialRepository.UpdateAsync(material);
        return true;
    }

    public async Task<bool> DeleteMaterialAsync(Guid id)
    {
        var material = await _materialRepository.GetByIdAsync(id);
        if (material == null) return false;

        await _materialRepository.DeleteAsync(material);
        return true;
    }
}
