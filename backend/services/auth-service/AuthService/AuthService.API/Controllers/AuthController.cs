using AuthService.Application.DTOs.Auth.Request;
using AuthService.Application.DTOs.User;
using AuthService.Application.Interfaces;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System.IdentityModel.Tokens.Jwt;

namespace AuthService.API.Controllers;

[ApiController]
[Route("api/[controller]")]
public class AuthController : ControllerBase
{
    private readonly IAuthenticationService _authService;
    private readonly IUserRepository _userRepository;
    
    public AuthController(IAuthenticationService authService, IUserRepository userRepository)
    {
        _authService = authService;
        _userRepository = userRepository;
    }
    
    [HttpPost("register")]
    public async Task<IActionResult> Register([FromBody] UserCreateDto dto)
    {
        try
        { 
            var result = await _authService.RegisterAsync(dto);
            return Ok(new 
            { 
                success = true,
                message = "Registration successful. Please verify your email to complete the process.",
                user = result,
                nextStep = "POST /api/auth/verify-email",
                verificationFlow = new
                {
                    step1 = "POST /api/auth/request-email-verification-code (to get code sent to email)",
                    step2 = "POST /api/auth/verify-email (with email and code to mark as verified)",
                    step3 = "POST /api/auth/authenticate (to login after verification)"
                }
            });
        }
        catch (Exception ex)
        {
            return BadRequest(new 
            { 
                success = false,
                error = ex.Message,
                code = "REGISTRATION_FAILED"
            });
        }
    }

    [HttpPost("authenticate")]
    public async Task<IActionResult> Authenticate([FromBody] LoginRequestDto dto)
    {
        var result = await _authService.AuthenticateAsync(dto.Email, dto.Password);
        if (result != null)
            return Ok(result);

        // Authentication failed - check if it's due to unverified email
        var user = await _userRepository.GetByEmailAsync(dto.Email.Trim().ToUpperInvariant());
        if (user != null && !user.IsEmailVerified)
        {
            return Unauthorized(new 
            { 
                error = "Email not verified",
                message = "Please verify your email before logging in",
                code = "EMAIL_NOT_VERIFIED",
                //nextStep = "POST /api/auth/request-email-verification-code"
            });
        }

        // Generic error for wrong password or user not found
        return Unauthorized(new 
        { 
            error = "Invalid email or password",
            code = "INVALID_CREDENTIALS"
        });
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
        return Ok(new 
        { 
            success = true,
            message = "Verification code sent to your email",
            email = dto.Email,
            nextStep = "POST /api/auth/verify-email",
            instructions = "Check your inbox for the verification code and submit it along with your email"
        });
    }

    [HttpPost("verify-email")]
    public async Task<IActionResult> VerifyEmail([FromBody] VerifyEmailRequestDto dto)
    {
        var verified = await _authService.VerifyEmailAsync(dto.Email, dto.Code);
        if (!verified)
        {
            return BadRequest(new 
            { 
                error = "Email verification failed",
                message = "Invalid verification code or email",
                code = "VERIFICATION_FAILED"
            });
        }
        
        return Ok(new 
        { 
            success = true,
            message = "Email verified successfully",
            email = dto.Email,
            nextStep = "POST /api/auth/authenticate",
            instructions = "You can now login with your email and password"
        });
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

/// <summary>
/// Validates JWT token - for use by other microservices
/// </summary>
[HttpPost("validate")]
[AllowAnonymous]
public IActionResult ValidateToken([FromBody] ValidateTokenRequest request)
{
    if (string.IsNullOrEmpty(request?.Token))
        return BadRequest(new { valid = false, error = "Token is required" });

    try
    {
        var handler = new JwtSecurityTokenHandler();
        var token = handler.ReadJwtToken(request.Token);
        
        // Check if token is not expired
        if (token.ValidTo < DateTime.UtcNow)
            return Ok(new { valid = false, error = "Token has expired" });

        // If we got here, token is structurally valid and not expired
        return Ok(new { 
            valid = true, 
            userId = token.Subject,
            email = token.Claims.FirstOrDefault(c => c.Type == "email")?.Value
        });
    }
    catch (Exception ex)
    {
        return Ok(new { valid = false, error = ex.Message });
    }
}

/// <summary>
/// Get user info by ID - for use by other microservices
/// Can be called anonymously or with token
/// </summary>
[HttpGet("user/{userId}")]
[AllowAnonymous]
public async Task<IActionResult> GetUser(string userId)
{
    if (string.IsNullOrEmpty(userId))
        return BadRequest(new { error = "UserId is required" });

    try
    {
        var user = await _userRepository.GetByIdAsync(Guid.Parse(userId));
        
        if (user == null)
            return NotFound(new { error = "User not found" });

        return Ok(new
        {
            userId = user.Id,
            username = user.Username,
            email = user.Email,
            fullName = user.Username,
            role = user.Role,
            isActive = user.IsActive,
            isEmailVerified = user.IsEmailVerified,
            createdAt = user.CreatedAt
        });
    }
    catch (Exception ex)
    {
        return BadRequest(new { error = ex.Message });
    }
}
}

public class ValidateTokenRequest
{
    public string? Token { get; set; }
}