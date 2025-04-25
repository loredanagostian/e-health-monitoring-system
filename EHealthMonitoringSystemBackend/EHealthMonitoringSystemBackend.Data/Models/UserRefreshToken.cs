using System.ComponentModel.DataAnnotations;

namespace EHealthMonitoringSystemBackend.Data.Models;

public class UserRefreshToken
{
    [Key]
    public int Id { get; set; }
    public string? RefreshToken { get; set; }
    public bool IsActive { get; set; } = true;
}
