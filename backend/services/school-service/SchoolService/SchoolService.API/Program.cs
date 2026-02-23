using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using SchoolService.Application.Interfaces;
using SchoolService.Application.Services;
using SchoolService.Infrastructure.Data;
using SchoolService.Infrastructure.Repositories;
using SchoolService.Infrastructure.Seed;
using SchoolService.API.Services;
using System.Text;
using Consul;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
    options.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
    {
        Name = "Authorization",
        Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        Description = "JWT Authorization header using Bearer token (e.g., 'Bearer eyJhbGci...')"
    });
    options.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
    {
        {
            new Microsoft.OpenApi.Models.OpenApiSecurityScheme
            {
                Reference = new Microsoft.OpenApi.Models.OpenApiReference
                {
                    Type = Microsoft.OpenApi.Models.ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] { }
        }
    });
});

// CORS - allow Flutter / gateway during development
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader());
});

// Register Consul client factory
builder.Services.AddSingleton<IConsulClient, ConsulClient>(sp => new ConsulClient(cfg =>
{
    var consulHost = builder.Configuration["consul:host"] ?? "localhost";
    var consulPort = int.TryParse(builder.Configuration["consul:port"], out var p) ? p : 8500;
    cfg.Address = new Uri($"http://{consulHost}:{consulPort}");
}));

// DbContext - Postgres
builder.Services.AddDbContext<SchoolDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("SchoolDb")));

// 🆕 ADD THIS: Register AuthServiceClient for service-to-service communication
builder.Services.AddHttpClient<IAuthServiceClient, AuthServiceClient>();

// Application / infrastructure services
builder.Services.AddScoped<IStudentRepository, StudentRepository>();
builder.Services.AddScoped<IStudentService, StudentService>();
builder.Services.AddScoped<ITeacherRepository, TeacherRepository>();
builder.Services.AddScoped<ITeacherService, TeacherService>();
builder.Services.AddScoped<IClassroomRepository, ClassroomRepository>();
builder.Services.AddScoped<IClassroomService, ClassroomService>();
builder.Services.AddScoped<DataSeeder>();

// JWT authentication (validate tokens issued by AuthService)
var jwtSection = builder.Configuration.GetSection("Jwt");
var jwtSecret = (!string.IsNullOrEmpty(jwtSection["Secret"]) ? jwtSection["Secret"] : null) 
             ?? (!string.IsNullOrEmpty(builder.Configuration["Jwt__Secret"]) ? builder.Configuration["Jwt__Secret"] : null)
             ?? (!string.IsNullOrEmpty(Environment.GetEnvironmentVariable("JWT_SECRET")) ? Environment.GetEnvironmentVariable("JWT_SECRET") : null)
             ?? "your-secret-key-change-me-in-production-this-is-insecure";
var key = Encoding.UTF8.GetBytes(jwtSecret);

builder.Services.AddAuthentication(options =>
{
    options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(options =>
{
    options.RequireHttpsMetadata = false;
    options.SaveToken = true;
    options.TokenValidationParameters = new TokenValidationParameters
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(key),
        ValidateIssuer = true,
        ValidIssuer = jwtSection["Issuer"],
        ValidateAudience = true,
        ValidAudience = jwtSection["Audience"],
        ValidateLifetime = true,
        ClockSkew = TimeSpan.FromMinutes(1)
    };
});

var app = builder.Build();

// Ensure database exists + seed (simple dev experience)
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<SchoolDbContext>();

    // Retry loop: wait for Postgres to be reachable before calling EnsureCreated
    var dbMaxAttempts = 10;
    var dbDelay = TimeSpan.FromSeconds(2);
    for (int attempt = 1; attempt <= dbMaxAttempts; attempt++)
    {
        try
        {
            // Try opening a connection to verify the DB is reachable
            var connection = db.Database.GetDbConnection();
            await connection.OpenAsync();
            await connection.CloseAsync();

            // If we reached here, DB is reachable — ensure database and run seeder
            db.Database.EnsureCreated();

            var seeder = scope.ServiceProvider.GetRequiredService<DataSeeder>();
            await seeder.SeedDataAsync();

            Console.WriteLine("Database is ready and seeded.");
            break;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Attempt {attempt} to connect/initialize DB failed: {ex.Message}");
            if (attempt == dbMaxAttempts)
            {
                Console.WriteLine("Max attempts reached while trying to connect to DB — rethrowing exception.");
                throw;
            }

            await Task.Delay(dbDelay);
            dbDelay = TimeSpan.FromSeconds(dbDelay.TotalSeconds * 2);
        }
    }
}

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

// app.UseHttpsRedirection();

app.UseCors("AllowAll");

// Health endpoint for compose/consul checks - MUST be before authentication
app.MapGet("/health", () => Results.Ok(new { status = "ok", service = "school-service" }))
   .AllowAnonymous();

app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

// Register with Consul on startup
// Run in background so startup doesn't block
_ = Task.Run(async () =>
{
    var consulClient = app.Services.GetRequiredService<IConsulClient>();
    var registration = new AgentServiceRegistration()
    {
        ID = "school-service-" + Guid.NewGuid().ToString(),
        Name = builder.Configuration["spring:application:name"] ?? "school-service",
        Address = "school-service",
        Port = 8080,
        Tags = new[] { "school", "api" },
        Check = new AgentServiceCheck
        {
            HTTP = $"http://school-service:8080/health",
            Interval = TimeSpan.FromSeconds(10),
            DeregisterCriticalServiceAfter = TimeSpan.FromMinutes(1)
        }
    };

    var maxAttempts = 10;
    var delay = TimeSpan.FromSeconds(3);
    for (int attempt = 1; attempt <= maxAttempts; attempt++)
    {
        try
        {
            await consulClient.Agent.ServiceRegister(registration);
            Console.WriteLine("✅ SchoolService registered with Consul");

            // Deregister on shutdown
            app.Lifetime.ApplicationStopping.Register(async () =>
            {
                try
                {
                    await consulClient.Agent.ServiceDeregister(registration.ID);
                    Console.WriteLine("✅ SchoolService deregistered from Consul");
                }
                catch (Exception ex)
                {
                    Console.WriteLine($"⚠️  Failed to deregister from Consul: {ex.Message}");
                }
            });
            break;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"⚠️  Attempt {attempt} to register with Consul failed: {ex.Message}");
            if (attempt == maxAttempts)
            {
                Console.WriteLine("⚠️  Failed to register with Consul after max attempts - continuing anyway");
                break;
            }
            await Task.Delay(delay);
        }
    }
});

// Use Steeltoe discovery middleware
// app.UseDiscoveryClient();

app.Run();

