﻿using AuthService.Domain.Entities;
using AuthService.Domain.Enums;

namespace AuthService.Application.Interfaces;

public interface IUserRepository
{
    Task<User?> GetByIdAsync(Guid id);
    Task<bool> EmailExistsAsync(string normalizedEmail);
    Task<User?> GetByEmailAsync(string normalizedEmail);
    Task<User?> GetByRefreshTokenAsync(string refreshToken);
    //Task<User?> GetByUsernameAsync(string username);
    Task<User> AddAsync(User user);
    Task UpdateAsync(User user);
    Task<User?> GetByExternalLoginAsync(ExternalAuthProvider provider, string providerUserId);
    Task<IEnumerable<User>> GetAllAsync();
    Task<bool> DeleteAsync(Guid userId);
    Task<bool> UpdateRoleAsync(Guid userId, UserRole newRole);
}