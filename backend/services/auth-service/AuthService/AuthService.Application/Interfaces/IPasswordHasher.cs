using AuthService.Domain.Entities;

namespace AuthService.Application.Interfaces;

public interface IPasswordHasher
{
    // Hashes the provided password for the given user.
    string HashPassword(User user, string password);
    // Verifies that the provided password matches the hashed password.
    bool VerifyPassword(User user, string hashedPassword, string providedPassword);
}
