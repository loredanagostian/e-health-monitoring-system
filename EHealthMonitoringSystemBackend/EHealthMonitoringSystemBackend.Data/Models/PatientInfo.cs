using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Identity;

namespace EHealthMonitoringSystemBackend.Data.Models;

public class PatientInfo
{
    [Required]
    public string? Id { get; set; }
    [Required]
    public string? FirstName { get; set; }
    [Required]
    public string? LastName { get; set; }
    [Required]
    public string? PhoneNumber { get; set; }
    [Required]
    public string? Cnp { get; set; }
    public virtual IdentityUser? AspNetUser { get; set; }
}