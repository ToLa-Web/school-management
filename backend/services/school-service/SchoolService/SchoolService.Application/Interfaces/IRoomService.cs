using SchoolService.Application.DTOs.Rooms;

namespace SchoolService.Application.Interfaces;

public interface IRoomService
{
    Task<List<RoomResponseDto>> GetAllRoomsAsync();
    Task<RoomResponseDto?> GetRoomByIdAsync(Guid id);
    Task<RoomResponseDto> CreateRoomAsync(RoomCreateDto dto);
    Task<bool> UpdateRoomAsync(Guid id, RoomUpdateDto dto);
    Task<bool> DeleteRoomAsync(Guid id);
}
