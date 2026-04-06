using SchoolService.Application.DTOs.Announcements;

namespace SchoolService.Application.Interfaces;

public interface IAnnouncementService
{
    Task<IReadOnlyList<AnnouncementResponseDto>> GetAllAsync(Guid? classroomId = null);
    Task<AnnouncementResponseDto> GetByIdAsync(Guid id);
    Task<AnnouncementResponseDto> CreateAsync(AnnouncementCreateDto dto);
    Task<AnnouncementResponseDto> UpdateAsync(Guid id, AnnouncementUpdateDto dto);
    Task<AnnouncementResponseDto> PublishAsync(Guid id);
    Task<AnnouncementResponseDto> UnpublishAsync(Guid id);
    Task DeleteAsync(Guid id);
}
