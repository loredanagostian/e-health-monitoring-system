using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using EHealthMonitoringSystemBackend.Api.Models;
using EHealthMonitoringSystemBackend.Api.Services.Abstractions;
using Microsoft.IdentityModel.Tokens;

namespace EHealthMonitoringSystemBackend.Api.Services;

public class JWTManager(IConfiguration configuration) : IJWTManager
{
    private readonly IConfiguration _configuration = configuration;

    public Token GenerateRefreshToken(string userId)
    {
        return GenerateToken(userId);
    }

    public string GenerateRefreshToken()
    {
        var randomNumber = new byte[32];
        using var rng = RandomNumberGenerator.Create();
        rng.GetBytes(randomNumber);
        return Convert.ToBase64String(randomNumber);
    }

    public Token GenerateToken(string userId)
    {
        var tokenHandler = new JwtSecurityTokenHandler();
        var tokenKey = Convert.FromBase64String(_configuration["JWT:Key"]!);
        var tokenDescriptor = new SecurityTokenDescriptor
        {
            Subject = new ClaimsIdentity([new Claim(ClaimTypes.Name, userId)]),
            Expires = DateTime.Now.AddMinutes(15),
            SigningCredentials = new SigningCredentials(
                new SymmetricSecurityKey(tokenKey),
                SecurityAlgorithms.HmacSha256Signature
            ),
        };
        var token = tokenHandler.CreateToken(tokenDescriptor);
        var refreshToken = GenerateRefreshToken();
        return new Token
        {
            AccessToken = tokenHandler.WriteToken(token),
            RefreshToken = refreshToken,
        };
    }

    public ClaimsPrincipal GetPrincipalFromExpiredToken(string token)
    {
        var Key = Convert.FromBase64String(_configuration["JWT:Key"]!);

        var tokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false,
            ValidateAudience = false,
            ValidateLifetime = false,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Key),
            ClockSkew = TimeSpan.Zero,
        };

        var tokenHandler = new JwtSecurityTokenHandler();
        var principal = tokenHandler.ValidateToken(
            token,
            tokenValidationParameters,
            out SecurityToken securityToken
        );

        if (
            securityToken is not JwtSecurityToken jwtSecurityToken
            || !jwtSecurityToken.Header.Alg.Equals(
                SecurityAlgorithms.HmacSha256,
                StringComparison.InvariantCultureIgnoreCase
            )
        )
        {
            throw new SecurityTokenException("Invalid token");
        }

        return principal;
    }
}
