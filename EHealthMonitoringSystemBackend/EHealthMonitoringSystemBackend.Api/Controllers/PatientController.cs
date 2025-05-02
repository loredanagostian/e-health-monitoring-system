using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace EHealthMonitoringSystemBackend.Api.Controllers;

[ApiController]
[Route("api/[controller]/[action]")]
[Authorize]
public class PatientController : ControllerBase
{
    [HttpGet]
    public IActionResult WorksIt()
    {
        return NoContent();
    }
}
