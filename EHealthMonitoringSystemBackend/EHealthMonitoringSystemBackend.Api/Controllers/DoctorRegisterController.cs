using System.Text;
using System.Text.Encodings.Web;
using EHealthMonitoringSystemBackend.Api.Models;
using EHealthMonitoringSystemBackend.Api.Services.Abstractions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.WebUtilities;

namespace EHealthMonitoringSystemBackend.Api.Controllers;

// TODO: trash error checking, should be better

[ApiController]
[Route("api/[controller]/[action]")]
[AllowAnonymous]
public class DoctorRegisterController(
    SignInManager<User> signInManager,
    IEmailSender emailSender,
    UserManager<User> userManger,
    IUserStore<User> userStore,
    ILogger<DoctorRegisterController> logger,
    IJWTManager jwtManager,
    ITokenRepository tokenRepository,
    IConfiguration configuration,
    RoleManager<IdentityRole> roleManager
) : ControllerBase
{
    private readonly SignInManager<User> _signInManager = signInManager;
    private readonly IEmailSender _emailSender = emailSender;
    private readonly UserManager<User> _userManger = userManger;
    private readonly IUserStore<User> _userStore = userStore;
    private readonly ILogger<DoctorRegisterController> _logger = logger;
    private readonly IJWTManager _jwtManager = jwtManager;
    private readonly ITokenRepository _tokenRepository = tokenRepository;
    private readonly RoleManager<IdentityRole> _roleManager = roleManager;

    private const string MSG_501 = "Ooops! Something went wrong, please try again later.";

    [HttpPost]
    public async Task<IActionResult> SignUpDoctor(PatientRegister newDoctor)
    {
        if (newDoctor.Email is null || newDoctor.Passwd is null)
        {
            return BadRequest();
        }

        var emailStore = (IUserEmailStore<User>)_userStore;
        var user = await _userManger.FindByEmailAsync(newDoctor.Email);
        if (user != null)
        {
            return Conflict(new { msg = "Email is already taken." });
        }
        var newUser = Activator.CreateInstance<User>();

        await emailStore.SetEmailAsync(newUser, newDoctor.Email, CancellationToken.None);
        await _userStore.SetUserNameAsync(newUser, newDoctor.Email, CancellationToken.None);

        var result = await _userManger.CreateAsync(newUser, newDoctor.Passwd);
        if (!result.Succeeded)
        {
            _logger.LogError(
                "Failed to register user with errors {}",
                result.Errors.Select(e => e.Description)
            );
            return StatusCode(StatusCodes.Status500InternalServerError, new { msg = MSG_501 });
        }

        var userId = await _userManger.GetUserIdAsync(newUser);
        await SendConfirmationEmail(newUser);

        _logger.LogInformation("Created new user");

        return CreatedAtAction(nameof(SignUpDoctor), new { userId });
    }

    private async Task SendConfirmationEmail(User newUser)
    {
        var code = await _userManger.GenerateEmailConfirmationTokenAsync(newUser);
        code = WebEncoders.Base64UrlEncode(Encoding.UTF8.GetBytes(code));
        var callbackUrl = Url.Action(
            "ConfirmEmail",
            "Register",
            new { userId = newUser.Id, code },
            protocol: Request.Scheme
        );

        var baseUrl = configuration["Base_url"];
        // TODO: !!!temp until hosted, requests from android use 10.0.0.2 ip
        callbackUrl = $"{baseUrl}api/DoctorRegister/ConfirmEmail?userId={newUser.Id}&code={code}";
        _logger.LogInformation(callbackUrl);
        // await _emailSender.SendEmailAsync(
        //     newDoctor.Email,
        //     "Confirm your email",
        //     $"Please confirm your account by <a href='{HtmlEncoder.Default.Encode(callbackUrl!)}'>clicking here</a>."
        // );
    }

    [HttpPost]
    public async Task<IActionResult> SignInDoctor(PatientRegister patient)
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

        var result = await _signInManager.PasswordSignInAsync(
            patient.Email,
            patient.Passwd,
            true,
            false
        );
        if (!result.Succeeded)
        {
            string msg = "";
            if (result.IsLockedOut)
            {
                msg = "Your account is currently locked.";
            }
            else if (result.IsNotAllowed)
            {
                msg = "Your account is not allowed to sign in";
            }
            else if (result.RequiresTwoFactor)
            {
                msg = "Your account requires two factor authentication.";
            }
            return Unauthorized(new { msg });
        }

        var token = _jwtManager.GenerateToken(user.Id);

        await _tokenRepository.DeleteRefreshToken(user);
        await _tokenRepository.SetRefreshToken(
            user,
            new UserRefreshToken { RefreshToken = token.RefreshToken }
        );

        // Access token (short-lived)
        Response.Cookies.Append(
            "access-token",
            token.AccessToken!,
            new CookieOptions
            {
                HttpOnly = false,
                Secure = false, // In production
                SameSite = SameSiteMode.Unspecified,
                Path = "/api", // Restrict path
                Expires = DateTimeOffset.UtcNow.AddMinutes(15),
            }
        );

        // Refresh token (long-lived)
        Response.Cookies.Append(
            "refresh-token",
            token.RefreshToken!,
            new CookieOptions
            {
                HttpOnly = false,
                Secure = false, // In production
                SameSite = SameSiteMode.Unspecified,
                Path = "/api", // Restrict path
                Expires = DateTimeOffset.UtcNow.AddDays(15),
            }
        );

        return StatusCode(StatusCodes.Status200OK, new { token });
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
            _logger.LogError(
                "Failed to confirm email with error {}",
                result.Errors.Select(e => e.Description)
            );
            return StatusCode(StatusCodes.Status500InternalServerError, new { msg = MSG_501 });
        }

        if (!await _roleManager.RoleExistsAsync("Admin"))
        {
            await _roleManager.CreateAsync(new IdentityRole("Admin"));
        }

        var addToRoleResult = await _userManger.AddToRoleAsync(user, "Admin");
        if (!addToRoleResult.Succeeded)
        {
            return BadRequest(addToRoleResult.Errors);
        }

        return Ok(new { message = "Email confirmed." });
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

        Token? token = null;
        if (await _userManger.IsEmailConfirmedAsync(user))
        {
            token = _jwtManager.GenerateToken(user.Id);

            await _tokenRepository.DeleteRefreshToken(user);
            await _tokenRepository.SetRefreshToken(
                user,
                new UserRefreshToken { RefreshToken = token.RefreshToken }
            );
        }

        return StatusCode(StatusCodes.Status200OK, new { token });
    }

    [HttpPost]
    public async Task<IActionResult> ResendConfirmationEmail(string userId)
    {
        var user = await _userManger.FindByIdAsync(userId);
        if (user is null)
        {
            return StatusCode(StatusCodes.Status500InternalServerError, new { msg = MSG_501 });
        }

        await SendConfirmationEmail(user);

        return Ok();
    }

    [HttpPost]
    public async Task<IActionResult> RefreshToken()
    {
        string? accessToken = null;
        if (Request.Cookies.ContainsKey("access-token"))
        {
            accessToken = Request.Cookies["access-token"];
        }

        string? refreshToken = null;
        if (Request.Cookies.ContainsKey("refresh-token"))
        {
            refreshToken = Request.Cookies["refresh-token"];
        }

        var token = new Token { AccessToken = accessToken, RefreshToken = refreshToken };
        if (token.AccessToken is null)
        {
            return Unauthorized(new { msg = "Invalid JWT token." });
        }

        var principal = _jwtManager.GetPrincipalFromToken(token.AccessToken);
        var userId = principal.Identity?.Name;
        if (userId is null)
        {
            return Unauthorized(new { msg = "User id not registered." });
        }

        var user = await _userStore.FindByIdAsync(userId, CancellationToken.None);
        if (user is null)
        {
            return Unauthorized(new { msg = "User is not registered." });
        }

        if (user.RefreshToken?.RefreshToken != token.RefreshToken)
        {
            return Unauthorized(new { msg = "Refresh tokens do not match." });
        }

        var newToken = _jwtManager.GenerateRefreshToken(userId);
        if (newToken is null)
        {
            return Unauthorized(new { msg = "Failed to generate user token." });
        }

        await _tokenRepository.DeleteRefreshToken(user);
        await _tokenRepository.SetRefreshToken(
            user,
            new UserRefreshToken { RefreshToken = newToken.RefreshToken! }
        );

        return Ok(new { token = newToken });
    }

    [HttpGet]
    public async Task<IActionResult> Temp()
    {
        string? jwtToken = null;
        if (Request.Cookies.ContainsKey("access-token"))
        {
            jwtToken = Request.Cookies["access-token"];
        }

        if (jwtToken is null)
        {
            return Unauthorized("Missing JWT Token.");
        }
        _logger.LogCritical(jwtToken);

        return Ok(jwtToken);
    }
}
