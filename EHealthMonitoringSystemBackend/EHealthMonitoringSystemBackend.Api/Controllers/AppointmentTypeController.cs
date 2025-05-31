using EHealthMonitoringSystemBackend.Api.Dtos;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.AspNetCore.Mvc;

namespace EHealthMonitoringSystemBackend.Api.Controllers;

[ApiController]
[Route("api/[controller]/[action]")]
public class AppointmentTypeController : ControllerBase
{
    private readonly IAppointmentTypeRepository _appointmentTypeRepository;
    private readonly IDoctorRepository _doctorRepository;

    public AppointmentTypeController(
        IAppointmentTypeRepository appointmentTypeRepository,
        IDoctorRepository doctorRepository
    )
    {
        _appointmentTypeRepository = appointmentTypeRepository;
        _doctorRepository = doctorRepository;
    }

    [HttpPost]
    public async Task<IActionResult> Add([FromBody] AppointmentTypePostDto appointmentTypeDto)
    {
        var existingDoctor = await _doctorRepository.GetOneAsync(d =>
            d.Id == appointmentTypeDto.DoctorId
        );
        if (existingDoctor is null)
            return NotFound("Doctor not found!");

        var appointmentType = new AppointmentType
        {
            Name = appointmentTypeDto.Name,
            Price = appointmentTypeDto.Price,
            DoctorId = appointmentTypeDto.DoctorId,
        };

        var dbAppointmentType = await _appointmentTypeRepository.AddUpdateAsync(appointmentType);

        return Ok(
            new AppointmentTypePostDto
            {
                Id = dbAppointmentType.Id,
                Name = dbAppointmentType.Name,
                Price = dbAppointmentType.Price,
                DoctorId = dbAppointmentType.DoctorId,
            }
        );
    }

    [HttpDelete("{id}")]
    public async Task<IActionResult> Delete(string id)
    {
        var deleted = await _appointmentTypeRepository.DeleteOneAsync(s => s.Id == id);

        if (deleted is null)
        {
            return BadRequest("Specialization not found!");
        }

        return Ok(deleted);
    }
    
    [HttpGet("{doctorId}")]
    public async Task<IActionResult> GetAppointmentsTypesByDoctor(string doctorId)
    {
        var doctor = await _doctorRepository.GetOneAsync(d => d.Id == doctorId);
        if (doctor is null)
            return NotFound("Doctor not found!");

        var dbAppointments = await _appointmentTypeRepository.GetManyAsync(a => a.DoctorId == doctorId);

        var appointmentDtos = dbAppointments.Select(a => new AppointmentTypePostDto
        {
            Id = a.Id,
            Name = a.Name,
            Price = a.Price,
            DoctorId = a.DoctorId,
        });

        return Ok(appointmentDtos);
    }

}
