using EHealthMonitoringSystemBackend.Data.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace EHealthMonitoringSystemBackend.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : IdentityDbContext<User>(options)
{
    public virtual DbSet<PatientInfo> PatientInfos { get; set; }
    public virtual DbSet<UserRefreshToken> UserRefreshTokens { get; set; }
}
