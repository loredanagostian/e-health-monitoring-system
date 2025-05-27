using EHealthMonitoringSystemBackend.Data.Models;

namespace EHealthMonitoringSystemBackend.Data.Services.Abstractions;

public interface IPatientProfileRepository
{
    Task<PatientProfile> UpdateAsync(int id, PatientProfile patientProfile);
    Task<PatientProfile> GetByUserId(string id);
}