using SchoolService.Application.DTOs.Departments;
using SchoolService.Application.Exceptions;
using SchoolService.Application.Interfaces;
using SchoolService.Domain.Entities;

namespace SchoolService.Application.Services;

public class DepartmentService : IDepartmentService
{
    private readonly IDepartmentRepository _departmentRepository;
    private readonly ITeacherRepository _teacherRepository;

    public DepartmentService(IDepartmentRepository departmentRepository, ITeacherRepository teacherRepository)
    {
        _departmentRepository = departmentRepository;
        _teacherRepository = teacherRepository;
    }

    public async Task<IReadOnlyList<DepartmentResponseDto>> GetAllAsync()
    {
        var departments = await _departmentRepository.GetAllAsync();
        return departments.Select(MapToResponse).ToList();
    }

    public async Task<DepartmentResponseDto> GetByIdAsync(Guid id)
    {
        var department = await _departmentRepository.GetByIdAsync(id);
        if (department == null) throw new NotFoundException("Department", id);
        return MapToResponse(department);
    }

    public async Task<DepartmentDetailDto> GetByIdDetailAsync(Guid id)
    {
        var department = await _departmentRepository.GetByIdWithRelationsAsync(id);
        if (department == null) throw new NotFoundException("Department", id);
        return MapToDetailResponse(department);
    }

    public async Task<DepartmentResponseDto> CreateAsync(DepartmentCreateDto dto)
    {
        var department = new Department(dto.Name, dto.Description);
        await _departmentRepository.AddAsync(department);
        return MapToResponse(department);
    }

    public async Task<DepartmentResponseDto> UpdateAsync(Guid id, DepartmentUpdateDto dto)
    {
        var department = await _departmentRepository.GetByIdAsync(id);
        if (department == null) throw new NotFoundException("Department", id);

        department.UpdateInfo(dto.Name, dto.Description);
        await _departmentRepository.UpdateAsync(department);
        return MapToResponse(department);
    }

    public async Task DeleteAsync(Guid id)
    {
        var department = await _departmentRepository.GetByIdAsync(id);
        if (department == null) throw new NotFoundException("Department", id);
        department.SoftDelete();
        await _departmentRepository.UpdateAsync(department);
    }

    public async Task AssignTeacherAsync(Guid teacherId, Guid departmentId)
    {
        var teacher = await _teacherRepository.GetByIdAsync(teacherId);
        if (teacher == null) throw new NotFoundException("Teacher", teacherId);

        var department = await _departmentRepository.GetByIdAsync(departmentId);
        if (department == null) throw new NotFoundException("Department", departmentId);

        var existing = await _departmentRepository.GetTeacherDepartmentAsync(teacherId, departmentId);
        if (existing != null)
            throw new DuplicateException($"Teacher '{teacherId}' is already assigned to department '{departmentId}'.");

        await _departmentRepository.AddTeacherDepartmentAsync(new TeacherDepartment(teacherId, departmentId));
    }

    public async Task RemoveTeacherAsync(Guid teacherId, Guid departmentId)
    {
        var teacherDepartment = await _departmentRepository.GetTeacherDepartmentAsync(teacherId, departmentId);
        if (teacherDepartment == null)
            throw new NotFoundException($"Teacher '{teacherId}' is not assigned to department '{departmentId}'.");

        await _departmentRepository.RemoveTeacherDepartmentAsync(teacherDepartment);
    }

    private static DepartmentResponseDto MapToResponse(Department department) => new()
    {
        Id = department.Id,
        Name = department.Name,
        Description = department.Description,
        IsActive = department.IsActive,
        CreatedAt = department.CreatedAt,
    };

    private static DepartmentDetailDto MapToDetailResponse(Department department) => new()
    {
        Id = department.Id,
        Name = department.Name,
        Description = department.Description,
        IsActive = department.IsActive,
        CreatedAt = department.CreatedAt,
        SubjectCount = department.Subjects.Count,
        TeacherCount = department.TeacherDepartments.Count,
        Subjects = department.Subjects.Select(s => new SubjectBasicDto
        {
            Id = s.Id,
            SubjectName = s.SubjectName,
            Code = s.Code,
        }).ToList(),
        Teachers = department.TeacherDepartments.Select(td => new TeacherBasicDto
        {
            Id = td.Teacher.Id,
            FirstName = td.Teacher.FirstName,
            LastName = td.Teacher.LastName,
            Email = td.Teacher.Email,
        }).ToList(),
    };
}
