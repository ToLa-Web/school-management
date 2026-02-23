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
            // Admin users
            CreateUser("admin@school.com", "admin", UserRole.Admin),
            // CreateUser("adminmanager@school.com", "adminmanager", UserRole.Admin),

            // Teacher users
            CreateUser("teacher1@school.com", "teacher_john", UserRole.Teacher),
            CreateUser("teacher2@school.com", "teacher_sarah", UserRole.Teacher),
            // CreateUser("teacher3@school.com", "teacher_mike", UserRole.Teacher),
            // CreateUser("teacher4@school.com", "teacher_emily", UserRole.Teacher),

            // Student users
            CreateUser("student1@school.com", "student_alice", UserRole.Student),
            CreateUser("student2@school.com", "student_bob", UserRole.Student),
            // CreateUser("student3@school.com", "student_charlie", UserRole.Student),
            // CreateUser("student4@school.com", "student_diana", UserRole.Student),
            // CreateUser("student5@school.com", "student_eve", UserRole.Student),
            // CreateUser("student6@school.com", "student_frank", UserRole.Student),

            // Parent users
            CreateUser("parent1@school.com", "parent_john", UserRole.Parent),
            CreateUser("parent2@school.com", "parent_jane", UserRole.Parent),
        };

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