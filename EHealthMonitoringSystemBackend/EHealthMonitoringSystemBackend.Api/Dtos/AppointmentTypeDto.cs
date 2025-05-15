namespace EHealthMonitoringSystemBackend.Api.Dtos;

public class AppointmentTypeDto
{
    public string Id { get; set; }
    public string Name { get; set; }
    public int Price { get; set; }
}

public class AppointmentTypePostDto
{
    public string Name { get; set; }
    public int Price { get; set; }
    public string DoctorId { get; set; }
}