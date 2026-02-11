using AuthService.Application.Interfaces;
using AuthService.Domain.Entities;
using AuthService.Domain.Enums;
using AuthService.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace AuthService.Infrastructure.Repositories;

public class UserRepository(AuthDbContext context) : IUserRepository
{
    public async Task<User> AddAsync(User user)
    {
        context.Users.Add(user);
        await context.SaveChangesAsync();
        return user;
    }
    
    public async Task<bool> EmailExistsAsync(string normalizedEmail)
        => await context.Users.AnyAsync(u => u.NormalizedEmail == normalizedEmail);
    
    public async Task<User?> GetByIdAsync(Guid id)
        => await context.Users.FindAsync(id);

    public async Task<User?> GetByEmailAsync(string normalizedEmail)
        => await context.Users
            .Include(u => u.RefreshTokens)
            .Include(u => u.ExternalLogins)
            .FirstOrDefaultAsync(u => u.NormalizedEmail == normalizedEmail);

    public async Task<User?> GetByRefreshTokenAsync(string refreshToken)
        => await context.Users
            .Include(u => u.RefreshTokens)
            .FirstOrDefaultAsync(u => u.RefreshTokens.Any(rt => rt.Token == refreshToken));

    public async Task UpdateAsync(User user)
    {
        await context.SaveChangesAsync();
    }

    public async Task<User?> GetByExternalLoginAsync(ExternalAuthProvider provider, string providerUserId)
        => await context.Users
            .Include(u => u.RefreshTokens)
            .Include(u => u.ExternalLogins)
            .FirstOrDefaultAsync(u => u.ExternalLogins.Any(el =>
                el.Provider == provider &&
                el.ProviderUserId == providerUserId));
}