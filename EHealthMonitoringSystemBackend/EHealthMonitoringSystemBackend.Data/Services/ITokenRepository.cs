using EHealthMonitoringSystemBackend.Data.Models;

namespace EHealthMonitoringSystemBackend.Data.Services;

public interface ITokenRepository
{
    UserRefreshToken SetRefreshToken(User user, UserRefreshToken token);

    UserRefreshToken? GetRefreshToken(User user);

    void DeleteRefreshToken(User user);
}
