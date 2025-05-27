namespace EHealthMonitoringSystemBackend.Api.Dtos;

public class SpecializationAddDto
{
    public string Name { get; set; }
    public string Icon { get; set; }
}

public class SpecializationGetDto
{
    public string Id { get; set; }
    public string Name { get; set; }
    public string Icon { get; set; }
}