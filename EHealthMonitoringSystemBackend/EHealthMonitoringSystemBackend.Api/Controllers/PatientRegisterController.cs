using EHealthMonitoringSystemBackend.Api.Models;
using Microsoft.AspNetCore.Http.HttpResults;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;

namespace EHealthMonitoringSystemBackend.Api.Controllers;

[ApiController]
[Route("api/[controller]")]
public class PatientRegisterController(
    SignInManager<IdentityUser> signInManager,
    UserManager<IdentityUser> userManger,
    IUserStore<IdentityUser> userStore,
    ILogger<PatientRegister> logger
) : ControllerBase
{
    private readonly SignInManager<IdentityUser> _signInManager = signInManager;
    private readonly UserManager<IdentityUser> _userManger = userManger;
    private readonly IUserStore<IdentityUser> _userStore = userStore;
    private readonly ILogger<PatientRegister> _logger = logger;

    [HttpPost]
    public async Task<IActionResult> RegisterUser(PatientRegister newPatient)
    {
        if (newPatient.Email is null || newPatient.Passwd is null)
        {
            return BadRequest();
        }

        var emailStore = (IUserEmailStore<IdentityUser>)_userStore;

        var newUser = Activator.CreateInstance<IdentityUser>();
        await emailStore.SetEmailAsync(newUser, newPatient.Email, CancellationToken.None);
        await _userStore.SetUserNameAsync(newUser, newPatient.Email, CancellationToken.None);
        var result = await _userManger.CreateAsync(newUser, newPatient.Passwd);
        if (!result.Succeeded)
        {
            var errors = new List<string>();
            foreach (var error in result.Errors)
            {
                errors.Add(error.Description);
            }
            return StatusCode(
                StatusCodes.Status500InternalServerError,
                new {
                    msg = "Failed to register patient",
                    errors
                }
            );
        }

        var userId = await _userManger.GetUserIdAsync(newUser);
        var confirmCode = await _userManger.GenerateEmailConfirmationTokenAsync(newUser);

        _logger.LogInformation("Create user with id: {}", userId);
        _logger.LogInformation("Generated confirm code {}", confirmCode);

        return CreatedAtAction("Patient registered", new { username = newPatient.Email });
    }
}