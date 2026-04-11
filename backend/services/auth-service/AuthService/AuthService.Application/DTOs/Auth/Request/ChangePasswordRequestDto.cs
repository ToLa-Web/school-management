using System.ComponentModel.DataAnnotations;

namespace AuthService.Application.DTOs.Auth.Request;

public class ChangePasswordRequestDto
{
    [Required]
    public Guid UserId { get; set; }

    [Required]
    [StringLength(200, MinimumLength = 8)]
    public string CurrentPassword { get; set; } = string.Empty;

    [Required]
    [StringLength(200, MinimumLength = 8)]
    public string NewPassword { get; set; } = string.Empty;
}
