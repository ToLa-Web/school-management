using System.Net;
using System.Text.Json;
using AuthService.Application.Exceptions;

namespace AuthService.API.Middleware;

public class GlobalExceptionMiddleware
{
    private readonly RequestDelegate _next;
    private readonly ILogger<GlobalExceptionMiddleware> _logger;

    public GlobalExceptionMiddleware(RequestDelegate next, ILogger<GlobalExceptionMiddleware> logger)
    {
        _next = next;
        _logger = logger;
    }

    public async Task InvokeAsync(HttpContext context)
    {
        try
        {
            await _next(context);
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "An unhandled exception occurred");
            await HandleExceptionAsync(context, ex);
        }
    }

    private static Task HandleExceptionAsync(HttpContext context, Exception exception)
    {
        context.Response.ContentType = "application/json";

        var response = new ErrorResponse
        {
            message = "An error occurred",
            code = "INTERNAL_ERROR"
        };

        switch (exception)
        {
            case ValidationException ex:
                context.Response.StatusCode = (int)HttpStatusCode.BadRequest;
                response.message = ex.Message;
                response.code = "VALIDATION_ERROR";
                break;

            case NotFoundException ex:
                context.Response.StatusCode = (int)HttpStatusCode.NotFound;
                response.message = ex.Message;
                response.code = "NOT_FOUND";
                break;

            case DuplicateEmailException ex:
                context.Response.StatusCode = (int)HttpStatusCode.Conflict;
                response.message = ex.Message;
                response.code = "EMAIL_ALREADY_EXISTS";
                break;

            case UnauthorizedAccessException ex:
                context.Response.StatusCode = (int)HttpStatusCode.Unauthorized;
                response.message = ex.Message;
                response.code = "UNAUTHORIZED";
                break;

            case System.InvalidOperationException ex:
                context.Response.StatusCode = (int)HttpStatusCode.BadRequest;
                response.message = ex.Message;
                response.code = "INVALID_OPERATION";
                break;

            default:
                context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                response.message = "An unexpected error occurred";
                response.code = "INTERNAL_ERROR";
#if DEBUG
                response.details = exception.Message;
                response.stackTrace = exception.StackTrace;
#endif
                break;
        }

        return context.Response.WriteAsJsonAsync(response);
    }
}

public class ErrorResponse
{
    public string message { get; set; } = string.Empty;
    public string code { get; set; } = string.Empty;
    public string? details { get; set; }
    public string? stackTrace { get; set; }
}
