using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace EHealthMonitoringSystemBackend.Data;

public class AppDbContext(DbContextOptions<AppDbContext> options) : IdentityDbContext(options)
{
}