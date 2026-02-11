using System.Net;
using System.Net.Mail;
using AuthService.Application.Interfaces;
using AuthService.Infrastructure.Settings;
using Microsoft.Extensions.Options;

namespace AuthService.Infrastructure.Services;

public class SmtpEmailSender : IEmailSender
{
    private readonly EmailSettings _settings;

    public SmtpEmailSender(IOptions<EmailSettings> settings)
    {
        _settings = settings.Value;
    }

    public async Task SendEmailAsync(string toEmail, string subject, string htmlBody)
    {
        if (string.IsNullOrWhiteSpace(_settings.FromEmail))
            throw new InvalidOperationException("EmailSettings:FromEmail is not configured");

        var smtpUser = string.IsNullOrWhiteSpace(_settings.SmtpUser) ? _settings.FromEmail : _settings.SmtpUser;

        if (string.IsNullOrWhiteSpace(smtpUser))
            throw new InvalidOperationException("EmailSettings:SmtpUser is not configured");

        if (string.IsNullOrWhiteSpace(_settings.AppPassword))
            throw new InvalidOperationException("EmailSettings:AppPassword is not configured");

        MailAddress from;
        try
        {
            from = new MailAddress(_settings.FromEmail);
        }
        catch (FormatException ex)
        {
            throw new InvalidOperationException("EmailSettings:FromEmail is not a valid email address", ex);
        }

        using var message = new MailMessage
        {
            From = from,
            Subject = subject,
            Body = htmlBody,
            IsBodyHtml = true
        };

        try
        {
            message.To.Add(toEmail);
        }
        catch (FormatException ex)
        {
            throw new ArgumentException("Recipient email address is not valid", nameof(toEmail), ex);
        }

        using var smtp = new SmtpClient(_settings.SmtpHost)
        {
            Port = _settings.SmtpPort,
            EnableSsl = _settings.EnableSsl,
            Credentials = new NetworkCredential(smtpUser, _settings.AppPassword)
        };

        await smtp.SendMailAsync(message);
    }
}
