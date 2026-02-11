using AuthService.Domain.Entities.Common;
using AuthService.Domain.Enums;

namespace AuthService.Domain.Entities;

public class ExternalLogin : BaseEntity
{
    public Guid UserId { get; private set; }
    public ExternalAuthProvider Provider { get; private set; }
    public string ProviderUserId { get; private set; } = string.Empty;

    protected ExternalLogin() { } // EF

    public ExternalLogin(Guid userId, ExternalAuthProvider provider, string providerUserId)
    {
        UserId = userId;
        Provider = provider;
        ProviderUserId = providerUserId;
    }
}