using EHealthMonitoringSystemBackend.Core.Models;
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
        builder.Entity<User>().Navigation(e => e.PatientProfile).AutoInclude();
    }

    public virtual DbSet<PatientProfile> PatientProfiles { get; set; }
    public virtual DbSet<UserRefreshToken> UserRefreshTokens { get; set; }
    public virtual DbSet<AppFile> AppFiles { get; set; }
    public virtual DbSet<Doctor> Doctors { get; set; }
    public virtual DbSet<Specialization> Specializations { get; set; }
    public virtual DbSet<DoctorSpecialization> DoctorSpecializations { get; set; }
    public virtual DbSet<AppointmentType> AppointmentTypes { get; set; }
    public virtual DbSet<Appointment> Appointments { get; set; }
    public virtual DbSet<AppointmentFile> AppointmentFiles { get; set; }
    public virtual DbSet<ChatMessage> Conversations { get; set; }
}
