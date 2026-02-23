namespace AuthService.Application.Exceptions;

/// <summary>
/// Thrown when validation fails
/// </summary>
public class ValidationException : Exception
{
    public ValidationException(string message) : base(message) { }
}

/// <summary>
/// Thrown when a resource is not found
/// </summary>
public class NotFoundException : Exception
{
    public NotFoundException(string message) : base(message) { }
}

/// <summary>
/// Thrown when trying to register with an email that already exists
/// </summary>
public class DuplicateEmailException : Exception
{
    public DuplicateEmailException(string email) 
        : base($"Email '{email}' is already registered") { }
}

/// <summary>
/// Thrown when configuration is invalid
/// </summary>
public class ConfigurationException : Exception
{
    public ConfigurationException(string message) : base(message) { }
}

/// <summary>
/// Thrown when an invalid operation is attempted
/// </summary>
public class InvalidOperationException : Exception
{
    public InvalidOperationException(string message) : base(message) { }
}
