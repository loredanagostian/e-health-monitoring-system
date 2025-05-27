using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;

namespace EHealthMonitoringSystemBackend.Data.Services.Abstractions;

public interface IDoctorRepository
{
    Task<Doctor> AddAsync(Doctor doctor);
    Task<IEnumerable<Doctor>> GetAllAsync();
    Task<IEnumerable<Doctor>> GetAllByAsync(Expression<Func<Doctor, bool>> predicate);
    Task<Doctor> GetOneAsync(Expression<Func<Doctor, bool>> predicate);
}