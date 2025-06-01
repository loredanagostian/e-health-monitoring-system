using System.Security.Cryptography;
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

    [HttpGet("{doctorId}")]
    public async Task<IActionResult> GetSpecializationsByDoctor(string doctorId)
    {
        var doctor = await _doctorRepository.GetOneAsync(d => d.Id == doctorId);
        if (doctor is null)
            return NotFound("Doctor not found!");

        var doctorSpecializations = await _doctorSpecializationsRepository.GetAllByAsync(ds => ds.DoctorId == doctorId);

        var specializations = doctorSpecializations
            .Select(ds => ds.Specialization)
            .Where(s => s != null)
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

        var specialization = await _specializationRepository.GetOneAsync(s => s.Name == dto.SpecializationName);
        if (specialization is null) return NotFound("Specialization not found!");

        var dbDoctorSpecialization =
            await _doctorSpecializationsRepository.AddSpecializationToDoctorAsync(dto.DoctorId, specialization.Id);

        return Ok(new DoctorSpecializationDto
            {DoctorId = dbDoctorSpecialization.DoctorId, SpecializationName = specialization.Id});
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

    [HttpDelete("{doctorId}/{specializationId}")]
    public async Task<IActionResult> DeleteFromDoctor(string doctorId, string specializationId)
    {
        var deleted = await _doctorSpecializationsRepository
            .DeleteOneAsync(s => s.DoctorId == doctorId && s.SpecializationId == specializationId);

        if (deleted is null)
        {
            return BadRequest("Specialization not found!");
        }

        return Ok(new DoctorSpecializationDto
        {
            DoctorId = deleted.DoctorId,
            SpecializationName = deleted.SpecializationId
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