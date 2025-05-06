using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;

namespace EHealthMonitoringSystemBackend.Data.Services.Abstractions;

public interface IDoctorSpecializationsRepository
{
    Task<DoctorSpecialization> AddSpecializationToDoctorAsync(string doctorId, string specializationId);
    Task<IEnumerable<DoctorSpecialization>> GetAllByAsync(Expression<Func<DoctorSpecialization, bool>> predicate);
}