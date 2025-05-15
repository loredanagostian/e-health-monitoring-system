using EHealthMonitoringSystemBackend.Api.Dtos;
using EHealthMonitoringSystemBackend.Api.Services.Abstractions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace EHealthMonitoringSystemBackend.Api.Controllers;

[ApiController]
[Route("api/[controller]/[action]")]
public class AppointmentController : ControllerBase
{
    private readonly IAppointmentRepository _appointmentRepository;
    private readonly IAppointmentFileRepository _appointmentFileRepository;
    private readonly IJWTManager _jwtManager;
    private readonly UserManager<User> _userManger;
    private readonly IUploadManager _uploadManager;
    
    public AppointmentController(IAppointmentRepository appointmentRepository, IJWTManager jwtManager, UserManager<User> userManger,
        IUploadManager uploadManager, IAppointmentFileRepository appointmentFileRepository)
    {
        _appointmentRepository = appointmentRepository;
        _jwtManager = jwtManager;
        _userManger = userManger;
        _uploadManager = uploadManager;
        _appointmentFileRepository = appointmentFileRepository;
    }

    [Authorize]
    [HttpPost]
    public async Task<IActionResult> Add([FromBody] AppointmentCreateDto appointmentDto)
    {
        var user = await _getUser();
        if (user is null)
        {
            return Unauthorized();
        }

        var newAppointment = new Appointment
        {
            TotalCost = appointmentDto.TotalCost,
            Date = appointmentDto.Date,
            AppointmentTypeId = appointmentDto.AppointmentTypeId,
            UserId = user.Id
        };

        var dbAppointment = await _appointmentRepository.AddUpdateAsync(newAppointment);
        return Ok(dbAppointment);
    }

    [Authorize]
    [HttpPatch]
    public async Task<IActionResult> Update(
        [FromForm] List<IFormFile> files,
        [FromForm] AppointmentUpdateDto appointmentDto)
    {
        var existingAppointment = await _appointmentRepository.GetOneAsync(a => a.Id == appointmentDto.Id);
        if (existingAppointment is null)
        {
            return BadRequest("Appointment not found!");
        }
        
        var user = await _getUser();
        if (user is null)
        {
            return Unauthorized();
        }
        if (user.Id != existingAppointment.UserId)
        {
            return Unauthorized("User cannot perform this action!");
        }

        var appointmentFiles = new List<AppointmentFile>();
        foreach (var file in files)
        {
            var appFile = await _uploadManager.Upload(file);
            if (appFile is null)
            {
                return BadRequest("File upload failed");
            }

            var appointmentFile = new AppointmentFile
            {
                AppointmentId = appointmentDto.Id,
                FileId = appFile.Id
            };
            appointmentFiles.Add(appointmentFile);
        }

        await _appointmentFileRepository.AddAsync(appointmentFiles);

        existingAppointment.MedicalHistory = appointmentDto.MedicalHistory;
        existingAppointment.Diagnostic = appointmentDto.Diagnostic;
        existingAppointment.Recommendation = appointmentDto.Recommendation;

        var dbAppointment = await _appointmentRepository.AddUpdateAsync(existingAppointment);
        return Ok(dbAppointment);
    }

    private async Task<User?> _getUser()
    {
        string? jwtToken = null;
        foreach (var header in Request.Headers.Authorization)
        {
            if (header is not null && header.Contains("Bearer"))
            {
                jwtToken = header.Replace("Bearer", "").Trim();
                break;
            }
        }

        if (jwtToken is null)
        {
            return null;
        }

        var principal = _jwtManager.GetPrincipalFromToken(jwtToken);
        var user = await _userManger.FindByIdAsync(principal.Identity!.Name!);
        return user;
    }
}