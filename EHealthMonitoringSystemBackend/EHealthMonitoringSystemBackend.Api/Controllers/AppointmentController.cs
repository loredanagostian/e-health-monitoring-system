using EHealthMonitoringSystemBackend.Api.Dtos;
using EHealthMonitoringSystemBackend.Api.Services.Abstractions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace EHealthMonitoringSystemBackend.Api.Controllers;

[ApiController]
[Authorize]
[Route("api/[controller]/[action]")]
public class AppointmentController : ControllerBase
{
    private readonly IAppointmentRepository _appointmentRepository;
    private readonly IAppointmentTypeRepository _appointmentTypeRepository;
    private readonly IAppointmentFileRepository _appointmentFileRepository;
    private readonly IJWTManager _jwtManager;
    private readonly UserManager<User> _userManger;
    private readonly IUploadManager _uploadManager;
    private readonly IConfiguration _configuration;

    public AppointmentController(
        IAppointmentRepository appointmentRepository,
        IJWTManager jwtManager,
        UserManager<User> userManger,
        IUploadManager uploadManager,
        IAppointmentFileRepository appointmentFileRepository,
        IConfiguration configuration,
        IAppointmentTypeRepository appointmentTypeRepository
    )
    {
        _appointmentRepository = appointmentRepository;
        _jwtManager = jwtManager;
        _userManger = userManger;
        _uploadManager = uploadManager;
        _appointmentFileRepository = appointmentFileRepository;
        _configuration = configuration;
        _appointmentTypeRepository = appointmentTypeRepository;
    }

    [HttpPost]
    public async Task<IActionResult> Add([FromBody] AppointmentCreateDto appointmentDto)
    {
        var user = await _getUser();
        if (user is null)
        {
            return Unauthorized();
        }

        var appointmentType = await _appointmentTypeRepository.GetOneAsync(at =>
            at.Id == appointmentDto.AppointmentTypeId
        );
        if (appointmentType == null)
        {
            return BadRequest("Appointment Type not found!");
        }

        var existingAppointmentTypeIds = (
            await _appointmentTypeRepository.GetAllByAsync(at =>
                at.DoctorId == appointmentType.DoctorId
            )
        ).Select(at => at.Id);

        var existingAppointments = await _appointmentRepository.GetAsync(a =>
            existingAppointmentTypeIds.Contains(a.AppointmentTypeId)
        );

        foreach (var appointment in existingAppointments)
        {
            if (Math.Abs((appointment.Date - appointmentDto.Date).TotalMinutes) <= 15)
            {
                return BadRequest("Cannot make an appointment at that time!");
            }
        }

        var newAppointment = new Appointment
        {
            TotalCost = appointmentDto.TotalCost,
            Date = appointmentDto.Date,
            AppointmentTypeId = appointmentDto.AppointmentTypeId,
            UserId = user.Id,
        };

        var dbAppointment = await _appointmentRepository.AddUpdateAsync(newAppointment);
        return Ok(dbAppointment);
    }

    [HttpPatch]
    public async Task<IActionResult> Update(
        [FromForm] List<IFormFile> files,
        [FromForm] AppointmentUpdateDto appointmentDto
    )
    {
        var existingAppointment = await _appointmentRepository.GetOneAsync(a =>
            a.Id == appointmentDto.Id
        );
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
                FileId = appFile.Id,
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

    [HttpGet]
    public async Task<IActionResult> GetPastVisits()
    {
        var user = await _getUser();
        if (user is null)
        {
            return Unauthorized();
        }

        var baseUrl = _configuration["Base_url"];

        var appointments = (await _appointmentRepository.GetAsync())
            .Where(a => a.UserId == user.Id && a.Date < DateTime.Now)
            .OrderByDescending(a => a.Date)
            .Take(3)
            .Select(a => new AppointmentGetAllDto
            {
                Id = a.Id,
                Date = a.Date,
                AppointmentType = a.AppointmentType.Name,
                DoctorName = a.AppointmentType.Doctor.Name,
                DoctorPicture = a.AppointmentType.Doctor.Picture.Path.Replace("../", baseUrl),
            });

        return Ok(appointments);
    }

    [HttpGet]
    public async Task<IActionResult> GetFutureAppointments()
    {
        var user = await _getUser();
        if (user is null)
        {
            return Unauthorized();
        }

        var baseUrl = _configuration["Base_url"];

        var appointments = (await _appointmentRepository.GetAsync())
            .Where(a => a.UserId == user.Id && a.Date >= DateTime.Now)
            .OrderBy(a => a.Date)
            .Select(a => new AppointmentGetAllDto
            {
                Id = a.Id,
                Date = a.Date,
                AppointmentType = a.AppointmentType.Name,
                DoctorName = a.AppointmentType.Doctor.Name,
                DoctorPicture = a.AppointmentType.Doctor.Picture.Path.Replace("../", baseUrl),
            });

        return Ok(appointments);
    }

    [HttpGet("{id}")]
    public async Task<IActionResult> GetById(string id)
    {
        var appointment = await _appointmentRepository.GetByIdAsync(id);

        if (appointment is null)
            return NotFound();

        var baseUrl = _configuration["Base_url"];

        return Ok(
            new AppointmentGetOneDto
            {
                Id = appointment.Id,
                Date = appointment.Date,
                AppointmentType = appointment.AppointmentType.Name,
                DoctorName = appointment.AppointmentType.Doctor.Name,
                DoctorPicture = appointment.AppointmentType.Doctor.Picture.Path.Replace(
                    "../",
                    baseUrl
                ),
                MedicalHistory = appointment.MedicalHistory,
                Diagnostic = appointment.Diagnostic,
                Recommendation = appointment.Recommendation,
                TotalCost = appointment.TotalCost,
            }
        );
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

    [HttpGet("{doctorId}")]
    public async Task<IActionResult> GetBookedTimeSlots(string doctorId)
    {
        var user = await _getUser();
        if (user is null)
        {
            return Unauthorized();
        }

        var types = await _appointmentTypeRepository.GetAllByAsync(t => t.DoctorId == doctorId);
        var typeIds = new HashSet<string>();
        foreach (var type in types)
        {
            typeIds.Add(type.Id);
        }
        var appointments = await _appointmentRepository.GetAsync(a =>
            typeIds.Contains(a.AppointmentTypeId)
        );

        var timeSlots = new List<string>();
        foreach (var app in appointments)
        {
            timeSlots.Add(
                app.Date.ToString("s", System.Globalization.CultureInfo.InvariantCulture)
            );
        }

        return Ok(new { timeSlots });
    }
}
