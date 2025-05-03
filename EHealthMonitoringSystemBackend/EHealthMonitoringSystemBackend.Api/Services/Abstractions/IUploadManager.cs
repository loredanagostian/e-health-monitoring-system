using EHealthMonitoringSystemBackend.Core.Models;

namespace EHealthMonitoringSystemBackend.Api.Services.Abstractions;

public interface IUploadManager
{
    Task<AppFile> Upload(IFormFile file);
}