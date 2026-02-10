namespace AuthService.Infrastructure.Settings;

public class EmailSettings
{
    public string FromEmail { get; set; } = string.Empty;
    public string SmtpHost { get; set; } = "smtp.gmail.com";
    public int SmtpPort { get; set; } = 587;
    public bool EnableSsl { get; set; } = true;
    public string SmtpUser { get; set; } = string.Empty;
    public string AppPassword { get; set; } = string.Empty;
}
