using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EHealthMonitoringSystemBackend.Core.Models;

public class DoctorSpecialization
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string Id { get; set; }
    public string DoctorId { get; set; }
    [ForeignKey("DoctorId")]
    public Doctor Doctor { get; set; }
    public string SpecializationId { get; set; }
    [ForeignKey("SpecializationId")]
    public Specialization Specialization { get; set; }
}