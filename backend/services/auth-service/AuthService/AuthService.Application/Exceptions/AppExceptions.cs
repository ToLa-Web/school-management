namespace AuthService.Application.Exceptions;

// Thrown when input data fails validation
public class ValidationException : Exception
{
    public ValidationException(string message) : base(message) { }
}

// Thrown when a requested resource doesn't exist
public class NotFoundException : Exception
{
    public NotFoundException(string message) : base(message) { }
}

// Thrown when someone tries to register with an email that's already taken
public class DuplicateEmailException : Exception
{
    public DuplicateEmailException(string email) 
        : base($"Email '{email}' is already registered") { }
}

// Thrown when the app config is missing or invalid
public class ConfigurationException : Exception
{
    public ConfigurationException(string message) : base(message) { }
}

// Thrown when an operation isn't allowed in the current state
public class InvalidOperationException : Exception
{
    public InvalidOperationException(string message) : base(message) { }
}
