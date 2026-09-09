using System;
using System.Configuration;
using MailKit.Net.Smtp;
using MailKit.Security;
using MimeKit;

namespace EliteTweet
{
    /// <summary>
    /// Sends OTP emails via Gmail SMTP using MailKit.
    /// Requires a Gmail App Password (not your normal Gmail password) - see Web.config appSettings.
    /// </summary>
    public static class EmailService
    {
        public static void SendOtpEmail(string toEmail, string otpCode)
        {
            string host = ConfigurationManager.AppSettings["Smtp:Host"];
            int port = int.Parse(ConfigurationManager.AppSettings["Smtp:Port"]);
            string user = ConfigurationManager.AppSettings["Smtp:User"];
            string appPassword = ConfigurationManager.AppSettings["Smtp:AppPassword"];
            string fromName = ConfigurationManager.AppSettings["Smtp:FromName"] ?? "EliteTweet";

            var message = new MimeMessage();
            message.From.Add(new MailboxAddress(fromName, user));
            message.To.Add(MailboxAddress.Parse(toEmail));
            message.Subject = "Your EliteTweet verification code";

            var bodyBuilder = new BodyBuilder
            {
                TextBody =
                    "Your EliteTweet verification code is: " + otpCode + "\n\n" +
                    "This code expires in 5 minutes. If you didn't request this, you can ignore this email.",
                HtmlBody =
                    "<div style=\"font-family:Segoe UI,Arial,sans-serif;\">" +
                    "<h2>EliteTweet verification code</h2>" +
                    "<p>Use the code below to continue:</p>" +
                    "<p style=\"font-size:28px;font-weight:bold;letter-spacing:4px;\">" + otpCode + "</p>" +
                    "<p style=\"color:#666;\">This code expires in 5 minutes. If you didn't request this, you can safely ignore this email.</p>" +
                    "</div>"
            };
            message.Body = bodyBuilder.ToMessageBody();

            using (var client = new SmtpClient())
            {
                client.Connect(host, port, SecureSocketOptions.StartTls);
                client.Authenticate(user, appPassword);
                client.Send(message);
                client.Disconnect(true);
            }
        }
    }
}
