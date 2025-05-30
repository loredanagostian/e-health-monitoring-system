namespace EHealthMonitoringSystemBackend.Api.Dtos;

public class ChatMessage
{
    public string Role { get; set; }
    public string Content { get; set; }
}

public class ChatRequest
{
    public List<ChatMessage> Messages { get; set; }
}
