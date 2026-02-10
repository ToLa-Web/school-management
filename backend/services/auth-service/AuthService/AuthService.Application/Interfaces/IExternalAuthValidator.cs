using AuthService.Domain.Enums;

namespace AuthService.Application.Interfaces;

public record ExternalAuthIdentity(
    ExternalAuthProvider Provider,
    string ProviderUserId,
    string? Email,
    bool EmailVerified,
    string? DisplayName
);

public interface IExternalAuthValidator
{
    Task<ExternalAuthIdentity> ValidateGoogleIdTokenAsync(string idToken);
    Task<ExternalAuthIdentity> ValidateFacebookAccessTokenAsync(string accessToken);
}