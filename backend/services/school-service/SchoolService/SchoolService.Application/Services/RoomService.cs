using SchoolService.Application.DTOs.Rooms;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;

namespace SchoolService.Application.Services;

public class RoomService : IRoomService
{
    private readonly IRoomRepository _roomRepository;

    public RoomService(IRoomRepository roomRepository)
    {
        _roomRepository = roomRepository;
    }

    public async Task<List<RoomResponseDto>> GetAllRoomsAsync()
    {
        var rooms = await _roomRepository.GetAllAsync();
        return rooms.Select(MapToResponse).ToList();
    }

    public async Task<RoomResponseDto?> GetRoomByIdAsync(Guid id)
    {
        var room = await _roomRepository.GetByIdAsync(id);
        return room == null ? null : MapToResponse(room);
    }

    public async Task<RoomResponseDto> CreateRoomAsync(RoomCreateDto dto)
    {
        var room = new Room(dto.Name, dto.Location, dto.Capacity, (RoomType)dto.Type);
        await _roomRepository.AddAsync(room);
        return MapToResponse(room);
    }

    public async Task<bool> UpdateRoomAsync(Guid id, RoomUpdateDto dto)
    {
        var room = await _roomRepository.GetByIdAsync(id);
        if (room == null) return false;

        room.UpdateInfo(dto.Name, dto.Location, dto.Capacity, (RoomType)dto.Type);
        if (dto.IsActive) room.Activate(); else room.Deactivate();

        await _roomRepository.UpdateAsync(room);
        return true;
    }

    public async Task<bool> DeleteRoomAsync(Guid id)
    {
        var room = await _roomRepository.GetByIdAsync(id);
        if (room == null) return false;

        await _roomRepository.DeleteAsync(room);
        return true;
    }

    private static RoomResponseDto MapToResponse(Room r) => new()
    {
        Id       = r.Id,
        Name     = r.Name,
        Location = r.Location,
        Capacity = r.Capacity,
        Type     = (int)r.Type,
        TypeName = r.Type.ToString(),
        IsActive = r.IsActive,
        CreatedAt = r.CreatedAt
    };
}
