using EHealthMonitoringSystemBackend.Api.Dtos;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.AspNetCore.Mvc;

namespace EHealthMonitoringSystemBackend.Api.Controllers;

[ApiController]
[Route("api/[controller]/[action]")]
public class SpecializationController : ControllerBase
{
    private readonly ISpecializationRepository _specializationRepository;
    private readonly IDoctorSpecializationsRepository _doctorSpecializationsRepository;
    private readonly IDoctorRepository _doctorRepository;

    public SpecializationController(ISpecializationRepository specializationRepository,
        IDoctorSpecializationsRepository doctorSpecializationsRepository, IDoctorRepository doctorRepository)
    {
        _specializationRepository = specializationRepository;
        _doctorSpecializationsRepository = doctorSpecializationsRepository;
        _doctorRepository = doctorRepository;
    }

    [HttpPost]
    public async Task<IActionResult> Add([FromBody] SpecializationDto dto)
    {
        var specialization = new Specialization
        {
            Name = dto.Name
        };

        var dbSpecialization = await _specializationRepository.AddAsync(specialization);

        return Ok(new SpecializationDto {Name = dbSpecialization.Name});
    }

    [HttpPost]
    public async Task<IActionResult> AddToDoctor([FromBody] DoctorSpecializationDto dto)
    {
        var existingDoctor = await _doctorRepository.GetOneAsync(d => d.Id == dto.DoctorId);
        if (existingDoctor is null) return NotFound("Doctor not found!");

        var existingSpecialization = await _specializationRepository.GetOneAsync(s => s.Id == dto.SpecializationId);
        if (existingSpecialization is null) return NotFound("Specialization not found!");

        var dbDoctorSpecialization =
            await _doctorSpecializationsRepository.AddSpecializationToDoctorAsync(dto.DoctorId, dto.SpecializationId);

        return Ok(new DoctorSpecializationDto
            {DoctorId = dbDoctorSpecialization.DoctorId, SpecializationId = dbDoctorSpecialization.SpecializationId});
    }
}