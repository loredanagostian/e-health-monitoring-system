using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.AspNetCore.Identity;

namespace EHealthMonitoringSystemBackend.Data.Services;

public class TokenRepository(IUserStore<User> userStore, AppDbContext context) : ITokenRepository
{
    private readonly IUserStore<User> _userStore = userStore;
    private readonly AppDbContext _context = context;

    public async Task DeleteRefreshToken(User user)
    {
        if (user.RefreshToken is null)
        {
            return;
        }
        _context.UserRefreshTokens.Attach(user.RefreshToken);
        _context.UserRefreshTokens.Remove(user.RefreshToken);
        await _context.SaveChangesAsync();
    }

    public async Task<UserRefreshToken> SetRefreshToken(User user, UserRefreshToken refreshToken)
    {
        user.RefreshToken = refreshToken;
        await _userStore.UpdateAsync(user, CancellationToken.None);
        return refreshToken;
    }
}
