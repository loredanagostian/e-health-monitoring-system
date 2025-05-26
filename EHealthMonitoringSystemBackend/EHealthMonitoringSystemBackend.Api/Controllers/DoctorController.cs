using EHealthMonitoringSystemBackend.Api.Dtos;
using EHealthMonitoringSystemBackend.Api.Services.Abstractions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
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
    
    public DoctorController(IDoctorRepository doctorRepository, ISpecializationRepository specializationRepository,
        IDoctorSpecializationsRepository doctorSpecializationsRepository, IAppointmentTypeRepository appointmentTypeRepository, IUploadManager uploadManager, IConfiguration configuration)
    {
        _doctorRepository = doctorRepository;
        _specializationRepository = specializationRepository;
        _doctorSpecializationsRepository = doctorSpecializationsRepository;
        _appointmentTypeRepository = appointmentTypeRepository;
        _uploadManager = uploadManager;
        _configuration = configuration;
    }

    [HttpPost]
    public async Task<IActionResult> Add([FromForm] DoctorPostDto doctorPost, IFormFile file)
    {
        var appFile = await _uploadManager.Upload(file);

        if (appFile is null) return BadRequest("File upload failed!");

        var doctor = new Doctor
        {
            Name = doctorPost.Name,
            Description = doctorPost.Description,
            PictureId = appFile.Id
        };

        var dbDoctor = await _doctorRepository.AddAsync(doctor);

        return Ok(new DoctorDto {Name = dbDoctor.Name, Description = dbDoctor.Description, Picture = appFile.Path});
    }

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var doctorDtos = new List<DoctorDto>{};
        
        var doctors = await _doctorRepository.GetAllAsync();

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

        var doctorSpecializationIds = (await _doctorSpecializationsRepository
                .GetAllByAsync(ds => ds.DoctorId == doctor.Id))
            .Select(ds => ds.SpecializationId);

        var specializations = (await _specializationRepository
                .GetAllByAsync(s => doctorSpecializationIds.Contains(s.Id)))
            .Select(s => new SpecializationDto {Name = s.Name});

        doctorDto.Specializations = specializations;

        var appointmentTypes = (await _appointmentTypeRepository
                .GetAllByAsync(at => at.DoctorId == doctor.Id))
            .Select(at => new AppointmentTypeDto {Id = at.Id, Name = at.Name, Price = at.Price});

        doctorDto.AppointmentTypes = appointmentTypes;

        return doctorDto;
    }
}