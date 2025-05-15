using EHealthMonitoringSystemBackend.Core.Models;

namespace EHealthMonitoringSystemBackend.Data.Services.Abstractions;

public interface IAppointmentFileRepository
{
    Task AddAsync(IEnumerable<AppointmentFile> appointmentFiles);
}