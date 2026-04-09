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

    [StringLength(20)]
    public string? Semester { get; set; }

    public Guid? RoomId { get; set; }

    public Guid? TeacherId { get; set; }

    [Required(ErrorMessage = "SubjectId is required.")]
    public Guid SubjectId { get; set; }
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

    [StringLength(20)]
    public string? Semester { get; set; }

    public Guid? RoomId { get; set; }

    public Guid? TeacherId { get; set; }

    [Required(ErrorMessage = "SubjectId is required.")]
    public Guid SubjectId { get; set; }

    public bool IsActive { get; set; } = true;
}

public class ClassroomResponseDto
{
    public Guid Id { get; set; }
    public string Name { get; set; } = null!;
    public string? Grade { get; set; }
    public string? AcademicYear { get; set; }
    public string? Semester { get; set; }
    public Guid? RoomId { get; set; }
    public string? RoomName { get; set; }
    public Guid? TeacherId { get; set; }
    public string? TeacherName { get; set; }
    public Guid SubjectId { get; set; }
    public string SubjectName { get; set; } = null!;
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
    public string? Semester { get; set; }
    public Guid? RoomId { get; set; }
    public string? RoomName { get; set; }
    public Guid? TeacherId { get; set; }
    public string? TeacherName { get; set; }
    public Guid SubjectId { get; set; }
    public string SubjectName { get; set; } = null!;
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
    public List<ClassroomStudentDto> Students { get; set; } = new();
}

public class ClassroomStudentDto
{
    public Guid StudentId { get; set; }
    public string FirstName { get; set; } = null!;
    public string LastName { get; set; } = null!;
    public string? Email { get; set; }
    public string? Phone { get; set; }
    public string? Gender { get; set; }
    public DateTime? DateOfBirth { get; set; }
    public DateTime EnrolledAt { get; set; }
    /// <summary>"Active" | "Dropped" | "Completed"</summary>
    public string Status { get; set; } = null!;
    public DateTime? UnenrolledAt { get; set; }
}

public class EnrollStudentDto
{
    public Guid StudentId { get; set; }
}
