using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EHealthMonitoringSystemBackend.Core.Models;

public class AppointmentType
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string Id { get; set; }
    public string Name { get; set; }
    public int Price { get; set; }
    [ForeignKey("DoctorId")]
    public Doctor Doctor { get; set; }
    public string DoctorId { get; set; }
}