using AuthService.Application.DTOs.Auth.Request;
using AuthService.Application.DTOs.User;
using AuthService.Application.Interfaces;
using AuthService.Domain.Enums;
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
        if (string.IsNullOrWhiteSpace(dto.RefreshToken))
            return BadRequest(new { success = false, message = "Refresh token is required" });

        var result = await _authService.RefreshTokenAsync(dto.RefreshToken);
        
        if (result == null)
            return Unauthorized(new { success = false, message = "Invalid or expired refresh token" });
        
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

    [HttpPost("change-password")]
    public async Task<IActionResult> ChangePassword([FromBody] ChangePasswordRequestDto dto)
    {
        var changed = await _authService.ChangePasswordAsync(dto.UserId, dto.CurrentPassword, dto.NewPassword);
        if (!changed)
            return BadRequest(new { success = false, error = "Current password is incorrect or the account is unavailable." });

        return Ok(new { success = true, message = "Password changed successfully." });
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

// Validates a JWT token - mainly called by other services like school-service
[HttpPost("validate")]
public IActionResult ValidateToken([FromBody] ValidateTokenRequest request)
{
    if (string.IsNullOrEmpty(request?.Token))
        return BadRequest(new { valid = false, error = "Token is required" });

    try
    {
        // Split the JWT and decode the payload manually
        var parts = request.Token.Split('.');
        if (parts.Length != 3)
            return Ok(new { valid = false, error = "Invalid token format" });
        
        // Decode payload (add padding if necessary)
        var payload = parts[1];
        var padding = 4 - payload.Length % 4;
        if (padding < 4)
            payload += new string('=', padding);
        
        var jsonBytes = Convert.FromBase64String(payload);
        var json = System.Text.Encoding.UTF8.GetString(jsonBytes);
        
        // Parse the JSON to get exp
        using var doc = System.Text.Json.JsonDocument.Parse(json);
        var root = doc.RootElement;
        
        if (!root.TryGetProperty("exp", out var expElement))
            return Ok(new { valid = false, error = "Token has no expiration claim", json = json });
        
        var expEpoch = expElement.GetInt64();
        var expirationUtc = DateTimeOffset.FromUnixTimeSeconds(expEpoch).UtcDateTime;
        var nowUtc = DateTime.UtcNow;
        
        if (expirationUtc < nowUtc)
            return Ok(new { 
                valid = false, 
                error = "Token has expired",
                expiration = expirationUtc.ToString("o"),
                now = nowUtc.ToString("o")
            });

        // Get sub and email
        var userId = root.TryGetProperty("sub", out var subEl) ? subEl.GetString() : null;
        var email = root.TryGetProperty("email", out var emailEl) ? emailEl.GetString() : null;

        return Ok(new { 
            valid = true, 
            userId,
            email
        });
    }
    catch (Exception ex)
    {
        return Ok(new { valid = false, error = ex.Message });
    }
}

// Returns user info for a given ID - other microservices call this to look up users
[HttpGet("user/{userId}")]
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
// ── Admin endpoints (internal use by admin-web) ──────────────────────────────

    // List all users in auth_db
    [HttpGet("admin/users")]
    public async Task<IActionResult> AdminGetUsers()
    {
        var users = await _authService.GetAllUsersAsync();
        return Ok(users);
    }

    // Create a user account with a specific role
    [HttpPost("admin/users")]
    public async Task<IActionResult> AdminCreateUser([FromBody] AdminCreateUserDto dto)
    {
        try
        {
            var user = await _authService.AdminCreateUserAsync(dto);
            return Ok(new { success = true, user });
        }
        catch (Exception ex)
        {
            return BadRequest(new { success = false, error = ex.Message });
        }
    }

    // Delete a user account from auth_db
    [HttpDelete("admin/users/{userId:guid}")]
    public async Task<IActionResult> AdminDeleteUser(Guid userId)
    {
        try
        {
            await _authService.DeleteUserAsync(userId);
            return NoContent();
        }
        catch (Exception ex)
        {
            return NotFound(new { success = false, error = ex.Message });
        }
    }

    // Update a user's role in auth_db
    [HttpPatch("admin/users/{userId:guid}/role")]
    public async Task<IActionResult> AdminUpdateUserRole(Guid userId, [FromBody] UpdateUserRoleDto dto)
    {
        try
        {
            await _authService.UpdateUserRoleAsync(userId, dto.Role);
            return NoContent();
        }
        catch (Exception ex)
        {
            return NotFound(new { success = false, error = ex.Message });
        }
    }
}

public class ValidateTokenRequest
{
    public string? Token { get; set; }
}
