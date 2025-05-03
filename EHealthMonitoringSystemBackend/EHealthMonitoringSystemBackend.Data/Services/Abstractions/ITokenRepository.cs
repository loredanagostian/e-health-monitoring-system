using EHealthMonitoringSystemBackend.Core.Models;

namespace EHealthMonitoringSystemBackend.Data.Services.Abstractions;

public interface ITokenRepository
{
    Task<UserRefreshToken> SetRefreshToken(User user, UserRefreshToken refreshToken);

    Task DeleteRefreshToken(User user);
}
