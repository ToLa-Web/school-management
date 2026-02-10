using AuthService.Application.DTOs.Auth.Response;
using AuthService.Application.DTOs.User;
using AuthService.Application.Interfaces;
using AuthService.Domain.Entities;
using AuthService.Domain.Enums;
using Microsoft.Extensions.Configuration;
using System.Security.Cryptography;
using System.Text;
 using System.ComponentModel.DataAnnotations;

namespace AuthService.Application.Services;

public class AuthenticationService : IAuthenticationService
{
    private readonly IUserRepository _userRepo;
    private readonly IPasswordHasher _passwordHasher;
    private readonly ITokenService _tokenService;
    private readonly IEmailSender _emailSender;
    private readonly string _emailVerificationPepper;
    private readonly string _passwordResetPepper;
    private readonly IExternalAuthValidator _externalAuthValidator;

    public AuthenticationService(
        IUserRepository userRepo,
        IPasswordHasher passwordHasher,
        ITokenService tokenService,
        IEmailSender emailSender,
        IConfiguration configuration,
        IExternalAuthValidator externalAuthValidator)
    {
        _userRepo = userRepo;
        _passwordHasher = passwordHasher;
        _tokenService = tokenService;
        _emailSender = emailSender;
        _externalAuthValidator = externalAuthValidator;

        _emailVerificationPepper =
            configuration["EmailVerification:Pepper"]
            ?? configuration["Jwt:Secret"]
            ?? throw new InvalidOperationException("EmailVerification:Pepper (or Jwt:Secret) is not configured");

        _passwordResetPepper =
            configuration["PasswordReset:Pepper"]
            ?? configuration["EmailVerification:Pepper"]
            ?? configuration["Jwt:Secret"]
            ?? throw new InvalidOperationException("PasswordReset:Pepper (or EmailVerification:Pepper / Jwt:Secret) is not configured");
    }

    public async Task RequestEmailVerificationCodeAsync(string email)
    {
        if (string.IsNullOrWhiteSpace(email))
            return;

        email = email.Trim();
        if (!new EmailAddressAttribute().IsValid(email))
            return;

        var normalizedEmail = email.ToUpperInvariant();
        var user = await _userRepo.GetByEmailAsync(normalizedEmail);

        // Avoid leaking whether an email exists
        if (user == null)
            return;

        if (user.IsEmailVerified)
            return;

        var now = DateTime.UtcNow;

        // Simple resend cooldown
        if (user.EmailVerificationCodeSentAt.HasValue && (now - user.EmailVerificationCodeSentAt.Value) < TimeSpan.FromSeconds(60))
            return;

        var code = RandomNumberGenerator.GetInt32(0, 1_000_000).ToString("D6");
        var codeHash = HashEmailVerificationCode(normalizedEmail, code);

        user.SetEmailVerificationCode(
            codeHash,
            expiresAt: now.AddMinutes(10),
            sentAt: now);

        await _userRepo.UpdateAsync(user);

        var subject = "Your verification code";
        var body = $@"<h2>Email verification</h2>
                    <p>Your verification code is:</p>
                    <p style='font-size:24px;letter-spacing:3px;'><strong>{code}</strong></p>
                    <p>This code expires in 10 minutes.</p>";

        try
        {
            await _emailSender.SendEmailAsync(email, subject, body);
        }
        catch
        {
            // If email sending fails, clear the stored code so the user can request again immediately.
            user.ClearEmailVerificationCode();
            await _userRepo.UpdateAsync(user);
            throw;
        }
    }

    public async Task<bool> VerifyEmailAsync(string email, string code)
    {
        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(code))
            return false;

        var normalizedEmail = email.Trim().ToUpperInvariant();
        var user = await _userRepo.GetByEmailAsync(normalizedEmail);
        if (user == null)
            return false;

        if (user.IsEmailVerified)
            return true;

        var now = DateTime.UtcNow;
        if (user.EmailVerificationLockoutUntil.HasValue && user.EmailVerificationLockoutUntil.Value > now)
            return false;

        if (user.EmailVerificationCodeHash == null || !user.EmailVerificationCodeExpiresAt.HasValue)
            return false;

