using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.EntityFrameworkCore;

namespace EHealthMonitoringSystemBackend.Data.Services;

public class DoctorSpecializationRepository : IDoctorSpecializationsRepository
{
    private readonly AppDbContext _dbContext;

    public DoctorSpecializationRepository(AppDbContext dbContext)
    {
        _dbContext = dbContext;
        _dbSet = _dbContext.Set<DoctorSpecialization>();
    }
    
    public DbSet<DoctorSpecialization> _dbSet { get; }

    public async Task<DoctorSpecialization> AddSpecializationToDoctorAsync(string doctorId, string specializationId)
    {
        var doctorSpecialization = new DoctorSpecialization
        {
            DoctorId = doctorId,
            SpecializationId = specializationId
        };

        var dbDoctorSpecialization = (await _dbSet.AddAsync(doctorSpecialization)).Entity;
        await _dbContext.SaveChangesAsync();
        
        return dbDoctorSpecialization;
    }

    public async Task<IEnumerable<DoctorSpecialization>> GetAllByAsync(Expression<Func<DoctorSpecialization, bool>> predicate)
    {
        return await _dbContext.DoctorSpecializations.Where(predicate).ToListAsync();
    }
}