# Global Exception Middleware Implementation

## Overview
✅ **Implemented** - All unhandled exceptions are now caught and formatted as consistent JSON responses.

---

## Architecture

### 1. **Custom Exception Classes** 
Located in: `AuthService.Application/Exceptions/AppExceptions.cs`

```csharp
// Examples of custom exceptions
throw new DuplicateEmailException(email);
throw new ValidationException("Invalid input");
throw new NotFoundException("User not found");
throw new ConfigurationException("Missing config");
throw new InvalidOperationException("Cannot perform action");
```

### 2. **Global Exception Middleware**
Located in: `AuthService.API/Middleware/GlobalExceptionMiddleware.cs`

- Catches ALL unhandled exceptions
- Maps them to appropriate HTTP status codes
- Returns consistent JSON error format

### 3. **Error Response Format**
```json
{
  "message": "Email 'test@example.com' is already registered",
  "code": "EMAIL_ALREADY_EXISTS",
  "details": null,
  "stackTrace": null
}
```

---

## HTTP Status Codes Mapping

| Exception Type | HTTP Status | Code |
|---|---|---|
| `ValidationException` | 400 BadRequest | VALIDATION_ERROR |
| `DuplicateEmailException` | 409 Conflict | EMAIL_ALREADY_EXISTS |
| `NotFoundException` | 404 NotFound | NOT_FOUND |
| `UnauthorizedAccessException` | 401 Unauthorized | UNAUTHORIZED |
| `InvalidOperationException` | 400 BadRequest | INVALID_OPERATION |
| `ConfigurationException` | 500 InternalServer | INTERNAL_ERROR |
| **Generic Exception** | 500 InternalServer | INTERNAL_ERROR |

---

## Usage Examples

### ❌ Before (Bad)
```csharp
public async Task<UserResponseDto> RegisterAsync(UserCreateDto dto)
{
    if (await _userRepo.EmailExistsAsync(email))
        throw new Exception("Email already registered");  // ❌ Generic!
}
```

### ✅ After (Good)
```csharp
public async Task<UserResponseDto> RegisterAsync(UserCreateDto dto)
{
    if (await _userRepo.EmailExistsAsync(email))
        throw new DuplicateEmailException(email);  // ✅ Specific!
}
```

---

## Example Responses

### Register - Email Already Exists
```
POST /api/auth/register
{
  "email": "existing@example.com",
  "username": "john",
  "password": "Pass123!"
}

HTTP/1.1 409 Conflict
Content-Type: application/json

{
  "message": "Email 'existing@example.com' is already registered",
  "code": "EMAIL_ALREADY_EXISTS"
}
```

### Configuration Error
```
HTTP/1.1 500 Internal Server Error

{
  "message": "EmailVerification:Pepper (or Jwt:Secret) is not configured",
  "code": "INTERNAL_ERROR"
}
```

### Validation Error
```
HTTP/1.1 400 Bad Request

{
  "message": "Invalid email address",
  "code": "VALIDATION_ERROR"
}
```

---

## Development vs Production

### 🔧 Development Mode
Includes full error details:
```json
{
  "message": "...",
  "code": "...",
  "details": "NullReferenceException: Object reference not set to an instance of an object",
  "stackTrace": "at AuthService.Application.Services..."
}
```

### 🔒 Production Mode
No sensitive details exposed:
```json
{
  "message": "An unexpected error occurred",
  "code": "INTERNAL_ERROR"
}
```

---

## How to Use

### 1. In AuthenticationService
```csharp
using AuthService.Application.Exceptions;

public async Task<UserResponseDto> RegisterAsync(UserCreateDto dto)
{
    if (await _userRepo.EmailExistsAsync(email.ToUpperInvariant()))
        throw new DuplicateEmailException(email);
    
    // ... rest of code
}
```

### 2. In AuthController
```csharp
[HttpPost("register")]
public async Task<IActionResult> Register([FromBody] UserCreateDto dto)
{
    // ✅ No try-catch needed! Middleware handles it
    var result = await _authService.RegisterAsync(dto);
    return Ok(result);
}
```

### 3. Create Custom Exceptions
If you need a new exception type:

```csharp
// In AppExceptions.cs
public class MyCustomException : Exception
{
    public MyCustomException(string message) : base(message) { }
}

// In GlobalExceptionMiddleware.cs
case MyCustomException ex:
    context.Response.StatusCode = (int)HttpStatusCode.BadRequest;
    response.message = ex.Message;
    response.code = "MY_CUSTOM_ERROR";
    break;
```

---

## Files Modified/Created

✅ Created:
- `AuthService.API/Middleware/GlobalExceptionMiddleware.cs`
- `AuthService.Application/Exceptions/AppExceptions.cs`

✅ Updated:
- `AuthService.API/Program.cs` (added middleware registration)
- `AuthService.Application/Services/AuthenticationService.cs` (replaced Exception throws)

---

## Testing

```powershell
# Rebuild and restart
docker compose down
docker compose up --build -d
docker compose logs auth-service -f
```

Test endpoints:
```bash
# This should return 409 Conflict with EMAIL_ALREADY_EXISTS
POST /api/auth/register
{
  "email": "existing@example.com",
  "username": "john",
  "password": "Pass123!"
}
```

---

**Date**: February 22, 2026
**Status**: ✅ Complete and Ready
