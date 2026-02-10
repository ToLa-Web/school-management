using AuthService.Domain.Enums;

namespace AuthService.Application.DTOs.Auth.Response;

public class AuthResponseDto
{
    public Guid UserId { get; set; }
    public string Username { get; set; } = string.Empty;
    public string Email { get; set; } = string.Empty;
    public UserRole Role { get; set; }
    public string UserRole { get; set; } = string.Empty;
    public bool IsActive { get; set; }
    public bool IsEmailVerified { get; set; }
    public string Token { get; set; } = string.Empty; // Access token
    public string RefreshToken { get; set; } = string.Empty; // Refresh token
    public DateTime? LastLoginAt { get; set; }
}
