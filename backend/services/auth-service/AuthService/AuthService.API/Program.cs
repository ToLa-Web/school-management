using AuthService.Application.Interfaces;
using AuthService.Application.Services;
using AuthService.Infrastructure.Data;
using AuthService.Infrastructure.Repositories;
using AuthService.Infrastructure.Services;
using AuthService.Infrastructure.Settings;
using AuthService.Infrastructure.Seed;
using Microsoft.EntityFrameworkCore;
using Consul;
using AuthService.API.Middleware;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle

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
builder.Services.AddHttpClient();

// CORS - allow Flutter frontend
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
        policy.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader());
});

// Add DbContext
builder.Services.AddDbContext<AuthDbContext>(options =>
    options.UseNpgsql(builder.Configuration.GetConnectionString("AuthDb")));

builder.Services.AddScoped<IExternalAuthValidator, ExternalAuthValidator>();
builder.Services.AddScoped<IUserRepository, UserRepository>();
builder.Services.AddScoped<IAuthenticationService, AuthenticationService>();
builder.Services.AddScoped<IPasswordHasher, PasswordHasher>();
builder.Services.AddScoped<ITokenService, TokenService>();
builder.Services.AddScoped<DataSeeder>();

builder.Services.Configure<EmailSettings>(builder.Configuration.GetSection("EmailSettings"));
builder.Services.AddTransient<IEmailSender, SmtpEmailSender>();

// Register Consul client factory
builder.Services.AddSingleton<IConsulClient, ConsulClient>(sp => new ConsulClient(cfg =>
{
    var consulHost = builder.Configuration["consul:host"] ?? "localhost";
    var consulPort = int.TryParse(builder.Configuration["consul:port"], out var p) ? p : 8500;
    cfg.Address = new Uri($"http://{consulHost}:{consulPort}");
}));

var app = builder.Build();

// ✅ Add Global Exception Middleware - MUST be early in the pipeline
app.UseMiddleware<GlobalExceptionMiddleware>();

// Auto-migrate database and seed data with retry
using (var scope = app.Services.CreateScope())
{
    var db = scope.ServiceProvider.GetRequiredService<AuthDbContext>();

    // Retry loop: wait for Postgres to be reachable before calling Migrate
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

            // If we reached here, DB is reachable — run migration and seeding
            db.Database.Migrate();

            var seeder = scope.ServiceProvider.GetRequiredService<DataSeeder>();
            await seeder.SeedDataAsync();

            Console.WriteLine("AuthService database migrated and seeded successfully.");
            break;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Attempt {attempt} to connect/migrate DB failed: {ex.Message}");
            if (attempt == dbMaxAttempts)
            {
                Console.WriteLine("Max attempts reached while trying to connect/migrate DB — rethrowing exception.");
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

//app.UseHttpsRedirection();

app.UseCors("AllowAll");

// Health endpoint for compose/consul checks
app.MapGet("/health", () => Results.Ok(new { status = "ok", service = "auth-service" }));

app.MapControllers();

// Register with Consul on startup with retry/backoff
// Run in background so startup doesn't block
_ = Task.Run(async () =>
{
    var consulClient = app.Services.GetRequiredService<IConsulClient>();
    var registration = new AgentServiceRegistration()
    {
        ID = "auth-service-" + Guid.NewGuid().ToString(),
        Name = builder.Configuration["spring:application:name"] ?? "auth-service",
        Address = "auth-service",
        Port = 8080,
        Tags = new[] { "auth", "api" },
        Check = new AgentServiceCheck
        {
            HTTP = $"http://auth-service:8080/health",
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
            Console.WriteLine("✅ AuthService registered with Consul");

            // Deregister on shutdown
            app.Lifetime.ApplicationStopping.Register(async () =>
            {
                try
                {
                    await consulClient.Agent.ServiceDeregister(registration.ID);
                    Console.WriteLine("✅ AuthService deregistered from Consul");
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

app.Run();

record WeatherForecast(DateOnly Date, int TemperatureC, string? Summary)
{
    public int TemperatureF => 32 + (int)(TemperatureC / 0.5556);
}