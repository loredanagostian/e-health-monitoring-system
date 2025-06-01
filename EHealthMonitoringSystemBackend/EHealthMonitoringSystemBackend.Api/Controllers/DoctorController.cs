using EHealthMonitoringSystemBackend.Api.Dtos;
using EHealthMonitoringSystemBackend.Api.Models;
using EHealthMonitoringSystemBackend.Api.Services.Abstractions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EHealthMonitoringSystemBackend.Api.Controllers;

[ApiController]
[Route("api/[controller]/[action]")]
public class DoctorController : ControllerBase
{
    private readonly IDoctorRepository _doctorRepository;
    private readonly ISpecializationRepository _specializationRepository;
    private readonly IDoctorSpecializationsRepository _doctorSpecializationsRepository;
    private readonly IAppointmentTypeRepository _appointmentTypeRepository;
    private readonly IUploadManager _uploadManager;
    private readonly IConfiguration _configuration;
    private readonly ILogger<DoctorController> _logger;
    private readonly IJWTManager _jwtManager;

    public DoctorController(
        ILogger<DoctorController> logger,
        IDoctorRepository doctorRepository,
        ISpecializationRepository specializationRepository,
        IDoctorSpecializationsRepository doctorSpecializationsRepository,
        IAppointmentTypeRepository appointmentTypeRepository,
        IUploadManager uploadManager,
        IConfiguration configuration,
        IJWTManager jwtManager
    )
    {
        _doctorRepository = doctorRepository;
        _specializationRepository = specializationRepository;
        _doctorSpecializationsRepository = doctorSpecializationsRepository;
        _appointmentTypeRepository = appointmentTypeRepository;
        _uploadManager = uploadManager;
        _configuration = configuration;
        _logger = logger;
        _jwtManager = jwtManager;
    }

    [HttpPost]
    // [Authorize(Roles = "Admin")]
    public async Task<IActionResult> Add([FromForm] DoctorPostDto doctorPost, IFormFile file)
    {
        // TODO: better checking, automatic auth ?
        string? accessToken = null;
        if (Request.Cookies.ContainsKey("access-token"))
        {
            accessToken = Request.Cookies["access-token"];
        }

        string? refreshToken = null;
        if (Request.Cookies.ContainsKey("refresh-token"))
        {
            refreshToken = Request.Cookies["refresh-token"];
        }

        var token = new Token { AccessToken = accessToken, RefreshToken = refreshToken };
        if (token.AccessToken is null)
        {
            return Unauthorized(new { msg = "Invalid JWT token." });
        }

        var principal = _jwtManager.GetPrincipalFromToken(token.AccessToken);
        var userId = principal.Identity?.Name;
        if (userId is null)
        {
            return Unauthorized(new { msg = "User id not registered." });
        }

        var appFile = await _uploadManager.Upload(file);

        if (appFile is null)
            return BadRequest("File upload failed!");

        var doctor = new Doctor
        {
            Id = userId,
            Name = doctorPost.Name,
            Description = doctorPost.Description,
            PictureId = appFile.Id,
        };

        var dbDoctor = await _doctorRepository.AddAsync(doctor);

        return Ok(
            new DoctorDto
            {
                Name = dbDoctor.Name,
                Description = dbDoctor.Description,
                Picture = appFile.Path,
            }
        );
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var doctorDtos = new List<DoctorDto> { };

        var doctors = await _doctorRepository.GetAllAsync();

        foreach (var doctor in doctors)
        {
            var doctorDto = await _getDoctorDto(doctor);
            doctorDtos.Add(doctorDto);
        }

        return Ok(doctorDtos);
    }

    [HttpGet("{specializationId}")]
    public async Task<IActionResult> GetAllBySpecialization(string specializationId)
    {
        var doctorDtos = new List<DoctorDto> { };

        var doctorIds = (
            await _doctorSpecializationsRepository.GetAllByAsync(ds =>
                ds.SpecializationId == specializationId
            )
        ).Select(ds => ds.DoctorId);

        var doctors = await _doctorRepository.GetAllByAsync(d => doctorIds.Contains(d.Id));

        foreach (var doctor in doctors)
        {
            var doctorDto = await _getDoctorDto(doctor);
            doctorDtos.Add(doctorDto);
        }

        return Ok(doctorDtos);
    }

    private async Task<DoctorDto> _getDoctorDto(Doctor doctor)
    {
        var baseUrl = _configuration["Base_url"];

        var doctorDto = new DoctorDto
        {
            Id = doctor.Id,
            Name = doctor.Name,
            Description = doctor.Description,
            Picture = doctor.Picture.Path.Replace("../", baseUrl),
        };

        var doctorSpecializationIds = (
            await _doctorSpecializationsRepository.GetAllByAsync(ds => ds.DoctorId == doctor.Id)
        ).Select(ds => ds.SpecializationId);

        var specializations = (
            await _specializationRepository.GetAllByAsync(s =>
                doctorSpecializationIds.Contains(s.Id)
            )
        ).Select(s => new SpecializationGetDto()
        {
            Id = s.Id,
            Name = s.Name,
            Icon = s.Icon,
        });

        doctorDto.Specializations = specializations;

        var appointmentTypes = (
            await _appointmentTypeRepository.GetAllByAsync(at => at.DoctorId == doctor.Id)
        ).Select(at => new AppointmentTypeDto
        {
            Id = at.Id,
            Name = at.Name,
            Price = at.Price,
        });

        doctorDto.AppointmentTypes = appointmentTypes;

        return doctorDto;
    }
}
