using EHealthMonitoringSystemBackend.Api.Models;
using EHealthMonitoringSystemBackend.Api.Services.Abstractions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace EHealthMonitoringSystemBackend.Api.Controllers;

[ApiController]
[Route("api/[controller]/[action]")]
[Authorize]
public class PatientController(
    UserManager<User> userManger,
    ILogger<PatientRegister> logger,
    IJWTManager jwtManager
) : ControllerBase
{
    private readonly UserManager<User> _userManger = userManger;
    private readonly ILogger<PatientRegister> _logger = logger;
    private readonly IJWTManager _jwtManager = jwtManager;

    [HttpPost]
    public async Task<IActionResult> CompleteProfile(PatientProfileDTO profile)
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
            return Unauthorized("Missing JWT Token.");
        }

        // TODO: this can be simplified maybe, just use user id from token? maybe there is no need to verify that user exists ?
        var principal = _jwtManager.GetPrincipalFromToken(jwtToken);
        var user = await _userManger.FindByIdAsync(principal.Identity!.Name!);
        if (user is null)
        {
            return Unauthorized("Invalid user id");
        }

        user.PatientProfile = new PatientProfile
        {
            FirstName = profile.FirstName,
            LastName = profile.LastName,
            Cnp = profile.Cnp,
            PhoneNumber = profile.PhoneNumber,
        };
        await _userManger.UpdateAsync(user);

        return Ok();
    }
}
