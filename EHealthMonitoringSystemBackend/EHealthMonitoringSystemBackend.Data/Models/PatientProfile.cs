using System.ComponentModel.DataAnnotations;

namespace EHealthMonitoringSystemBackend.Core.Models;

public class PatientProfile
{
    [Key]
    public int Id { get; set; }

    [Required]
    public string? FirstName { get; set; }

    [Required]
    public string? LastName { get; set; }

    [Required]
    public string? PhoneNumber { get; set; }

    [Required]
    public string? Cnp { get; set; }
}
