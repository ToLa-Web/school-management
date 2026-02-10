using AuthService.Application.DTOs.Auth.Response;
using AuthService.Application.DTOs.User;

namespace AuthService.Application.Interfaces;

public interface IAuthenticationService
{ 
    Task<UserResponseDto> RegisterAsync(UserCreateDto dto);
    Task<AuthResponseDto?> AuthenticateAsync(string email, string password);
    Task RequestEmailVerificationCodeAsync(string email);
    Task<bool> VerifyEmailAsync(string email, string code);
    Task<AuthResponseDto?> RefreshTokenAsync(string refreshToken);
    Task<bool> LogoutAsync(string refreshToken);
    Task RequestPasswordResetAsync(string email);
    Task<bool> ResetPasswordAsync(string email, string code, string newPassword);
    Task<AuthResponseDto?> AuthenticateGoogleAsync(string idToken);
    Task<AuthResponseDto?> AuthenticateFacebookAsync(string accessToken);
}

