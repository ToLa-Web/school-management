using SchoolService.Application.DTOs.Grades;
using SchoolService.Application.Exceptions;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;

namespace SchoolService.Application.Services;

public class GradeService : IGradeService
{
    private readonly IGradeRepository _gradeRepository;
    private readonly IStudentRepository _studentRepository;
    private readonly ISubjectRepository _subjectRepository;

    public GradeService(
        IGradeRepository gradeRepository,
        IStudentRepository studentRepository,
        ISubjectRepository subjectRepository)
    {
        _gradeRepository = gradeRepository;
        _studentRepository = studentRepository;
        _subjectRepository = subjectRepository;
    }

    public async Task<IReadOnlyList<GradeResponseDto>> GetAllAsync(Guid? studentId, Guid? subjectId, string? semester)
    {
        var grades = await _gradeRepository.GetFilteredAsync(studentId, subjectId, semester);
        return grades.Select(MapToResponse).ToList();
    }

    public async Task<GradeResponseDto> GetByIdAsync(Guid id)
    {
        var grade = await _gradeRepository.GetByIdAsync(id);
        if (grade == null) throw new NotFoundException("Grade", id);
        return MapToResponse(grade);
    }

    public async Task<GradeResponseDto> CreateAsync(GradeCreateDto dto)
    {
        var student = await _studentRepository.GetByIdAsync(dto.StudentId);
        if (student == null) throw new NotFoundException("Student", dto.StudentId);

        var subject = await _subjectRepository.GetByIdAsync(dto.SubjectId);
        if (subject == null) throw new NotFoundException("Subject", dto.SubjectId);

        var grade = new StudentGrade(dto.StudentId, dto.SubjectId, dto.Score, dto.Semester);
        await _gradeRepository.AddAsync(grade);

        // Reload with navigation properties
        grade = await _gradeRepository.GetByIdAsync(grade.Id) ?? grade;
        return MapToResponse(grade);
    }

    public async Task<GradeResponseDto> UpdateAsync(Guid id, GradeUpdateDto dto)
    {
        var grade = await _gradeRepository.GetByIdAsync(id);
        if (grade == null) throw new NotFoundException("Grade", id);

        grade.UpdateScore(dto.Score, dto.Semester);
        await _gradeRepository.UpdateAsync(grade);
        return MapToResponse(grade);
    }

    public async Task DeleteAsync(Guid id)
    {
        var grade = await _gradeRepository.GetByIdAsync(id);
        if (grade == null) throw new NotFoundException("Grade", id);
        await _gradeRepository.DeleteAsync(grade);
    }

    private static GradeResponseDto MapToResponse(StudentGrade g) => new()
    {
        Id = g.Id,
        StudentId = g.StudentId,
        StudentName = g.Student != null ? $"{g.Student.FirstName} {g.Student.LastName}" : "",
        SubjectId = g.SubjectId,
        SubjectName = g.Subject?.SubjectName ?? "",
        Score = g.Score,
        Semester = g.Semester,
        CreatedAt = g.CreatedAt
    };
}
