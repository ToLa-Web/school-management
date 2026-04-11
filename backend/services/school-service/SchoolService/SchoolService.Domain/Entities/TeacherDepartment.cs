namespace SchoolService.Domain.Entities;

/// <summary>Many-to-many join: Teacher ↔ Department</summary>
public class TeacherDepartment
{
    public Guid TeacherId { get; private set; }
    public Guid DepartmentId { get; private set; }

    public Teacher Teacher { get; private set; } = null!;
    public Department Department { get; private set; } = null!;

    private TeacherDepartment() { } // EF

    public TeacherDepartment(Guid teacherId, Guid departmentId)
    {
        TeacherId = teacherId;
        DepartmentId = departmentId;
    }
}
