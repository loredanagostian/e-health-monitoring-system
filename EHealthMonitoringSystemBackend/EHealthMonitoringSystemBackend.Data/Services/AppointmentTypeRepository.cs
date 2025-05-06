using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.EntityFrameworkCore;

namespace EHealthMonitoringSystemBackend.Data.Services;

public class AppointmentTypeRepository : IAppointmentTypeRepository
{
    private readonly AppDbContext _dbContext;

    public AppointmentTypeRepository(AppDbContext dbContext)
    {
        _dbContext = dbContext;
        _dbSet = _dbContext.Set<AppointmentType>();
    }
    
    public DbSet<AppointmentType> _dbSet { get; }

    public async Task<AppointmentType> AddAsync(AppointmentType appointmentType)
    {
        var dbAppointmentType = (await _dbSet.AddAsync(appointmentType)).Entity;
        await _dbContext.SaveChangesAsync();

        return dbAppointmentType;
    }

    public async Task<AppointmentType> GetOneAsync(Expression<Func<AppointmentType, bool>> predicate)
    {
        return await _dbSet.FirstOrDefaultAsync(predicate);
    }

    public async Task<IEnumerable<AppointmentType>> GetAllByAsync(Expression<Func<AppointmentType, bool>> predicate)
    {
        return await _dbContext.AppointmentTypes.Where(predicate).ToListAsync();
    }
}