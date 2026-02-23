using SchoolService.Application.DTOs.Classrooms;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;

namespace SchoolService.Application.Services;

public class ClassroomService : IClassroomService
{
    private readonly IClassroomRepository _classroomRepository;
    private readonly IStudentRepository _studentRepository;

    public ClassroomService(
        IClassroomRepository classroomRepository,
        IStudentRepository studentRepository)
    {
        _classroomRepository = classroomRepository;
        _studentRepository = studentRepository;
    }

    public async Task<IReadOnlyList<ClassroomResponseDto>> GetAllAsync()
    {
        var classrooms = await _classroomRepository.GetAllAsync();
        return classrooms
            .Select(MapToResponse)
            .ToList();
    }

    public async Task<ClassroomDetailResponseDto?> GetByIdAsync(Guid id)
    {
        var classroom = await _classroomRepository.GetByIdWithDetailsAsync(id);
        return classroom == null ? null : MapToDetailResponse(classroom);
    }

    public async Task<ClassroomResponseDto> CreateAsync(ClassroomCreateDto dto)
    {
        var classroom = new Classroom(dto.Name);
        classroom.UpdateInfo(dto.Name, dto.Grade, dto.AcademicYear);
        classroom.AssignTeacher(dto.TeacherId);

        await _classroomRepository.AddAsync(classroom);
        return MapToResponse(classroom);
    }

    public async Task<ClassroomResponseDto?> UpdateAsync(Guid id, ClassroomUpdateDto dto)
    {
        var classroom = await _classroomRepository.GetByIdAsync(id);
        if (classroom == null)
        {
            return null;
        }

        classroom.UpdateInfo(dto.Name, dto.Grade, dto.AcademicYear);
        classroom.AssignTeacher(dto.TeacherId);

        if (dto.IsActive)
            classroom.Activate();
        else
            classroom.Deactivate();

        await _classroomRepository.UpdateAsync(classroom);
        return MapToResponse(classroom);
    }

    public async Task<bool> DeleteAsync(Guid id)
    {
        var classroom = await _classroomRepository.GetByIdAsync(id);
        if (classroom == null)
        {
            return false;
        }

        await _classroomRepository.DeleteAsync(classroom);
        return true;
    }

    public async Task<bool> EnrollStudentAsync(Guid classroomId, Guid studentId)
    {
        var classroom = await _classroomRepository.GetByIdAsync(classroomId);
        if (classroom == null) return false;

        var student = await _studentRepository.GetByIdAsync(studentId);
        if (student == null) return false;

        var existing = await _classroomRepository.GetEnrollmentAsync(classroomId, studentId);
        if (existing != null) return false; // already enrolled

        var enrollment = new StudentClassroom(studentId, classroomId);
        await _classroomRepository.AddEnrollmentAsync(enrollment);
        return true;
    }

    public async Task<bool> UnenrollStudentAsync(Guid classroomId, Guid studentId)
    {
        var enrollment = await _classroomRepository.GetEnrollmentAsync(classroomId, studentId);
        if (enrollment == null) return false;

        await _classroomRepository.RemoveEnrollmentAsync(enrollment);
        return true;
    }

    private static ClassroomResponseDto MapToResponse(Classroom c) => new()
    {
        Id = c.Id,
        Name = c.Name,
        Grade = c.Grade,
        AcademicYear = c.AcademicYear,
        TeacherId = c.TeacherId,
        TeacherName = c.Teacher != null
            ? $"{c.Teacher.FirstName} {c.Teacher.LastName}"
            : null,
        IsActive = c.IsActive,
        CreatedAt = c.CreatedAt,
        StudentCount = c.StudentClassrooms.Count
    };

    private static ClassroomDetailResponseDto MapToDetailResponse(Classroom c) => new()
    {
        Id = c.Id,
        Name = c.Name,
        Grade = c.Grade,
        AcademicYear = c.AcademicYear,
        TeacherId = c.TeacherId,
        TeacherName = c.Teacher != null
            ? $"{c.Teacher.FirstName} {c.Teacher.LastName}"
            : null,
        IsActive = c.IsActive,
        CreatedAt = c.CreatedAt,
        Students = c.StudentClassrooms
            .Select(sc => new ClassroomStudentDto
            {
                StudentId = sc.StudentId,
                FirstName = sc.Student.FirstName,
                LastName = sc.Student.LastName,
                EnrolledAt = sc.EnrolledAt
            })
            .ToList()
    };
}
