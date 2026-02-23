using System.Net;
using System.Text.Json;
using Yarp.ReverseProxy;
using Yarp.ReverseProxy.Configuration;

var builder = WebApplication.CreateBuilder(args);

builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowAll", policy =>
        policy.AllowAnyOrigin()
              .AllowAnyMethod()
              .AllowAnyHeader());
});

builder.Services.AddSingleton<Consul.IConsulClient>(sp => new Consul.ConsulClient(cfg =>
{
    var consulHost = builder.Configuration["consul:host"] ?? "consul";
    var consulPort = int.TryParse(builder.Configuration["consul:port"], out var p) ? p : 8500;
    cfg.Address = new Uri($"http://{consulHost}:{consulPort}");
}));

builder.Services.AddReverseProxy().LoadFromMemory(
    new List<Yarp.ReverseProxy.Configuration.RouteConfig>(),
    new List<Yarp.ReverseProxy.Configuration.ClusterConfig>());

var app = builder.Build();

// Try to discover registered services from Consul in the background.
// This runs non-blocking so the gateway starts even if Consul is slow.
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
            var (routes, clusters) = ApiGateway.DiscoveryConfigFactory.BuildFromConsul(consulHost, consulPort);
            Console.WriteLine($"Discovered {clusters.Count} service clusters from Consul.");
            break;
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Attempt {attempt} to discover services from Consul failed: {ex.Message}");
            if (attempt == maxAttempts)
            {
                Console.WriteLine("Could not reach Consul, falling back to static YARP configuration.");
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

app.MapGet("/health", () => Results.Ok(new { status = "ok", service = "api-gateway" }));

app.Use(async (context, next) =>
{
    try
    {
        await next();
    }
    catch (Exception ex)
    {
        var logger = context.RequestServices.GetRequiredService<ILogger<Program>>();
        logger.LogError(ex, "Unhandled exception in API Gateway");

        context.Response.StatusCode = (int)HttpStatusCode.BadGateway;
        context.Response.ContentType = "application/json";

        var payload = JsonSerializer.Serialize(new
        {
            message = "Gateway error: upstream service is unavailable.",
            code = "BAD_GATEWAY",
#if DEBUG
            details = ex.Message
#endif
        });
        await context.Response.WriteAsync(payload);
    }
});

app.MapReverseProxy();

app.Run();

