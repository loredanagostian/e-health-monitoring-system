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

    [HttpGet]
    public async Task<IActionResult> GetAll()
    {
        var specializations = (await _specializationRepository.GetAllAsync())
            .Select(s => new SpecializationGetDto
            {
                Id = s.Id,
                Name = s.Name,
                Icon = s.Icon
            });

        return Ok(specializations);
    }

    [HttpPost]
    public async Task<IActionResult> Add([FromBody] SpecializationAddDto dto)
    {
        var specialization = new Specialization
        {
            Name = dto.Name,
            Icon = dto.Icon
        };

        var dbSpecialization = await _specializationRepository.AddUpdateAsync(specialization);

        return Ok(new SpecializationAddDto() {Name = dbSpecialization.Name, Icon = dbSpecialization.Icon});
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

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(string id)
    {
        var deleted = await _specializationRepository.DeleteOneAsync(s => s.Id == id);

        if (deleted is null)
        {
            return BadRequest("Specialization not found!");
        }

        return Ok(new SpecializationGetDto
        {
            Id = deleted.Id,
            Icon = deleted.Icon,
            Name = deleted.Name
        });
    }
    
    [HttpPatch]
    public async Task<IActionResult> Update([FromBody] SpecializationGetDto dto)
    {
        var specialization = new Specialization
        {
            Id = dto.Id,
            Name = dto.Name,
            Icon = dto.Icon
        };

        var existing = await _specializationRepository.GetOneAsync(s => s.Id == dto.Id);
        if (existing is null)
        {
            return BadRequest("Specialization not found!");
        }

        var dbSpecialization = await _specializationRepository.AddUpdateAsync(specialization);
        return Ok(new SpecializationGetDto() {Id = dbSpecialization.Id, Name = dbSpecialization.Name, Icon = dbSpecialization.Icon});
    }
}