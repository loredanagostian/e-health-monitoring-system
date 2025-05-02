using EHealthMonitoringSystemBackend.Data.Models;

namespace EHealthMonitoringSystemBackend.Data.Services;

public interface ITokenRepository
{
    Task<UserRefreshToken> SetRefreshToken(User user, UserRefreshToken refreshToken);

    Task DeleteRefreshToken(User user);
}
