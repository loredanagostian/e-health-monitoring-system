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

    public async Task<AppointmentType> AddUpdateAsync(AppointmentType appointmentType)
    {
        var existing = await _dbSet.FirstOrDefaultAsync(a => a.Id.Equals(appointmentType.Id));

        if (existing is null)
        {
            var dbEntity = (await _dbSet.AddAsync(appointmentType)).Entity;
            await _dbContext.SaveChangesAsync();
            return dbEntity;
        }

        existing.Name = appointmentType.Name;
        existing.Price = appointmentType.Price;
        existing.DoctorId = appointmentType.DoctorId;

        await _dbContext.SaveChangesAsync();
        return existing;
    }

    public async Task<AppointmentType> GetOneAsync(Expression<Func<AppointmentType, bool>> predicate)
    {
        return await _dbSet.FirstOrDefaultAsync(predicate);
    }

    public async Task<IEnumerable<AppointmentType>> GetAllByAsync(Expression<Func<AppointmentType, bool>> predicate)
    {
        return await _dbContext.AppointmentTypes.Where(predicate).ToListAsync();
    }

    public async Task<AppointmentType> DeleteOneAsync(Expression<Func<AppointmentType, bool>> predicate)
    {
        var existing = await _dbContext.AppointmentTypes.FirstOrDefaultAsync(predicate);

        if (existing is null)
        {
            return null;
        }

        _dbSet.Remove(existing);
        await _dbContext.SaveChangesAsync();
        return existing;
    }
}