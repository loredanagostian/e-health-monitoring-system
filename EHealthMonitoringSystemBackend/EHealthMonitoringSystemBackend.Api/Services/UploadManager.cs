using System.Text;
using EHealthMonitoringSystemBackend.Api.Services.Abstractions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data;

namespace EHealthMonitoringSystemBackend.Api.Services;

public class UploadManager : IUploadManager
{
    private readonly AppDbContext _dbContext;
    private readonly string _contentDir;

    public UploadManager(AppDbContext dbContext, IConfiguration configuration)
    {
        _dbContext = dbContext;
        _contentDir = configuration["Content_Directory"];
    }

    public async Task<AppFile> Upload(IFormFile formFile)
    {
        const string subDir = "upload/files";
        var path = Path.Combine(_contentDir, subDir).Replace("\\", "/");
        if (!Directory.Exists(path))
        {
            Directory.CreateDirectory(path);
        }

        var file = new AppFile()
        {
            Name = SanitizeFileName(formFile.FileName) + "_" + GenerateRandomHexString(10),
            Extension = Path.GetExtension(formFile.FileName).Substring(1).ToLower(),
            OriginalName = formFile.FileName,
            Created = DateTime.Now,
            Updated = DateTime.Now,
            Id = Guid.NewGuid().ToString()
        };
        
        var filePath = Path.Combine(path, $"{file.Name}.{file.Extension}").Replace("\\", "/");
        await using (var fileStream = new FileStream(filePath, FileMode.Create))
        {
            await formFile.CopyToAsync(fileStream);
        }

        file.Path = filePath;
        var addedFile = await _dbContext.AppFiles.AddAsync(file);
        await _dbContext.SaveChangesAsync();

        return addedFile.Entity;
    }
    
    private string SanitizeFileName(string fileName)
    {
        var newName = new StringBuilder();
        fileName = Path.GetFileNameWithoutExtension(fileName);
        foreach (var c in fileName)
        {
            newName.Append(Path.GetInvalidFileNameChars().Contains(c) ? '_' : c);
        }

        return newName.ToString();
    }
    
    private string GenerateRandomHexString(int length = 20)
    {
        var str = "";
        while (str.Length < length)
        {
            str += Guid.NewGuid().ToString().ToLower().Replace("-", "");
        }

        return str.Substring(0, length);
    }

}