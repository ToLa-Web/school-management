using AuthService.Application.Interfaces;
using AuthService.Domain.Entities;
using AuthService.Domain.Enums;
using AuthService.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace AuthService.Infrastructure.Seed;

public class DataSeeder
{
    private readonly AuthDbContext _context;
    private readonly IPasswordHasher _passwordHasher;

    public DataSeeder(AuthDbContext context, IPasswordHasher passwordHasher)
    {
        _context = context;
        _passwordHasher = passwordHasher;
    }

    public async Task SeedDataAsync()
    {
        // Check if users already exist
        if (await _context.Users.AnyAsync())
        {
            return; // Data already seeded
        }

        var users = new List<User>
        {
            // Admin
            CreateUser("admin@school.com", "admin", UserRole.Admin),

            // Teachers
            CreateUser("teacher1@school.com", "teacher_john",  UserRole.Teacher),
            CreateUser("teacher2@school.com", "teacher_sarah", UserRole.Teacher),
            CreateUser("teacher3@school.com", "teacher_mike",  UserRole.Teacher),

            // Parents
            CreateUser("parent1@school.com", "parent_john", UserRole.Parent),
            CreateUser("parent2@school.com", "parent_jane", UserRole.Parent),
        };

        // Students: student1@school.com … student45@school.com
        for (int i = 1; i <= 45; i++)
            users.Add(CreateUser($"student{i}@school.com", $"student{i}", UserRole.Student));

        // Set all emails as verified for demo purposes
        foreach (var user in users)
        {
            user.VerifyEmail();
        }

        await _context.Users.AddRangeAsync(users);
        await _context.SaveChangesAsync();
    }

    private User CreateUser(string email, string username, UserRole role)
    {
        var user = new User(email, username, role);
        var defaultPassword = "Password123!"; // Default password for all seed users
        var hashedPassword = _passwordHasher.HashPassword(user, defaultPassword);
        
        // Set password hash through reflection since it's a private setter
        var passwordHashProperty = typeof(User).GetProperty("PasswordHash");
        passwordHashProperty?.SetValue(user, hashedPassword);

        return user;
    }
}