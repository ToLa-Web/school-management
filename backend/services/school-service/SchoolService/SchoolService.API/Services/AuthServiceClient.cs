using System.Text.Json;
using System.Text.Json.Serialization;

namespace SchoolService.API.Services;

// Calls the auth-service (discovered via Consul) to validate tokens and look up users.
public interface IAuthServiceClient
{
    // Validate a JWT token and return the result including userId/email
    Task<TokenValidationResult> ValidateTokenAsync(string token);

    // Fetch full user info for a given userId
    Task<UserInfo?> GetUserInfoAsync(string userId, string token);

    // Returns true if the token belongs to a user with the given role
    Task<bool> HasRoleAsync(string token, string requiredRole);

    // Returns true if the token belongs to a user with any of the given roles
    Task<bool> HasAnyRoleAsync(string token, params string[] roles);

    // Returns the role name (Admin, Teacher, etc.) for the token's user
    Task<string?> GetUserRoleAsync(string token);

    // Returns the full UserInfo for the currently authenticated token
    Task<UserInfo?> GetCurrentUserAsync(string token);
}

public class AuthServiceClient : IAuthServiceClient
{
    private readonly IServiceDiscoveryClient _serviceDiscovery;
    private readonly HttpClient _httpClient;
    private readonly ILogger<AuthServiceClient> _logger;
    private const string AUTH_SERVICE_NAME = "auth-service";

    public AuthServiceClient(
        IServiceDiscoveryClient serviceDiscovery,
        HttpClient httpClient,
        ILogger<AuthServiceClient> logger)
    {
        _serviceDiscovery = serviceDiscovery;
        _httpClient = httpClient;
        _logger = logger;
    }

    // Forwards the token to auth-service /api/auth/validate and returns the result
    public async Task<TokenValidationResult> ValidateTokenAsync(string token)
    {
            try
            {
                var baseUrl = await _serviceDiscovery.GetServiceUrlAsync(AUTH_SERVICE_NAME);
                
                if (string.IsNullOrEmpty(baseUrl))
                {
                    _logger.LogWarning("Auth service not found in Consul");
                    return new TokenValidationResult { IsValid = false, Error = "Auth service unavailable" };
                }

                _logger.LogInformation("Validating token with auth-service at {Url}", baseUrl);

                var request = new HttpRequestMessage(HttpMethod.Post, $"{baseUrl}/api/auth/validate")
                {
                    Content = new StringContent(
                        JsonSerializer.Serialize(new { token }),
                        System.Text.Encoding.UTF8,
                        "application/json"
                    )
                };

                var response = await _httpClient.SendAsync(request);
                var json = await response.Content.ReadAsStringAsync();
                
                if (response.IsSuccessStatusCode)
                {
                    var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                    var result = JsonSerializer.Deserialize<TokenValidationResponse>(json, options);
                    
                    return new TokenValidationResult
                    {
                        IsValid = result?.Valid ?? false,
                        UserId = result?.UserId,
                        Email = result?.Email,
                        Error = result?.Error
                    };
                }

                return new TokenValidationResult { IsValid = false, Error = "Token validation failed" };
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error validating token with auth service");
                return new TokenValidationResult { IsValid = false, Error = ex.Message };
            }
        }

    // Calls /api/auth/user/{userId} on auth-service to retrieve the full user record
    public async Task<UserInfo?> GetUserInfoAsync(string userId, string token)
    {
            try
            {
                var baseUrl = await _serviceDiscovery.GetServiceUrlAsync(AUTH_SERVICE_NAME);
                
                if (string.IsNullOrEmpty(baseUrl))
                    return null;

                var request = new HttpRequestMessage(HttpMethod.Get, $"{baseUrl}/api/auth/user/{userId}");
                
                if (!string.IsNullOrEmpty(token))
                    request.Headers.Add("Authorization", $"Bearer {token}");

                var response = await _httpClient.SendAsync(request);
                
                if (!response.IsSuccessStatusCode)
                {
                    _logger.LogWarning("Auth service returned {StatusCode} for user {UserId}", response.StatusCode, userId);
                    return null;
                }

                var json = await response.Content.ReadAsStringAsync();
                var options = new JsonSerializerOptions { PropertyNameCaseInsensitive = true };
                return JsonSerializer.Deserialize<UserInfo>(json, options);
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error getting user info for {UserId}", userId);
                return null;
            }
        }

