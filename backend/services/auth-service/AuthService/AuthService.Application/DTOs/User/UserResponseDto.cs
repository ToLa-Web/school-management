using AuthService.Domain.Enums;

namespace AuthService.Application.DTOs.User;

public class UserResponseDto
{
    public Guid Id { get; set; }
    public string Email { get; set; } = string.Empty;
    public string Username { get; set; } = string.Empty;
    public UserRole Role { get; set; }
    public string UserRole { get; set; } = string.Empty;
    public bool IsEmailVerified { get; set; }
}