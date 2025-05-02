using EHealthMonitoringSystemBackend.Data.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace EHealthMonitoringSystemBackend.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : IdentityDbContext<User>(options)
{
    protected override void OnModelCreating(ModelBuilder builder)
    {
        base.OnModelCreating(builder);
        builder.Entity<User>().Navigation(e => e.RefreshToken).AutoInclude();
    }

    public virtual DbSet<PatientInfo> PatientInfos { get; set; }
    public virtual DbSet<UserRefreshToken> UserRefreshTokens { get; set; }
}
