using EHealthMonitoringSystemBackend.Core.Models;

namespace EHealthMonitoringSystemBackend.Api.Dtos;

public class DoctorDto
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    public string Picture { get; set; }
    public IEnumerable<SpecializationGetDto> Specializations { get; set; }
    public IEnumerable<AppointmentTypeDto> AppointmentTypes { get; set; }
}

public class DoctorPostDto
{
    public string Name { get; set; }
    public string Description { get; set; }
}
