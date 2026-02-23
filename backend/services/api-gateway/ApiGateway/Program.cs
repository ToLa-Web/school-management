using Yarp.ReverseProxy;
using Yarp.ReverseProxy.Configuration;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// CORS - allow Flutter frontend during development
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader());
});

// Register Consul client for later use
builder.Services.AddSingleton<Consul.IConsulClient>(sp => new Consul.ConsulClient(cfg =>
{
    var consulHost = builder.Configuration["consul:host"] ?? "consul";
    var consulPort = int.TryParse(builder.Configuration["consul:port"], out var p) ? p : 8500;
    cfg.Address = new Uri($"http://{consulHost}:{consulPort}");
}));

// Start with empty YARP config - will be populated after Consul is reachable
builder.Services.AddReverseProxy().LoadFromMemory(new List<Yarp.ReverseProxy.Configuration.RouteConfig>(), 
                                                   new List<Yarp.ReverseProxy.Configuration.ClusterConfig>());

var app = builder.Build();

// Discover services from Consul in background (non-blocking)
_ = Task.Run(async () =>
{
    var consulHost = builder.Configuration["consul:host"] ?? "consul";
    var consulPort = int.TryParse(builder.Configuration["consul:port"], out var p) ? p : 8500;
    
    var maxAttempts = 15;
    var delay = TimeSpan.FromSeconds(2);
    
    for (int attempt = 1; attempt <= maxAttempts; attempt++)
    {
        try
        {
            Console.WriteLine($"Attempt {attempt} to discover services from Consul...");
            var (routes, clusters) = ApiGateway.DiscoveryConfigFactory.BuildFromConsul(consulHost, consulPort);
            Console.WriteLine($"✅ Discovered {clusters.Count} service clusters from Consul");
            // Note: Dynamic YARP config update would be needed here for hot-reload
            // For now, routes are loaded from config, discovery is for validation
            break;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"⚠️  Attempt {attempt} to discover services failed: {ex.Message}");
            if (attempt == maxAttempts)
            {
                Console.WriteLine("⚠️  Failed to discover services from Consul - using static YARP config as fallback");
                break;
            }
            await Task.Delay(delay);
        }
    }
});

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseCors("AllowAll");

// Simple health endpoint for compose checks
app.MapGet("/health", () => Results.Ok(new { status = "ok", service = "api-gateway" }));

// Map reverse proxy for /api/*
app.MapReverseProxy();

app.Run();

