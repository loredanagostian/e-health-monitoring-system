using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace EHealthMonitoringSystemBackend.Core.Models;

public class AppFile
{
    [Key]
    [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
    public string Id { get; set; }
    public string Name { get; set; }
    public string Path { get; set; }
    public string Extension { get; set; }
    public string OriginalName { get; set; }
    public DateTime Created { get; set; }
    public DateTime Updated { get; set; }
}