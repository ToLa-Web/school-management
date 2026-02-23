using Microsoft.AspNetCore.Mvc;
using SchoolService.API.Services;
using System.IdentityModel.Tokens.Jwt;

namespace SchoolService.API.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class ValidationController : ControllerBase
    {
        private readonly IAuthServiceClient _authClient;
        private readonly ILogger<ValidationController> _logger;

        // 🔹 INJECT: Get the auth service client
        public ValidationController(IAuthServiceClient authClient, ILogger<ValidationController> logger)
        {
            _authClient = authClient;
            _logger = logger;
        }

        /// <summary>
        /// Example 1: Validate token with auth service
        /// Uses Consul to discover auth-service
        /// </summary>
        [HttpPost("validate-token")]
        public async Task<IActionResult> ValidateToken([FromBody] ValidateRequest request)
        {
            _logger.LogInformation("Validating token with auth-service via Consul...");
            
            // This internally:
            // 1. Asks Consul: "Where is auth-service?"
            // 2. Gets the address from Consul
            // 3. Calls auth-service at that address
            var isValid = await _authClient.ValidateTokenAsync(request.Token);
            
            return Ok(new { valid = isValid, message = isValid ? "Token is valid" : "Token is invalid" });
        }

        /// <summary>
        /// Example 2: Get user info from auth service
        /// Extracts userId from the token itself
        /// </summary>
        [HttpGet("user/{userId}")]
        public async Task<IActionResult> GetUserInfo(string userId)
        {
            _logger.LogInformation($"Fetching user {userId} from auth-service...");
            
            // Get token from request header
            var token = HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            
            if (string.IsNullOrEmpty(token))
                return Unauthorized("Token is required");
            
            var user = await _authClient.GetUserInfoAsync(userId, token);
            
            if (user == null)
                return NotFound(new { error = "User not found", userId = userId });
            
            return Ok(user);
        }

        /// <summary>
        /// Example 3: Combination - Check if user is authorized to see students
        /// </summary>
        [HttpGet("check-student-access")]
        public async Task<IActionResult> CheckStudentAccess()
        {
            // Get token from request header
            var token = HttpContext.Request.Headers["Authorization"].ToString().Replace("Bearer ", "");
            
            // Ask auth-service to validate the token
            var isValid = await _authClient.ValidateTokenAsync(token);
            
            if (!isValid)
                return Unauthorized("Invalid token");
            
            return Ok(new { 
                message = "Access granted", 
                canViewStudents = true,
                reason = "Token validated with auth-service via Consul discovery" 
            });
        }
    }

    public class ValidateRequest
    {
        public string Token { get; set; }
    }
}
