using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.EntityFrameworkCore;

namespace EHealthMonitoringSystemBackend.Data.Services;

public class DoctorRepository : IDoctorRepository
{
    private readonly AppDbContext _dbContext;

    public DoctorRepository(AppDbContext dbContext)
    {
        _dbContext = dbContext;
        _dbSet = _dbContext.Set<Doctor>();
    }
    
    public DbSet<Doctor> _dbSet { get; }

    public async Task<Doctor> AddAsync(Doctor doctor)
    {
        var dbDoctor = (await _dbSet.AddAsync(doctor)).Entity;
        await _dbContext.SaveChangesAsync();

        return dbDoctor;
    }

    public async Task<IEnumerable<Doctor>> GetAllAsync()
    {
        return await _dbContext.Doctors.Include(d => d.Picture).ToListAsync();
    }

    public async Task<Doctor> GetOneAsync(Expression<Func<Doctor, bool>> predicate)
    {
        return await _dbSet.Include(d => d.Picture).FirstOrDefaultAsync(predicate);
    }
}