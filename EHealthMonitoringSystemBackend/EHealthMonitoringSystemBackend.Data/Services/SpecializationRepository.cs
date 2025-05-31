using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.EntityFrameworkCore;

namespace EHealthMonitoringSystemBackend.Data.Services;

public class SpecializationRepository : ISpecializationRepository
{
    private readonly AppDbContext _dbContext;

    public SpecializationRepository(AppDbContext dbContext)
    {
        _dbContext = dbContext;
        _dbSet = _dbContext.Set<Specialization>();
    }
    
    public DbSet<Specialization> _dbSet { get; }

    public async Task<Specialization> AddUpdateAsync(Specialization specialization)
    {
        var existing = await _dbSet.FirstOrDefaultAsync(a => a.Id.Equals(specialization.Id));

        if (existing is null)
        {
            var dbEntity = (await _dbSet.AddAsync(specialization)).Entity;
            await _dbContext.SaveChangesAsync();
            return dbEntity;
        }

        existing.Name = specialization.Name;
        existing.Icon = specialization.Icon;

        await _dbContext.SaveChangesAsync();
        return existing;
    }

    public async Task<IEnumerable<Specialization>> GetAllAsync()
    {
        return await _dbContext.Specializations.ToListAsync();
    }

    public async Task<Specialization> GetOneAsync(Expression<Func<Specialization, bool>> predicate)
    {
        return await _dbSet.FirstOrDefaultAsync(predicate);
    }

    public async Task<IEnumerable<Specialization>> GetAllByAsync(Expression<Func<Specialization, bool>> predicate)
    {
        return await _dbContext.Specializations.Where(predicate).ToListAsync();
    }

    public async Task<Specialization> DeleteOneAsync(Expression<Func<Specialization, bool>> predicate)
    {
        var existing = await _dbContext.Specializations.FirstOrDefaultAsync(predicate);

        if (existing is null)
        {
            return null;
        }

        _dbSet.Remove(existing);
        await _dbContext.SaveChangesAsync();
        return existing;
    }
}