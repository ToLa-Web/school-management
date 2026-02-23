using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Classrooms;

public class ClassroomCreateDto
{
    [Required(ErrorMessage = "Classroom Name is required.")]
    [StringLength(150, ErrorMessage = "Name cannot exceed 150 characters.")]
    public string Name { get; set; } = null!;

    [StringLength(50)]
    public string? Grade { get; set; }

    [StringLength(20)]
    public string? AcademicYear { get; set; }

    public Guid? TeacherId { get; set; }
}

public class ClassroomUpdateDto
{
    [Required(ErrorMessage = "Classroom Name is required.")]
    [StringLength(150, ErrorMessage = "Name cannot exceed 150 characters.")]
    public string Name { get; set; } = null!;

    [StringLength(50)]
    public string? Grade { get; set; }

    [StringLength(20)]
    public string? AcademicYear { get; set; }

    public Guid? TeacherId { get; set; }

    public bool IsActive { get; set; } = true;
}

public class ClassroomResponseDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = null!;
    public string? Grade { get; set; }
    public string? AcademicYear { get; set; }
    public Guid? TeacherId { get; set; }
    public string? TeacherName { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public int StudentCount { get; set; }
}

public class ClassroomDetailResponseDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = null!;
    public string? Grade { get; set; }
    public string? AcademicYear { get; set; }
    public Guid? TeacherId { get; set; }
    public string? TeacherName { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<ClassroomStudentDto> Students { get; set; } = new();
}

public class ClassroomStudentDto
{
    public Guid StudentId { get; set; }
    public string FirstName { get; set; } = null!;
    public string LastName { get; set; } = null!;
    public DateTime EnrolledAt { get; set; }
}

public class EnrollStudentDto
{
    public Guid StudentId { get; set; }
}
