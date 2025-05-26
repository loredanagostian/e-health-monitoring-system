using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.EntityFrameworkCore;

namespace EHealthMonitoringSystemBackend.Data.Services;

public class AppointmentFileRepository : IAppointmentFileRepository
{
    private readonly AppDbContext _dbContext;

    public AppointmentFileRepository(AppDbContext dbContext)
    {
        _dbContext = dbContext;
        _dbSet = _dbContext.Set<AppointmentFile>();;
    }
    
    public DbSet<AppointmentFile> _dbSet { get; }

    public async Task AddAsync(IEnumerable<AppointmentFile> appointmentFiles)
    {
        await _dbSet.AddRangeAsync(appointmentFiles);
        await _dbContext.SaveChangesAsync();
    }
}