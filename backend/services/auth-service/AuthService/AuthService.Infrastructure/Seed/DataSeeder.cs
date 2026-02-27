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
        if (await _context.Users.AnyAsync()) return;

        var users = new List<User>
        {
            // Admin
            CreateUser("admin@school.com",   "admin",            UserRole.Admin),

            // 5 Teachers — one per subject (Cambodian names, matches SchoolService seed)
            // teacher1 = Sopheak Meas   → Mathematics
            // teacher2 = Dara Chan      → Science
            // teacher3 = Bopha Sok      → English
            // teacher4 = Rithy Phal     → History
            // teacher5 = Sreyla Noun    → Physical Education
            CreateUser("teacher1@school.com", "teacher_sopheak", UserRole.Teacher),
            CreateUser("teacher2@school.com", "teacher_dara",    UserRole.Teacher),
            CreateUser("teacher3@school.com", "teacher_bopha",   UserRole.Teacher),
            CreateUser("teacher4@school.com", "teacher_rithy",   UserRole.Teacher),
            CreateUser("teacher5@school.com", "teacher_sreyla",  UserRole.Teacher),

            // Parents
            CreateUser("parent1@school.com", "parent_sokha",  UserRole.Parent),
            CreateUser("parent2@school.com", "parent_chanta", UserRole.Parent),
        };

        // 47 students total:
        //   Class 10-A → student1  … student15  (15 students)
        //   Class 11-A → student16 … student25  (10 students)
        //   Class 12-A → student26 … student32  ( 7 students)
        //   Class 10-B → student33 … student41  ( 9 students)
        //   Class 12-B → student42 … student47  ( 6 students)
        for (int i = 1; i <= 47; i++)
            users.Add(CreateUser($"student{i}@school.com", $"student{i}", UserRole.Student));

        foreach (var user in users)
            user.VerifyEmail();

        await _context.Users.AddRangeAsync(users);
        await _context.SaveChangesAsync();
    }

    private User CreateUser(string email, string username, UserRole role)
    {
        var user = new User(email, username, role);
        var hashedPassword = _passwordHasher.HashPassword(user, "Password123!");
        typeof(User).GetProperty("PasswordHash")?.SetValue(user, hashedPassword);
        return user;
    }
}