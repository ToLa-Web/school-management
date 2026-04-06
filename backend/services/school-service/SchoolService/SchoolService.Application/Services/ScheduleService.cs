using SchoolService.Application.DTOs.Schedules;
using SchoolService.Application.Exceptions;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;

namespace SchoolService.Application.Services;

public class ScheduleService : IScheduleService
{
    private readonly IScheduleRepository _scheduleRepository;
    private readonly IClassroomRepository _classroomRepository;
    private readonly ISubjectRepository _subjectRepository;

    public ScheduleService(
        IScheduleRepository scheduleRepository,
        IClassroomRepository classroomRepository,
        ISubjectRepository subjectRepository)
    {
        _scheduleRepository = scheduleRepository;
        _classroomRepository = classroomRepository;
        _subjectRepository = subjectRepository;
    }

    public async Task<IReadOnlyList<ScheduleResponseDto>> GetByClassroomAsync(Guid classroomId)
    {
        var schedules = await _scheduleRepository.GetByClassroomAsync(classroomId);
        return schedules.Select(MapToResponse).ToList();
    }

    public async Task<IReadOnlyList<ScheduleResponseDto>> GetByTeacherAsync(Guid teacherId)
    {
        var schedules = await _scheduleRepository.GetByTeacherAsync(teacherId);
        return schedules.Select(MapToResponse).ToList();
    }

    public async Task<ScheduleResponseDto> GetByIdAsync(Guid id)
    {
        var schedule = await _scheduleRepository.GetByIdAsync(id);
        if (schedule == null) throw new NotFoundException("Schedule", id);
        return MapToResponse(schedule);
    }

    public async Task<ScheduleResponseDto> CreateAsync(ScheduleCreateDto dto)
    {
        var classroom = await _classroomRepository.GetByIdAsync(dto.ClassroomId);
        if (classroom == null) throw new NotFoundException("Classroom", dto.ClassroomId);

        var subject = await _subjectRepository.GetByIdAsync(dto.SubjectId);
        if (subject == null) throw new NotFoundException("Subject", dto.SubjectId);

        var day   = (SchoolDayOfWeek)dto.DayOfWeek;
        var start = dto.StartTime;
        var end   = dto.EndTime;

        if (dto.TeacherId.HasValue)
        {
            var conflicts = await _scheduleRepository.GetTeacherConflictsAsync(
                dto.TeacherId.Value, day, start, end);
            if (conflicts.Count > 0)
                throw new ConflictException($"Teacher already has a schedule on {day} from {start} to {end}.");
        }

        var schedule = new Schedule(dto.ClassroomId, dto.SubjectId, dto.TeacherId,
            day, start, end, (SessionType)dto.Type);
        await _scheduleRepository.AddAsync(schedule);

        var loaded = await _scheduleRepository.GetByIdAsync(schedule.Id);
        return loaded != null ? MapToResponse(loaded) : MapToResponse(schedule);
    }

    public async Task<ScheduleResponseDto> UpdateAsync(Guid id, ScheduleUpdateDto dto)
    {
        var schedule = await _scheduleRepository.GetByIdAsync(id);
        if (schedule == null) throw new NotFoundException("Schedule", id);

        var day   = (SchoolDayOfWeek)dto.DayOfWeek;
        var start = dto.StartTime;
        var end   = dto.EndTime;

        if (dto.TeacherId.HasValue)
        {
            var conflicts = await _scheduleRepository.GetTeacherConflictsAsync(
                dto.TeacherId.Value, day, start, end, excludeScheduleId: id);
            if (conflicts.Count > 0)
                throw new ConflictException($"Teacher already has a schedule on {day} from {start} to {end}.");
        }

        schedule.UpdateInfo(day, start, end, (SessionType)dto.Type);
        schedule.UpdateTeacher(dto.TeacherId);
        await _scheduleRepository.UpdateAsync(schedule);
        return MapToResponse(schedule);
    }

    public async Task DeleteAsync(Guid id)
    {
        var schedule = await _scheduleRepository.GetByIdAsync(id);
        if (schedule == null) throw new NotFoundException("Schedule", id);
        await _scheduleRepository.DeleteAsync(schedule);
    }

    private static ScheduleResponseDto MapToResponse(Schedule s) => new()
    {
        Id            = s.Id,
        ClassroomId   = s.ClassroomId,
        ClassroomName = s.Classroom?.Name ?? "",
        SubjectId     = s.SubjectId,
        SubjectName   = s.Subject?.SubjectName ?? "",
        TeacherId     = s.TeacherId,
        TeacherName   = s.Teacher != null ? $"{s.Teacher.FirstName} {s.Teacher.LastName}" : null,
        DayOfWeek     = (int)s.DayOfWeek,
        DayOfWeekName = s.DayOfWeek.ToString(),
        StartTime     = s.StartTime,
        EndTime       = s.EndTime,
        Type          = (int)s.Type,
        TypeName      = s.Type.ToString()
    };
}
