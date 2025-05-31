using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;

namespace EHealthMonitoringSystemBackend.Data.Services.Abstractions;

public interface ISpecializationRepository
{
    Task<Specialization> AddUpdateAsync(Specialization specialization);
    Task<IEnumerable<Specialization>> GetAllAsync();
    Task<Specialization> GetOneAsync(Expression<Func<Specialization, bool>> predicate);
    Task<IEnumerable<Specialization>> GetAllByAsync(Expression<Func<Specialization, bool>> predicate);
    Task<Specialization> DeleteOneAsync(Expression<Func<Specialization, bool>> predicate);
}