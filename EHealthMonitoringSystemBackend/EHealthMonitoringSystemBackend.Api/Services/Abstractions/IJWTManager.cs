using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using EHealthMonitoringSystemBackend.Api.Models;
using Microsoft.IdentityModel.Tokens;

namespace EHealthMonitoringSystemBackend.Api.Services.Abstractions;

public interface IJWTManager
{
    Token GenerateToken(string userId);
    Token GenerateRefreshToken(string userId);
    ClaimsPrincipal GetPrincipalFromToken(string token);
    ClaimsPrincipal GetPrincipalFromToken(JwtSecurityToken token);
}
