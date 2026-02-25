using Consul;
using Microsoft.Extensions.Caching.Memory;
using System.Text.Json;

namespace SchoolService.API.Services;

// Discovers services from Consul and returns healthy instance URLs.
// Uses round-robin load balancing and caches results for 30 seconds.
public interface IServiceDiscoveryClient
{
    // Returns the URL of one healthy instance, selected via round-robin
    Task<string?> GetServiceUrlAsync(string serviceName);

    // Returns all healthy instances of a service
    Task<List<ServiceInstance>> GetServiceInstancesAsync(string serviceName);

    // Returns the health summary for every registered service in Consul
    Task<Dictionary<string, ServiceHealthStatus>> GetAllServicesHealthAsync();
}

public class ServiceDiscoveryClient : IServiceDiscoveryClient
{
    private readonly IConsulClient _consulClient;
    private readonly IMemoryCache _cache;
    private readonly ILogger<ServiceDiscoveryClient> _logger;
    
    private static int _roundRobinCounter = 0;
    private static readonly TimeSpan CacheDuration = TimeSpan.FromSeconds(30);

    public ServiceDiscoveryClient(
        IConsulClient consulClient, 
        IMemoryCache cache,
        ILogger<ServiceDiscoveryClient> logger)
    {
        _consulClient = consulClient;
        _cache = cache;
        _logger = logger;
    }

    // Picks one healthy instance using round-robin and returns its base URL
    public async Task<string?> GetServiceUrlAsync(string serviceName)
    {
        var instances = await GetServiceInstancesAsync(serviceName);
        
        if (instances == null || instances.Count == 0)
        {
            _logger.LogWarning("No healthy instances found for service: {ServiceName}", serviceName);
            return null;
        }

        // Round-robin load balancing
        var index = Interlocked.Increment(ref _roundRobinCounter) % instances.Count;
        var selectedInstance = instances[index];
        
        _logger.LogInformation(
            "Selected instance {Index}/{Total} for {ServiceName}: {Url}",
            index + 1, instances.Count, serviceName, selectedInstance.Url);
        
        return selectedInstance.Url;
    }

    // Fetches all passing instances from Consul, caches the list for 30 seconds
    public async Task<List<ServiceInstance>> GetServiceInstancesAsync(string serviceName)
    {
        var cacheKey = $"consul_service_{serviceName}";
        
        if (_cache.TryGetValue(cacheKey, out List<ServiceInstance>? cachedInstances))
        {
            _logger.LogDebug("Returning cached instances for {ServiceName}", serviceName);
            return cachedInstances!;
        }

        try
        {
            var queryResult = await _consulClient.Health.Service(serviceName, tag: null, passingOnly: true);
            
            if (queryResult?.Response == null || queryResult.Response.Length == 0)
            {
                _logger.LogWarning("No healthy instances found in Consul for: {ServiceName}", serviceName);
                return new List<ServiceInstance>();
            }

            var instances = queryResult.Response.Select(entry => new ServiceInstance
            {
                ServiceName = entry.Service.Service,
                ServiceId = entry.Service.ID,
                Address = entry.Service.Address,
                Port = entry.Service.Port,
                Url = $"http://{entry.Service.Address}:{entry.Service.Port}",
                Tags = entry.Service.Tags?.ToList() ?? new List<string>(),
                IsHealthy = true,
                LastChecked = DateTime.UtcNow
            }).ToList();

            _cache.Set(cacheKey, instances, CacheDuration);
            
            _logger.LogInformation(
                "Discovered {Count} healthy instances for {ServiceName}", 
                instances.Count, serviceName);
            
            return instances;
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error discovering service: {ServiceName}", serviceName);
            return new List<ServiceInstance>();
        }
    }

    // Builds a health summary for every service currently registered in Consul
    public async Task<Dictionary<string, ServiceHealthStatus>> GetAllServicesHealthAsync()
    {
        var result = new Dictionary<string, ServiceHealthStatus>();
        
        try
        {
            var services = await _consulClient.Agent.Services();
            
            foreach (var service in services.Response.Values)
            {
                var healthChecks = await _consulClient.Health.Checks(service.Service);
                var isHealthy = healthChecks.Response.All(c => c.Status == HealthStatus.Passing);
                
                if (!result.ContainsKey(service.Service))
                {
                    result[service.Service] = new ServiceHealthStatus
                    {
                        ServiceName = service.Service,
                        TotalInstances = 0,
                        HealthyInstances = 0,
                        UnhealthyInstances = 0,
                        Instances = new List<ServiceInstance>()
                    };
                }

                result[service.Service].TotalInstances++;
                if (isHealthy)
                    result[service.Service].HealthyInstances++;
                else
                    result[service.Service].UnhealthyInstances++;

                result[service.Service].Instances.Add(new ServiceInstance
                {
                    ServiceId = service.ID,
                    ServiceName = service.Service,
                    Address = service.Address,
                    Port = service.Port,
                    Url = $"http://{service.Address}:{service.Port}",
                    IsHealthy = isHealthy,
                    Tags = service.Tags?.ToList() ?? new List<string>(),
                    LastChecked = DateTime.UtcNow
                });
            }
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error getting all services health");
        }

        return result;
    }
}

public class ServiceInstance
{
    public string ServiceName { get; set; } = string.Empty;
    public string ServiceId { get; set; } = string.Empty;
    public string Address { get; set; } = string.Empty;
    public int Port { get; set; }
    public string Url { get; set; } = string.Empty;
    public List<string> Tags { get; set; } = new();
    public bool IsHealthy { get; set; }
    public DateTime LastChecked { get; set; }
}

public class ServiceHealthStatus
{
    public string ServiceName { get; set; } = string.Empty;
    public int TotalInstances { get; set; }
    public int HealthyInstances { get; set; }
    public int UnhealthyInstances { get; set; }
    public bool IsHealthy => HealthyInstances > 0;
    public List<ServiceInstance> Instances { get; set; } = new();
}
