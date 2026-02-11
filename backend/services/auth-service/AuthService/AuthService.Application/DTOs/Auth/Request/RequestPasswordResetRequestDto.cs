using System.ComponentModel.DataAnnotations;

namespace AuthService.Application.DTOs.Auth.Request;

public class RequestPasswordResetRequestDto
{
    [Required]
    [EmailAddress]
    public string Email { get; set; } = string.Empty;
}
