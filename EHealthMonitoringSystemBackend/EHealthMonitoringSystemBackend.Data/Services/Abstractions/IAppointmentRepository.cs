using System.Linq.Expressions;
using EHealthMonitoringSystemBackend.Core.Models;

namespace EHealthMonitoringSystemBackend.Data.Services.Abstractions;

public interface IAppointmentRepository
{
    Task<Appointment> AddUpdateAsync(Appointment appointment);
    Task<Appointment> GetOneAsync(Expression<Func<Appointment, bool>> predicate);
    Task<Appointment> GetByIdAsync(string id);
    Task<IEnumerable<Appointment>> GetAsync();
    Task<IEnumerable<Appointment>> GetAsync(Expression<Func<Appointment, bool>> predicate);
    Task<Appointment> DeleteOneAsync(Expression<Func<Appointment, bool>> predicate);
}