using AuthService.Application.DTOs.Auth.Request;
using AuthService.Application.DTOs.User;
using AuthService.Application.Interfaces;
using Microsoft.AspNetCore.Mvc;

namespace AuthService.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthenticationService _authService;
    
    public AuthController(IAuthenticationService authService)
    {
        _authService = authService;
    }
    
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] UserCreateDto dto)
    {
        var result = await _authService.RegisterAsync(dto);
        return Ok(result);
    }

    [HttpPost("authenticate")]
    public async Task<IActionResult> Authenticate([FromBody] LoginRequestDto dto)
    {
        var result = await _authService.AuthenticateAsync(dto.Email, dto.Password);
        return Ok(result);
    }

    [HttpPost("refresh")]
    public async Task<IActionResult> Refresh([FromBody] RefreshTokenRequestDto dto)
    {
        var result = await _authService.RefreshTokenAsync(dto.RefreshToken);
        return Ok(result);
    }

    [HttpPost("logout")]
    public async Task<IActionResult> Logout([FromBody] LogoutRequestDto dto)
    {
        var loggedOut = await _authService.LogoutAsync(dto.RefreshToken);
        return Ok(loggedOut);
    }

    [HttpPost("request-email-verification-code")]
    public async Task<IActionResult> RequestEmailVerificationCode([FromBody] RequestEmailVerificationCodeRequestDto dto)
    {
        await _authService.RequestEmailVerificationCodeAsync(dto.Email);
        return Ok();
    }

    [HttpPost("verify-email")]
    public async Task<IActionResult> VerifyEmail([FromBody] VerifyEmailRequestDto dto)
    {
        var verified = await _authService.VerifyEmailAsync(dto.Email, dto.Code);
        return Ok(verified);
    }

    [HttpPost("request-password-reset")]
    public async Task<IActionResult> RequestPasswordReset([FromBody] RequestPasswordResetRequestDto dto)
    {
        await _authService.RequestPasswordResetAsync(dto.Email);
        return Ok();
    }

    [HttpPost("reset-password")]
    public async Task<IActionResult> ResetPassword([FromBody] ResetPasswordRequestDto dto)
    {
        var reset = await _authService.ResetPasswordAsync(dto.Email, dto.Code, dto.NewPassword);
        return Ok(reset);
    }

    [HttpPost("oauth/google")]
public async Task<IActionResult> OAuthGoogle([FromBody] GoogleAuthRequestDto dto)
{
    var result = await _authService.AuthenticateGoogleAsync(dto.IdToken);
    return result == null ? Unauthorized() : Ok(result);
}

[HttpPost("oauth/facebook")]
public async Task<IActionResult> OAuthFacebook([FromBody] FacebookAuthRequestDto dto)
{
    var result = await _authService.AuthenticateFacebookAsync(dto.AccessToken);
    return result == null ? Unauthorized() : Ok(result);
}
}