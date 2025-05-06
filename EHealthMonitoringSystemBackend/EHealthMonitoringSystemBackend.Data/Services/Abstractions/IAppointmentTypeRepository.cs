using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;

namespace EHealthMonitoringSystemBackend.Data.Services.Abstractions;

public interface IAppointmentTypeRepository
{
    Task<AppointmentType> AddAsync(AppointmentType doctor);
    Task<AppointmentType> GetOneAsync(Expression<Func<AppointmentType, bool>> predicate);
    Task<IEnumerable<AppointmentType>> GetAllByAsync(Expression<Func<AppointmentType, bool>> predicate);
}