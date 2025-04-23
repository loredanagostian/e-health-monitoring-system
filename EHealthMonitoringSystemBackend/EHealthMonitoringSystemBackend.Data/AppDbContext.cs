using EHealthMonitoringSystemBackend.Data.Models;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace EHealthMonitoringSystemBackend.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : IdentityDbContext(options)
{
    public DbSet<PatientInfo> PatientInfos {get; set;}
}