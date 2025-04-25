using System.Threading.Tasks;
using EHealthMonitoringSystemBackend.Data.Models;
using Microsoft.AspNetCore.Identity;

namespace EHealthMonitoringSystemBackend.Data.Services;

public class TokenRepository(IUserStore<User> userStore) : ITokenRepository
{
    private readonly IUserStore<User> _userStore = userStore;

    public async void DeleteRefreshToken(User user)
    {
        user.RefreshToken = null;
        await _userStore.UpdateAsync(user, CancellationToken.None);
    }

    public UserRefreshToken SetRefreshToken(User user, UserRefreshToken token)
    {
        user.RefreshToken = token;
        return token;
    }
}
