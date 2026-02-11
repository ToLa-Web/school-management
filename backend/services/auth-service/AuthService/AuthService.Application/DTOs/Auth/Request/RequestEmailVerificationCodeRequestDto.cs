using System.ComponentModel.DataAnnotations;

namespace AuthService.Application.DTOs.Auth.Request;

public class RequestEmailVerificationCodeRequestDto
{
    [Required]
    [EmailAddress]
    public string Email { get; set; } = string.Empty;
}
