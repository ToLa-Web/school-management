using Microsoft.AspNetCore.Mvc;
using SchoolService.API.Services;
using System.IdentityModel.Tokens.Jwt;

namespace SchoolService.API.Controllers
{
    // Validation endpoints that talk to auth-service via Consul - demonstrates service-to-service discovery
    [ApiController]
    [Route("api/[controller]")]
    public class ValidationController : ControllerBase
    {
        private readonly IAuthServiceClient _authClient;
        private readonly ILogger<ValidationController> _logger;

        public ValidationController(IAuthServiceClient authClient, ILogger<ValidationController> logger)
        {
            _authClient = authClient;
            _logger = logger;
        }

        // Sends the token to auth-service for validation - auth-service is discovered via Consul
        [HttpPost("validate-token")]
        public async Task<IActionResult> ValidateToken([FromBody] ValidateRequest request)
        {
            _logger.LogInformation("Validating token with auth-service via Consul...");
            
            var result = await _authClient.ValidateTokenAsync(request.Token);
            
            return Ok(new { 
                valid = result.IsValid, 
                userId = result.UserId,
                email = result.Email,
                message = result.IsValid ? "Token is valid" : result.Error ?? "Token is invalid" 
            });
        }

        // Fetches user info from auth-service - requires a valid Bearer token
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserInfo(string userId)
        {
            _logger.LogInformation("Fetching user {UserId} from auth-service via Consul...", userId);
            
            var token = HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            
            if (string.IsNullOrEmpty(token))
                return Unauthorized(new { error = "Token is required" });
            
            var user = await _authClient.GetUserInfoAsync(userId, token);
            
            if (user == null)
                return NotFound(new { error = "User not found", userId });
            
            return Ok(user);
        }

        // Decodes the token and returns info about the currently logged-in user
        [HttpGet("me")]
        public async Task<IActionResult> GetCurrentUser()
        {
            var token = HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            
            if (string.IsNullOrEmpty(token))
                return Unauthorized(new { error = "Token is required" });
            
            var user = await _authClient.GetCurrentUserAsync(token);
            
            if (user == null)
                return Unauthorized(new { error = "Invalid token or user not found" });
            
            return Ok(user);
        }

        // Checks whether the current user holds the given role
        [HttpGet("check-role/{role}")]
        public async Task<IActionResult> CheckRole(string role)
        {
            var token = HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            
            if (string.IsNullOrEmpty(token))
                return Unauthorized(new { error = "Token is required" });
            
            var hasRole = await _authClient.HasRoleAsync(token, role);
            var userRole = await _authClient.GetUserRoleAsync(token);
            
            return Ok(new { 
                requiredRole = role,
                userRole = userRole,
                hasAccess = hasRole,
                message = hasRole ? $"User has {role} role" : $"Access denied. User is {userRole}, not {role}"
            });
        }

        // Example of an endpoint restricted to Admin users only
        [HttpGet("admin-only")]
        public async Task<IActionResult> AdminOnly()
        {
            var token = HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            
            if (string.IsNullOrEmpty(token))
                return Unauthorized(new { error = "Token is required" });
            
            var isAdmin = await _authClient.HasRoleAsync(token, "Admin");
            
            if (!isAdmin)
            {
                var userRole = await _authClient.GetUserRoleAsync(token);
                return StatusCode(403, new { 
                    error = "Forbidden", 
                    message = $"Admin access required. Your role: {userRole}",
                    requiredRole = "Admin"
                });
            }
            
            return Ok(new { 
                message = "Welcome Admin! You have access to admin resources.",
                timestamp = DateTime.UtcNow,
                discoveredVia = "Consul Service Discovery"
            });
        }

        // Accessible by both Teachers and Admins - rejects anyone else
        [HttpGet("teacher-or-admin")]
        public async Task<IActionResult> TeacherOrAdmin()
        {
            var token = HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            
            if (string.IsNullOrEmpty(token))
                return Unauthorized(new { error = "Token is required" });
            
            var hasAccess = await _authClient.HasAnyRoleAsync(token, "Teacher", "Admin");
            
            if (!hasAccess)
            {
                var userRole = await _authClient.GetUserRoleAsync(token);
                return StatusCode(403, new { 
                    error = "Forbidden", 
                    message = $"Teacher or Admin access required. Your role: {userRole}",
                    allowedRoles = new[] { "Teacher", "Admin" }
                });
            }

            var user = await _authClient.GetCurrentUserAsync(token);
            
            return Ok(new { 
                message = $"Welcome {user?.RoleName}! You have access to educational resources.",
                user = new { user?.Username, user?.Email, user?.RoleName },
                timestamp = DateTime.UtcNow,
                discoveredVia = "Consul Service Discovery"
            });
        }

        // Checks if the user is allowed to view student data (Teachers, Parents, and Admins only)
        [HttpGet("check-student-access")]
        public async Task<IActionResult> CheckStudentAccess()
        {
            var token = HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            
            if (string.IsNullOrEmpty(token))
                return Unauthorized(new { error = "Token is required" });
            
            var canAccess = await _authClient.HasAnyRoleAsync(token, "Teacher", "Parent", "Admin");
            var user = await _authClient.GetCurrentUserAsync(token);
            
            return Ok(new { 
                canViewStudents = canAccess,
                user = user != null ? new { user.Username, user.RoleName } : null,
                reason = canAccess 
                    ? "Access granted via role-based authorization" 
                    : $"Only Teacher, Parent, or Admin can view student data. Your role: {user?.RoleName}",
                discoveredVia = "Consul Service Discovery"
            });
        }
    }

    public class ValidateRequest
    {
        public string Token { get; set; } = string.Empty;
    }
}
