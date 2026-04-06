using SchoolService.Application.DTOs.Subjects;
using SchoolService.Application.Exceptions;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;

namespace SchoolService.Application.Services;

public class SubjectService : ISubjectService
{
    private readonly ISubjectRepository _subjectRepository;
    private readonly ITeacherRepository _teacherRepository;

    public SubjectService(ISubjectRepository subjectRepository, ITeacherRepository teacherRepository)
    {
        _subjectRepository = subjectRepository;
        _teacherRepository = teacherRepository;
    }

    public async Task<IReadOnlyList<SubjectResponseDto>> GetAllAsync()
    {
        var subjects = await _subjectRepository.GetAllAsync();
        return subjects.Select(MapToResponse).ToList();
    }

    public async Task<SubjectResponseDto> GetByIdAsync(Guid id)
    {
        var subject = await _subjectRepository.GetByIdWithTeachersAsync(id);
        if (subject == null) throw new NotFoundException("Subject", id);
        return MapToResponse(subject);
    }

    public async Task<SubjectResponseDto> CreateAsync(SubjectCreateDto dto)
    {
        var subject = new Subject(
            dto.SubjectName,
            dto.YearLevel,
            dto.Category,
            dto.Department,
            dto.Description,
            dto.Code
        );
        await _subjectRepository.AddAsync(subject);
        return MapToResponse(subject);
    }

    public async Task<SubjectResponseDto> UpdateAsync(Guid id, SubjectUpdateDto dto)
    {
        var subject = await _subjectRepository.GetByIdAsync(id);
        if (subject == null) throw new NotFoundException("Subject", id);

        subject.UpdateInfo(
            dto.SubjectName,
            dto.YearLevel,
            dto.Category,
            dto.Department,
            dto.Description,
            dto.Code
        );
        await _subjectRepository.UpdateAsync(subject);
        return MapToResponse(subject);
    }

    public async Task DeleteAsync(Guid id)
    {
        var subject = await _subjectRepository.GetByIdAsync(id);
        if (subject == null) throw new NotFoundException("Subject", id);
        await _subjectRepository.DeleteAsync(subject);
    }

    public async Task AssignTeacherAsync(Guid subjectId, Guid teacherId)
    {
        var subject = await _subjectRepository.GetByIdAsync(subjectId);
        if (subject == null) throw new NotFoundException("Subject", subjectId);

        var teacher = await _teacherRepository.GetByIdAsync(teacherId);
        if (teacher == null) throw new NotFoundException("Teacher", teacherId);

        var existing = await _subjectRepository.GetTeacherSubjectAsync(subjectId, teacherId);
        if (existing != null)
            throw new DuplicateException($"Teacher '{teacherId}' is already assigned to subject '{subjectId}'.");

        await _subjectRepository.AddTeacherSubjectAsync(new TeacherSubject(teacherId, subjectId));
    }

    public async Task RemoveTeacherAsync(Guid subjectId, Guid teacherId)
    {
        var ts = await _subjectRepository.GetTeacherSubjectAsync(subjectId, teacherId);
        if (ts == null)
            throw new NotFoundException($"Assignment of teacher '{teacherId}' to subject '{subjectId}' not found.");

        await _subjectRepository.RemoveTeacherSubjectAsync(ts);
    }

    private static SubjectResponseDto MapToResponse(Subject s) => new()
    {
        Id = s.Id,
        SubjectName = s.SubjectName,
        IsActive = s.IsActive,
        CreatedAt = s.CreatedAt,
        TeacherNames = s.TeacherSubjects
            .Select(ts => $"{ts.Teacher.FirstName} {ts.Teacher.LastName}")
            .ToList(),
        YearLevel = s.YearLevel,
        Category = s.Category,
        Department = s.Department,
        Description = s.Description,
        Code = s.Code
    };
}