        if (now >= user.EmailVerificationCodeExpiresAt.Value)
            return false;

        var trimmedCode = code.Trim();
        if (trimmedCode.Length != 6 || trimmedCode.Any(ch => ch < '0' || ch > '9'))
            return false;

        var attemptedHash = HashEmailVerificationCode(normalizedEmail, trimmedCode);
        var isValid = FixedTimeEquals(user.EmailVerificationCodeHash, attemptedHash);

        if (!isValid)
        {
            user.RecordFailedEmailVerificationAttempt(maxAttempts: 5, lockoutDuration: TimeSpan.FromMinutes(15));
            await _userRepo.UpdateAsync(user);
            return false;
        }

        user.VerifyEmail();
        user.ClearEmailVerificationCode();
        await _userRepo.UpdateAsync(user);
        return true;
    }

    private string HashEmailVerificationCode(string normalizedEmail, string code)
    {
        var payload = $"{normalizedEmail}:{code}";
        using var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(_emailVerificationPepper));
        var bytes = hmac.ComputeHash(Encoding.UTF8.GetBytes(payload));
        return Convert.ToBase64String(bytes);
    }

    private string HashPasswordResetCode(string normalizedEmail, string code)
    {
        var payload = $"{normalizedEmail}:{code}";
        using var hmac = new HMACSHA256(Encoding.UTF8.GetBytes(_passwordResetPepper));
        var bytes = hmac.ComputeHash(Encoding.UTF8.GetBytes(payload));
        return Convert.ToBase64String(bytes);
    }

    private static bool FixedTimeEquals(string a, string b)
    {
        var aBytes = Encoding.UTF8.GetBytes(a);
        var bBytes = Encoding.UTF8.GetBytes(b);
        return CryptographicOperations.FixedTimeEquals(aBytes, bBytes);
    }

    public async Task<UserResponseDto> RegisterAsync(UserCreateDto dto)
    {
        var email = dto.Email.Trim();
        var username = dto.Username.Trim();

        // Check email
        if (await _userRepo.EmailExistsAsync(email.ToUpperInvariant()))
            throw new Exception("Email already registered");

        // Create user domain entity
        var user = new User(email, username, UserRole.Student);

        // Hash password
        var hash = _passwordHasher.HashPassword(user, dto.Password);
        user.SetPasswordHash(hash);

        // Save user
        await _userRepo.AddAsync(user);

        // Send verification code email after registration
        await RequestEmailVerificationCodeAsync(user.Email);

        return new UserResponseDto
        {
            Id = user.Id,
            Email = user.Email,
            Username = user.Username,
            Role = user.Role,
            UserRole = user.Role.ToString(),
            IsEmailVerified = user.IsEmailVerified
        };
    }

    public async Task<AuthResponseDto?> AuthenticateAsync(string email, string password)
    {
        // Find user by email
        var user = await _userRepo.GetByEmailAsync(email.Trim().ToUpperInvariant());
        if (user == null)
            return null;

        // Verify password
        if (!_passwordHasher.VerifyPassword(user, user.PasswordHash!, password))
            return null;

        // Check if user is active
        if (!user.IsActive)
            return null;

        // Generate tokens
        var accessToken = _tokenService.GenerateAccessToken(user);
        var refreshToken = _tokenService.GenerateRefreshToken();
        var refreshTokenExpiration = _tokenService.GetRefreshTokenExpiration();

        // Store refresh token
        user.AddRefreshToken(refreshToken, refreshTokenExpiration);
        user.RecordLogin();
        await _userRepo.UpdateAsync(user);

        return new AuthResponseDto
        {
            UserId = user.Id,
            Username = user.Username,
            Email = user.Email,
            Role = user.Role,
            UserRole = user.Role.ToString(),
            IsActive = user.IsActive,
            IsEmailVerified = user.IsEmailVerified,
            Token = accessToken,
            RefreshToken = refreshToken,
            LastLoginAt = user.LastLoginAt
        };
    }

    public async Task<AuthResponseDto?> RefreshTokenAsync(string refreshToken)
    {
        if (string.IsNullOrWhiteSpace(refreshToken))
            return null;

        var user = await _userRepo.GetByRefreshTokenAsync(refreshToken);
        if (user == null)
            return null;

        if (!user.IsActive)
            return null;

        var existingRefreshToken = user.RefreshTokens.FirstOrDefault(rt => rt.Token == refreshToken);
        if (existingRefreshToken == null || !existingRefreshToken.IsActive)
            return null;

        // Rotate refresh token
        existingRefreshToken.Revoke();
        var newRefreshToken = _tokenService.GenerateRefreshToken();
        var refreshTokenExpiration = _tokenService.GetRefreshTokenExpiration();
        user.AddRefreshToken(newRefreshToken, refreshTokenExpiration);

        // Issue new access token
        var accessToken = _tokenService.GenerateAccessToken(user);

        await _userRepo.UpdateAsync(user);

        return new AuthResponseDto
        {
            UserId = user.Id,
            Username = user.Username,
            Email = user.Email,
            Role = user.Role,
            UserRole = user.Role.ToString(),
            IsActive = user.IsActive,
            IsEmailVerified = user.IsEmailVerified,
            Token = accessToken,
            RefreshToken = newRefreshToken,
            LastLoginAt = user.LastLoginAt
        };
    }

    public async Task RequestPasswordResetAsync(string email)
    {
        if (string.IsNullOrWhiteSpace(email))
            return;

        email = email.Trim();
        if (!new EmailAddressAttribute().IsValid(email))
            return;

        var normalizedEmail = email.ToUpperInvariant();
        var user = await _userRepo.GetByEmailAsync(normalizedEmail);

        // Avoid leaking whether an email exists
        if (user == null)
            return;

        if (!user.IsActive)
            return;

        var now = DateTime.UtcNow;
        if (user.PasswordResetLockoutUntil.HasValue && user.PasswordResetLockoutUntil.Value > now)
            return;

        // Simple resend cooldown
        if (user.PasswordResetCodeSentAt.HasValue && (now - user.PasswordResetCodeSentAt.Value) < TimeSpan.FromSeconds(60))
            return;

        var code = RandomNumberGenerator.GetInt32(0, 1_000_000).ToString("D6");
        var codeHash = HashPasswordResetCode(normalizedEmail, code);

        user.SetPasswordResetCode(
            codeHash,
            expiresAt: now.AddMinutes(10),
            sentAt: now);

        await _userRepo.UpdateAsync(user);

        var subject = "Your password reset code";
        var body = $@"<h2>Password reset</h2>
                    <p>Your password reset code is:</p>
                    <p style='font-size:24px;letter-spacing:3px;'><strong>{code}</strong></p>
                    <p>This code expires in 10 minutes.</p>";

        try
        {
            await _emailSender.SendEmailAsync(email, subject, body);
        }
        catch
        {
            // If email sending fails, clear the stored code so the user can request again immediately.
            user.ClearPasswordResetCode();
            await _userRepo.UpdateAsync(user);
            throw;
        }
    }

    public async Task<bool> ResetPasswordAsync(string email, string code, string newPassword)
    {
        if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(code) || string.IsNullOrWhiteSpace(newPassword))
            return false;

        var normalizedEmail = email.Trim().ToUpperInvariant();
        var user = await _userRepo.GetByEmailAsync(normalizedEmail);
        if (user == null)
            return false;

        if (!user.IsActive)
            return false;

        var now = DateTime.UtcNow;
        if (user.PasswordResetLockoutUntil.HasValue && user.PasswordResetLockoutUntil.Value > now)
            return false;

        if (user.PasswordResetCodeHash == null || !user.PasswordResetCodeExpiresAt.HasValue)
            return false;

        if (now >= user.PasswordResetCodeExpiresAt.Value)
            return false;

        var trimmedCode = code.Trim();
        if (trimmedCode.Length != 6 || trimmedCode.Any(ch => ch < '0' || ch > '9'))
            return false;

        var attemptedHash = HashPasswordResetCode(normalizedEmail, trimmedCode);
        var isValid = FixedTimeEquals(user.PasswordResetCodeHash, attemptedHash);

        if (!isValid)
        {
            user.RecordFailedPasswordResetAttempt(maxAttempts: 5, lockoutDuration: TimeSpan.FromMinutes(15));
            await _userRepo.UpdateAsync(user);
            return false;
        }

        var newHash = _passwordHasher.HashPassword(user, newPassword);
        user.SetPasswordHash(newHash);

        // Invalidate existing refresh tokens so all sessions are logged out.
        foreach (var refreshToken in user.RefreshTokens)
            refreshToken.Revoke();

        user.ClearPasswordResetCode();
        await _userRepo.UpdateAsync(user);
        return true;
    }

    public async Task<bool> LogoutAsync(string refreshToken)
    {
        if (string.IsNullOrWhiteSpace(refreshToken))
            return false;

        var user = await _userRepo.GetByRefreshTokenAsync(refreshToken);
        if (user == null)
            return false;

        var existingRefreshToken = user.RefreshTokens.FirstOrDefault(rt => rt.Token == refreshToken);
        if (existingRefreshToken == null)
            return false;

        // If it's already inactive (expired/revoked), treat as logged out.
        if (!existingRefreshToken.IsActive)
            return true;

        existingRefreshToken.Revoke();
        await _userRepo.UpdateAsync(user);
        return true;
    }

    public async Task<AuthResponseDto?> AuthenticateGoogleAsync(string idToken)
{
    var identity = await _externalAuthValidator.ValidateGoogleIdTokenAsync(idToken);
    return await AuthenticateExternalAsync(identity);
}

