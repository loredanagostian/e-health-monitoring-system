namespace EHealthMonitoringSystemBackend.Api.Dtos;

public class AppointmentCreateDto
{
    public string AppointmentTypeId { get; set; }
    public DateTime Date { get; set; }
    public int TotalCost { get; set; }
}

public class AppointmentUpdateDto
{
    public string Id { get; set; }
    public string? MedicalHistory { get; set; }
    public string? Diagnostic { get; set; }
    public string? Recommendation { get; set; }
}

public class AppointmentGetAllDto
{
    public string Id { get; set; }
    public int TotalCost { get; set; }
    public DateTime Date { get; set; }
    public string AppointmentType { get; set; }
    public string DoctorName { get; set; }
    public string DoctorPicture { get; set; }
}

public class AppointmentGetOneDto
{
    public string Id { get; set; }
    public DateTime Date { get; set; }
    public string AppointmentType { get; set; }
    public string DoctorName { get; set; }
    public string DoctorPicture { get; set; }
    public string MedicalHistory { get; set; }
    public string Diagnostic { get; set; }
    public string Recommendation { get; set; }
}