namespace AuthService.Application.DTOs.Response;

public class Result
{
    public bool Success { get; set; }
    public string? Message { get; set; } = string.Empty;
    
    public static Result Ok(string? message = null)
        => new() { Success = true, Message = message };
    
    public static Result Fail(string? message = null)
        => new() { Success = true, Message = message };
}