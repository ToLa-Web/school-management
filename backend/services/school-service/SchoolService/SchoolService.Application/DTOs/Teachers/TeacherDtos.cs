using System.ComponentModel.DataAnnotations;

namespace SchoolService.Application.DTOs.Teachers;

public class TeacherCreateDto
{
    [Required(ErrorMessage = "FirstName is required.")]
    [StringLength(100)]
    public string FirstName { get; set; } = null!;

    [Required(ErrorMessage = "LastName is required.")]
    [StringLength(100)]
    public string LastName { get; set; } = null!;

    [StringLength(10)]
    public string? Gender { get; set; }

    public DateTime? DateOfBirth { get; set; }

    [StringLength(20)]
    public string? Phone { get; set; }

    [EmailAddress]
    [StringLength(150)]
    public string? Email { get; set; }

    [StringLength(200)]
    public string? Specialization { get; set; }

    [StringLength(150)]
    public string? Department { get; set; }

    public DateOnly? HireDate { get; set; }
}

public class TeacherUpdateDto
{
    [Required(ErrorMessage = "FirstName is required.")]
    [StringLength(100)]
    public string FirstName { get; set; } = null!;

    [Required(ErrorMessage = "LastName is required.")]
    [StringLength(100)]
    public string LastName { get; set; } = null!;

    [StringLength(10)]
    public string? Gender { get; set; }

    public DateTime? DateOfBirth { get; set; }

    [StringLength(20)]
    public string? Phone { get; set; }

    [EmailAddress]
    [StringLength(150)]
    public string? Email { get; set; }

    [StringLength(200)]
    public string? Specialization { get; set; }

    [StringLength(150)]
    public string? Department { get; set; }

    public DateOnly? HireDate { get; set; }

    public bool IsActive { get; set; } = true;
}

public class TeacherResponseDto
{
    public Guid Id { get; set; }
    public string FirstName { get; set; } = null!;
    public string LastName { get; set; } = null!;
    public string? Gender { get; set; }
    public DateTime? DateOfBirth { get; set; }
    public string? Phone { get; set; }
    public string? Email { get; set; }
    public string? Specialization { get; set; }
    public string? Department { get; set; }
    public DateOnly? HireDate { get; set; }
    public bool IsActive { get; set; }
    public DateTime CreatedAt { get; set; }
}
