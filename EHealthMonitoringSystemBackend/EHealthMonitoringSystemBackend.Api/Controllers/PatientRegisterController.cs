using System.Buffers.Text;
using System.Text;
using System.Text.Encodings.Web;
using EHealthMonitoringSystemBackend.Api.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.VisualBasic;

namespace EHealthMonitoringSystemBackend.Api.Controllers;
// TODO: trash error checking, should be better 

[ApiController]
[Route("api/[controller]/[action]")]
[AllowAnonymous]
public class RegisterController(
    SignInManager<IdentityUser> signInManager,
    IEmailSender emailSender,
    UserManager<IdentityUser> userManger,
    IUserStore<IdentityUser> userStore,
    ILogger<PatientRegister> logger
) : ControllerBase
{
    private readonly SignInManager<IdentityUser> _signInManager = signInManager;
    private readonly IEmailSender _emailSender = emailSender;
    private readonly UserManager<IdentityUser> _userManger = userManger;
    private readonly IUserStore<IdentityUser> _userStore = userStore;
    private readonly ILogger<PatientRegister> _logger = logger;

    private const string MSG_501 = "Ooops! Something went wrong, please try again later.";

    [HttpPost]
    public async Task<IActionResult> SignUpPatient(PatientRegister newPatient)
    {
        if (newPatient.Email is null || newPatient.Passwd is null)
        {
            return BadRequest();
        }

        var emailStore = (IUserEmailStore<IdentityUser>)_userStore;
        var user = await _userManger.FindByEmailAsync(newPatient.Email);
        if (user != null)
        {
            return Conflict(new { msg = "Email is already taken." });
        }
        var newUser = Activator.CreateInstance<IdentityUser>();

        await emailStore.SetEmailAsync(newUser, newPatient.Email, CancellationToken.None);
        await _userStore.SetUserNameAsync(newUser, newPatient.Email, CancellationToken.None);

        var result = await _userManger.CreateAsync(newUser, newPatient.Passwd);
        if (!result.Succeeded)
        {
            _logger.LogError("Failed to register user with errors {}", result.Errors.Select(e => e.Description));
            return StatusCode(StatusCodes.Status500InternalServerError, new { msg = MSG_501 });
        }

        var userId = await _userManger.GetUserIdAsync(newUser);
        var code = await _userManger.GenerateEmailConfirmationTokenAsync(newUser);
        code = WebEncoders.Base64UrlEncode(Encoding.UTF8.GetBytes(code));
        var callbackUrl = Url.Action("ConfirmEmail", "Register", new { userId, code }, protocol: Request.Scheme);
        // TODO: !!!temp until hosted, requests from android use 10.0.0.2 ip
        callbackUrl = $"http://localhost:5200/api/Register/ConfirmEmail?userId={userId}&code={code}";
        await _emailSender.SendEmailAsync(
            newPatient.Email,
            "Confirm your email",
            $"Please confirm your account by <a href='{HtmlEncoder.Default.Encode(callbackUrl!)}'>clicking here</a>."
            );

        _logger.LogInformation("Created new user");

        return CreatedAtAction("Patient registered", new { userId });
    }

    [HttpPost]
    public async Task<IActionResult> SignInPatient(PatientRegister patient)
    {
        if (patient.Email is null || patient.Passwd is null)
        {
            return BadRequest(new { msg = "Missing username or password." });
        }

        var user = await _userManger.FindByEmailAsync(patient.Email);
        if (user is null)
        {
            return Unauthorized(new { msg = "Wrong username or password." });
        }

        if (!await _userManger.CheckPasswordAsync(user, patient.Passwd))
        {
            return Unauthorized(new { msg = "Wrong username or password." });
        }

        if (!await _userManger.IsEmailConfirmedAsync(user))
        {
            return Unauthorized(new { msg = "Please confirm your email address." });
        }

        var result = await _signInManager.PasswordSignInAsync(patient.Email, patient.Passwd, true, false);
        if (!result.Succeeded)
        {
            string msg = "";
            if (result.IsLockedOut)
            {
                msg = "Your account is currently locked.";
            }
            else
            if (result.IsNotAllowed)
            {
                msg = "Your account is not allowed to sign in";
            }
            else if (result.RequiresTwoFactor)
            {
                msg = "Your account requires two factor authentication.";
            }
            return Unauthorized(new { msg });
        }

        return StatusCode(StatusCodes.Status200OK);
    }

    [HttpGet]
    public async Task<IActionResult> ConfirmEmail(string userId, string code)
    {
        var user = await _userManger.FindByIdAsync(userId);
        if (user is null)
        {
            return NotFound("User not registered.");
        }

        code = Encoding.UTF8.GetString(WebEncoders.Base64UrlDecode(code));
        var result = await _userManger.ConfirmEmailAsync(user, code);
        if (!result.Succeeded)
        {
            _logger.LogError("Failed to confirm email with error {}", result.Errors.Select(e => e.Description));
            return StatusCode(StatusCodes.Status500InternalServerError, new { msg = MSG_501 });
        }

        // TODO: this should return a nice page
        return NoContent();
    }

    [HttpPost]
    public async Task<IActionResult> CheckEmailStatus(string userId)
    {
        var user = await _userManger.FindByIdAsync(userId);
        if (user is null)
        {
            return NotFound("User ID not found.");
        }
        _logger.LogInformation("Checking email for {}", userId);

        var isEmailConfirmed = await _userManger.IsEmailConfirmedAsync(user);
        return StatusCode(StatusCodes.Status200OK, new { isEmailConfirmed });
    }

}