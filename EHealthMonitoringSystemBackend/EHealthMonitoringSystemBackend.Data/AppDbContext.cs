using EHealthMonitoringSystemBackend.Core.Models;
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
    public virtual DbSet<AppFile> AppFiles { get; set; }
    public virtual DbSet<Doctor> Doctors { get; set; }
    public virtual DbSet<Specialization> Specializations { get; set; }
    public virtual DbSet<DoctorSpecialization> DoctorSpecializations { get; set; }
    public virtual DbSet<AppointmentType> AppointmentTypes { get; set; }
}
