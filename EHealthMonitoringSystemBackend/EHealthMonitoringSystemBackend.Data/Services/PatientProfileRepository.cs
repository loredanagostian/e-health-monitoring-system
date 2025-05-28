using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.EntityFrameworkCore;

namespace EHealthMonitoringSystemBackend.Data.Services;

public class PatientProfileRepository : IPatientProfileRepository
{
    private readonly AppDbContext _dbContext;

    public PatientProfileRepository(AppDbContext dbContext)
    {
        _dbContext = dbContext;
        _dbSet = _dbContext.Set<PatientProfile>();
    }

    public DbSet<PatientProfile> _dbSet { get; }

    public async Task<PatientProfile> UpdateAsync(int id, PatientProfile patientProfile)
    {
        var existing = await _dbSet.FirstOrDefaultAsync(a => a.Id == id);

        if (existing is null)
        {
            return null;
        }

        existing.FirstName = patientProfile.FirstName;
        existing.LastName = patientProfile.LastName;
        existing.Cnp = patientProfile.Cnp;
        existing.PhoneNumber = patientProfile.PhoneNumber;

        await _dbContext.SaveChangesAsync();
        return existing;
    }

    public async Task<PatientProfile> GetByUserId(string id)
    {
        var user = await _dbContext
            .Users.Include(u => u.PatientProfile)
            .FirstOrDefaultAsync(u => u.Id == id);

        if (user is null || user.PatientProfile is null)
        {
            return null;
        }

        var patientProfile = await _dbContext.PatientProfiles.FirstOrDefaultAsync(p =>
            p.Id == user.PatientProfile.Id
        );

        return patientProfile;
    }
}
