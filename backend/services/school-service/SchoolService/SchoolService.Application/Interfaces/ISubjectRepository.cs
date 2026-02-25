using SchoolService.Domain.Entities;

namespace SchoolService.Application.Interfaces;

public interface ISubjectRepository
{
    Task<List<Subject>> GetAllAsync();
    Task<Subject?> GetByIdAsync(Guid id);
    Task<Subject?> GetByIdWithTeachersAsync(Guid id);
    Task AddAsync(Subject subject);
    Task UpdateAsync(Subject subject);
    Task DeleteAsync(Subject subject);
    Task<TeacherSubject?> GetTeacherSubjectAsync(Guid subjectId, Guid teacherId);
    Task AddTeacherSubjectAsync(TeacherSubject ts);
    Task RemoveTeacherSubjectAsync(TeacherSubject ts);
}
