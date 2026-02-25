using SchoolService.Domain.Entities;

namespace SchoolService.Application.Interfaces;

public interface IGradeRepository
{
    Task<List<StudentGrade>> GetFilteredAsync(Guid? studentId, Guid? subjectId, string? semester);
    Task<StudentGrade?> GetByIdAsync(Guid id);
    Task AddAsync(StudentGrade grade);
    Task UpdateAsync(StudentGrade grade);
    Task DeleteAsync(StudentGrade grade);
}
