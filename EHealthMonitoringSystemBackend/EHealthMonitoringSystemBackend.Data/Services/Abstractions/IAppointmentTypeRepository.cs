using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;

namespace EHealthMonitoringSystemBackend.Data.Services.Abstractions;

public interface IAppointmentTypeRepository
{
    Task<AppointmentType> AddUpdateAsync(AppointmentType doctor);
    Task<AppointmentType> GetOneAsync(Expression<Func<AppointmentType, bool>> predicate);
    Task<IEnumerable<AppointmentType>> GetAllByAsync(Expression<Func<AppointmentType, bool>> predicate);
    Task<AppointmentType> DeleteOneAsync(Expression<Func<AppointmentType, bool>> predicate);
    Task<IEnumerable<AppointmentType>> GetManyAsync(Expression<Func<AppointmentType, bool>> predicate);
}