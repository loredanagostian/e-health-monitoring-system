using System.ComponentModel.DataAnnotations.Schema;
using Microsoft.AspNetCore.Identity;

namespace EHealthMonitoringSystemBackend.Data.Models;

public class User : IdentityUser
{
    public UserRefreshToken? RefreshToken { get; set; }
    public PatientProfile? PatientProfile { get; set; }
}
