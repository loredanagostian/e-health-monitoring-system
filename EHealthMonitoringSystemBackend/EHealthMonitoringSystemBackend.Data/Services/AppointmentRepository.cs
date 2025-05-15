using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.EntityFrameworkCore;

namespace EHealthMonitoringSystemBackend.Data.Services;

public class AppointmentRepository : IAppointmentRepository
{
    private readonly AppDbContext _dbContext;

    public AppointmentRepository(AppDbContext dbContext)
    {
        _dbContext = dbContext;
        _dbSet = _dbContext.Set<Appointment>();;
    }
    
    public DbSet<Appointment> _dbSet { get; }

    public async Task<Appointment> AddUpdateAsync(Appointment appointment)
    {
        var existing = await _dbSet.FirstOrDefaultAsync(a => a.Id.Equals(appointment.Id));

        if (existing is null)
        {
            var dbEntity = (await _dbSet.AddAsync(appointment)).Entity;
            await _dbContext.SaveChangesAsync();
            return dbEntity;
        }

        existing.TotalCost = appointment.TotalCost;
        existing.Date = appointment.Date;
        existing.MedicalHistory = appointment.MedicalHistory;
        existing.Diagnostic = appointment.Diagnostic;
        existing.Recommendation = appointment.Recommendation;

        await _dbContext.SaveChangesAsync();
        return existing;
    }

    public async Task<Appointment> GetOneAsync(Expression<Func<Appointment, bool>> predicate)
    {
        return await _dbSet.Include(a => a.AppointmentType).FirstOrDefaultAsync(predicate);
    }
}