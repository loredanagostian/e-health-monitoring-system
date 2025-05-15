using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;

namespace EHealthMonitoringSystemBackend.Data.Services.Abstractions;

public interface IAppointmentRepository
{
    Task<Appointment> AddUpdateAsync(Appointment appointment);
    Task<Appointment> GetOneAsync(Expression<Func<Appointment, bool>> predicate);
}