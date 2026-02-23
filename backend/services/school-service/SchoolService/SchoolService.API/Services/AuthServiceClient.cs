using Consul;
using System.Text.Json;
using System.Text.Json.Serialization;

namespace SchoolService.API.Services
{
    /// <summary>
    /// This service discovers and calls the auth-service using Consul
    /// </summary>
    public interface IAuthServiceClient
    {
        Task<bool> ValidateTokenAsync(string token);
        Task<UserInfo?> GetUserInfoAsync(string userId, string token);
    }

    public class AuthServiceClient : IAuthServiceClient
    {
        private readonly IConsulClient _consulClient;
        private readonly HttpClient _httpClient;
        private readonly ILogger<AuthServiceClient> _logger;

        // Constructor: Inject IConsulClient and HttpClient
        public AuthServiceClient(IConsulClient consulClient, HttpClient httpClient, ILogger<AuthServiceClient> logger)
        {
            _consulClient = consulClient;
            _httpClient = httpClient;
            _logger = logger;
        }

        /// <summary>
        /// Example 1: Discover auth-service from Consul and call it
        /// </summary>
        public async Task<bool> ValidateTokenAsync(string token)
        {
            try
            {
                // 1️ DISCOVER: Ask Consul where is "auth-service"?
                var instances = await _consulClient.Catalog.Service("auth-service");
                
                if (!instances.Response?.Any() ?? true)
                {
                    _logger.LogWarning("Auth service not found in Consul");
                    return false;
                }

                // 2️ PICK: Get the first healthy instance (or implement load balancing)
                var instance = instances.Response.First().ServiceAddress;
                var port = instances.Response.First().ServicePort;
                
                _logger.LogInformation($"Discovered auth-service at {instance}:{port}");

                // 3️ CALL: Make HTTP request to that service
                var authServiceUrl = $"http://{instance}:{port}/api/auth/validate";
                
                var request = new HttpRequestMessage(HttpMethod.Post, authServiceUrl)
                {
                    Content = new StringContent(
                        JsonSerializer.Serialize(new { token }),
                        System.Text.Encoding.UTF8,
                        "application/json"
                    )
                };
                request.Headers.Add("Authorization", $"Bearer {token}");

                var response = await _httpClient.SendAsync(request);
                
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error validating token with auth service: {ex.Message}");
                return false;
            }
        }

        /// <summary>
        /// Example 2: Another way - using service name directly (simpler)
        /// </summary>
        public async Task<UserInfo?> GetUserInfoAsync(string userId, string token)
        {
            try
            {
                // Discover service
                var instances = await _consulClient.Catalog.Service("auth-service");
                
                if (!instances.Response?.Any() ?? true)
                    return null;

                var instance = instances.Response.First();
                var baseUrl = $"http://{instance.ServiceAddress}:{instance.ServicePort}";

                // Create request with authorization header
                var request = new HttpRequestMessage(HttpMethod.Get, $"{baseUrl}/api/auth/user/{userId}");
                
                // Add the token to the Authorization header
                if (!string.IsNullOrEmpty(token))
                {
                    request.Headers.Add("Authorization", $"Bearer {token}");
                }

                // Call the endpoint
                var response = await _httpClient.SendAsync(request);
                
                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning($"Auth service returned status {response.StatusCode} for user {userId}");
                    return null;
                }

                var json = await response.Content.ReadAsStringAsync();
                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                var user = JsonSerializer.Deserialize<UserInfo>(json, options);
                
                _logger.LogInformation($"Retrieved user info for {userId}");
                return user;
            }
            catch (Exception ex)
            {
                _logger.LogError($"Error getting user info: {ex.Message}");
                return null;
            }
        }
    }

    // Response models
    public class UserInfo
    {
        [JsonPropertyName("userId")]
        public string UserId { get; set; }
        
        [JsonPropertyName("username")]
        public string Username { get; set; }
        
        [JsonPropertyName("email")]
        public string Email { get; set; }
        
        [JsonPropertyName("fullName")]
        public string FullName { get; set; }
        
        [JsonPropertyName("role")]
        public int Role { get; set; }
        
        [JsonPropertyName("isActive")]
        public bool IsActive { get; set; }
        
        [JsonPropertyName("isEmailVerified")]
        public bool IsEmailVerified { get; set; }
        
        [JsonPropertyName("createdAt")]
        public DateTime CreatedAt { get; set; }
    }
}
