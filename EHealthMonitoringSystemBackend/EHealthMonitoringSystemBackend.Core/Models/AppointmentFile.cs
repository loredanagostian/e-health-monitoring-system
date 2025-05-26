using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EHealthMonitoringSystemBackend.Core.Models;

public class AppointmentFile
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string Id { get; set; }
    
    [ForeignKey("FileId")]
    public AppFile File { get; set; }
    public string FileId { get; set; }
    
    [ForeignKey("AppointmentId")]
    public Appointment Appointment { get; set; }
    public string AppointmentId { get; set; }
}