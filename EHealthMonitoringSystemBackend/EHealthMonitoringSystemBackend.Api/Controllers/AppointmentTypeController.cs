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

    public AppointmentTypeController(IAppointmentTypeRepository appointmentTypeRepository, IDoctorRepository doctorRepository)
    {
        _appointmentTypeRepository = appointmentTypeRepository;
        _doctorRepository = doctorRepository;
    }

    [HttpPost]
    public async Task<IActionResult> Add([FromBody] AppointmentTypePostDto appointmentTypeDto)
    {
        var existingDoctor = await _doctorRepository.GetOneAsync(d => d.Id == appointmentTypeDto.DoctorId);
        if (existingDoctor is null) return NotFound("Doctor not found!");

        var appointmentType = new AppointmentType
        {
            Name = appointmentTypeDto.Name,
            Price = appointmentTypeDto.Price,
            DoctorId = appointmentTypeDto.DoctorId
        };

        var dbAppointmentType = await _appointmentTypeRepository.AddAsync(appointmentType);

        return Ok(new AppointmentTypePostDto {Name = dbAppointmentType.Name, Price = dbAppointmentType.Price, DoctorId = dbAppointmentType.DoctorId});
    }
}