public async Task<AuthResponseDto?> AuthenticateFacebookAsync(string accessToken)
{
    var identity = await _externalAuthValidator.ValidateFacebookAccessTokenAsync(accessToken);
    return await AuthenticateExternalAsync(identity);
}

private async Task<AuthResponseDto?> AuthenticateExternalAsync(ExternalAuthIdentity identity)
{
    // 1) Find by external login link
    var user = await _userRepo.GetByExternalLoginAsync(identity.Provider, identity.ProviderUserId);

    // 2) If not found, try link by email only for Google and only when Google asserts it's verified.
    // (For Facebook, we'll avoid email-linking until debug_token verification is implemented.)
    if (user == null
        && identity.Provider == ExternalAuthProvider.Google
        && identity.EmailVerified
        && !string.IsNullOrWhiteSpace(identity.Email))
        user = await _userRepo.GetByEmailAsync(identity.Email.Trim().ToUpperInvariant());

    // 3) If still not found, create a new user (OAuth-only)
    if (user == null)
    {
        if (string.IsNullOrWhiteSpace(identity.Email))
            return null; // simplest: require email

        var email = identity.Email.Trim();
        var username = (identity.DisplayName ?? email.Split('@')[0]).Trim();

        user = new User(email, username, UserRole.Student);

        if (identity.EmailVerified)
            user.VerifyEmail();

        user.AddExternalLogin(identity.Provider, identity.ProviderUserId);
        await _userRepo.AddAsync(user);
    }
    else
    {
        // Ensure link exists (avoid duplicates / unique index violations)
        if (!user.ExternalLogins.Any(el => el.Provider == identity.Provider && el.ProviderUserId == identity.ProviderUserId))
            user.AddExternalLogin(identity.Provider, identity.ProviderUserId);
        await _userRepo.UpdateAsync(user);
    }

    if (!user.IsActive)
        return null;

    // Issue your normal tokens (same logic as password login)
    var accessToken = _tokenService.GenerateAccessToken(user);
    var refreshToken = _tokenService.GenerateRefreshToken();
    var refreshTokenExpiration = _tokenService.GetRefreshTokenExpiration();

    user.AddRefreshToken(refreshToken, refreshTokenExpiration);
    user.RecordLogin();
    await _userRepo.UpdateAsync(user);

    return new AuthResponseDto
    {
        UserId = user.Id,
        Username = user.Username,
        Email = user.Email,
        Role = user.Role,
        UserRole = user.Role.ToString(),
        IsActive = user.IsActive,
        IsEmailVerified = user.IsEmailVerified,
        Token = accessToken,
        RefreshToken = refreshToken,
        LastLoginAt = user.LastLoginAt
    };
}
}