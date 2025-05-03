using Microsoft.AspNetCore.Identity;

namespace EHealthMonitoringSystemBackend.Core.Models;

public class User : IdentityUser
{
    public UserRefreshToken? RefreshToken { get; set; }
}
