using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EHealthMonitoringSystemBackend.Core.Models;

public class Appointment
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string Id { get; set; }
    public int TotalCost { get; set; }
    public DateTime Date { get; set; }
    [ForeignKey("AppointmentTypeId")]
    public AppointmentType AppointmentType { get; set; }
    public string AppointmentTypeId { get; set; }
    public User User { get; set; }
    [ForeignKey("UserId")]
    public string UserId { get; set; }
    
    public string? MedicalHistory { get; set; }
    public string? Diagnostic { get; set; }
    public string? Recommendation { get; set; }
}