using EHealthMonitoringSystemBackend.Core.Models;

public class ChatMessage
{
    public int Id { get; set; }

    public string UserId { get; set; }
    public User User { get; set; }

    public string Sender { get; set; }
    public string Message { get; set; }
    public DateTime Timestamp { get; set; } = DateTime.UtcNow;
}
