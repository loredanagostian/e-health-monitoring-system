using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EHealthMonitoringSystemBackend.Core.Models;

public class Doctor
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string Id { get; set; }
    public string Name { get; set; }
    public string Description { get; set; }
    [ForeignKey("PictureId")]
    public AppFile Picture { get; set; }
    public string PictureId { get; set; }
}