using System.Security.Claims;
using EHealthMonitoringSystemBackend.Api.Models;

namespace EHealthMonitoringSystemBackend.Api.Services.Abstractions;

public interface IJWTManager
{
    Token GenerateToken(string userId);
    Token GenerateRefreshToken(string userId);
    ClaimsPrincipal GetPrincipalFromExpiredToken(string token);
}