    // Validates the token and checks the user's role against the required one
    public async Task<bool> HasRoleAsync(string token, string requiredRole)
    {
            var validation = await ValidateTokenAsync(token);
            if (!validation.IsValid || string.IsNullOrEmpty(validation.UserId))
                return false;

            var user = await GetUserInfoAsync(validation.UserId, token);
            if (user == null)
                return false;

            var userRole = GetRoleName(user.Role);
            return string.Equals(userRole, requiredRole, StringComparison.OrdinalIgnoreCase);
        }

    // Same as HasRoleAsync but accepts multiple roles - returns true if any match
    public async Task<bool> HasAnyRoleAsync(string token, params string[] roles)
    {
            var validation = await ValidateTokenAsync(token);
            if (!validation.IsValid || string.IsNullOrEmpty(validation.UserId))
                return false;

            var user = await GetUserInfoAsync(validation.UserId, token);
            if (user == null)
                return false;

            var userRole = GetRoleName(user.Role);
            return roles.Any(r => string.Equals(userRole, r, StringComparison.OrdinalIgnoreCase));
        }

    // Validates the token and returns the role name of the user
    public async Task<string?> GetUserRoleAsync(string token)
    {
            var validation = await ValidateTokenAsync(token);
            if (!validation.IsValid || string.IsNullOrEmpty(validation.UserId))
                return null;

            var user = await GetUserInfoAsync(validation.UserId, token);
            return user != null ? GetRoleName(user.Role) : null;
        }

    // Validates the token then fetches and returns the full UserInfo
    public async Task<UserInfo?> GetCurrentUserAsync(string token)
    {
            var validation = await ValidateTokenAsync(token);
            if (!validation.IsValid || string.IsNullOrEmpty(validation.UserId))
                return null;

            return await GetUserInfoAsync(validation.UserId, token);
        }

    // Maps the role integer stored in the DB to a readable name
    private static string GetRoleName(int role) => role switch
    {
            1 => "Student",
            2 => "Teacher",
            3 => "Parent",
            4 => "Admin",
            _ => "Unknown"
    };
}

public class TokenValidationResult
    {
        public bool IsValid { get; set; }
        public string? UserId { get; set; }
        public string? Email { get; set; }
        public string? Error { get; set; }
}

internal class TokenValidationResponse
    {
        public bool Valid { get; set; }
        public string? UserId { get; set; }
        public string? Email { get; set; }
        public string? Error { get; set; }
}

public class UserInfo
    {
        [JsonPropertyName("userId")]
        public string UserId { get; set; } = string.Empty;
        
        [JsonPropertyName("username")]
        public string Username { get; set; } = string.Empty;
        
        [JsonPropertyName("email")]
        public string Email { get; set; } = string.Empty;
        
        [JsonPropertyName("fullName")]
        public string FullName { get; set; } = string.Empty;
        
        [JsonPropertyName("role")]
        public int Role { get; set; }
        
        public string RoleName => Role switch
        {
            1 => "Student",
            2 => "Teacher",
            3 => "Parent",
            4 => "Admin",
            _ => "Unknown"
        };
        
        [JsonPropertyName("isActive")]
        public bool IsActive { get; set; }
        
        [JsonPropertyName("isEmailVerified")]
        public bool IsEmailVerified { get; set; }
        
        [JsonPropertyName("createdAt")]
        public DateTime CreatedAt { get; set; }
}

