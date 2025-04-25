using System.Text;
using System.Transactions;
using EHealthMonitoringSystemBackend.Api.Services;
using EHealthMonitoringSystemBackend.Data;
using EHealthMonitoringSystemBackend.Data.Models;
using EHealthMonitoringSystemBackend.Data.Services;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);
var services = builder.Services;
var configuration = builder.Configuration;
builder.WebHost.UseUrls("http://0.0.0.0:5200", "http://localhost:5200");

services.AddControllers();
services.AddSwaggerGen(options =>
{
    options.SwaggerDoc(
        "v1",
        new OpenApiInfo { Title = "E-Health Monitoring System", Version = "V1'" }
    );
    options.AddSecurityDefinition(
        "Bearer",
        new OpenApiSecurityScheme
        {
            In = ParameterLocation.Header,
            Description = "Please enter into field the JWT token",
            Name = "Authorization",
            Type = SecuritySchemeType.Http,
            BearerFormat = "JWT",
            Scheme = "Bearer",
        }
    );
    options.AddSecurityRequirement(
        new OpenApiSecurityRequirement
        {
            {
                new OpenApiSecurityScheme
                {
                    Reference = new OpenApiReference
                    {
                        Type = ReferenceType.SecurityScheme,
                        Id = "Bearer",
                    },
                },
                Array.Empty<string>()
            },
        }
    );
});

services.AddCors(options =>
{
    options.AddPolicy(
        "EHealthMonitoringSystemPolicy",
        builder =>
        {
            builder.WithOrigins("http://localhost:3000").AllowAnyMethod().AllowAnyHeader();
        }
    );
});

services
    .AddIdentity<User, IdentityRole>(options =>
    {
        // make these true before deploy
        options.Password.RequireDigit = false;
        options.Password.RequiredLength = 6;
        options.Password.RequireNonAlphanumeric = false;
        options.Password.RequireUppercase = false;
    })
    .AddEntityFrameworkStores<AppDbContext>()
    .AddDefaultTokenProviders();

services
    .AddAuthentication(x =>
    {
        x.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        x.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(o =>
    {
        var Key = Convert.FromBase64String(configuration["JWT:Key"]!);
        o.SaveToken = true;
        o.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = false, // on production make it true
            ValidateAudience = false, // on production make it true
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = configuration["JWT:Issuer"],
            ValidAudience = configuration["JWT:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(Key),
            ClockSkew = TimeSpan.Zero,
        };
        o.Events = new JwtBearerEvents
        {
            OnAuthenticationFailed = context =>
            {
                if (context.Exception.GetType() == typeof(SecurityTokenExpiredException))
                {
                    context.Response.Headers["IS-TOKEN-EXPIRED"] = "true";
                }
                return Task.CompletedTask;
            },
        };
    });

var connectionString = configuration.GetConnectionString("Default");

services.AddDbContext<AppDbContext>(options =>
{
    if (builder.Environment.IsDevelopment())
    {
        options.EnableSensitiveDataLogging();
    }
    options.UseNpgsql(
        connectionString,
        x =>
        {
            x.MigrationsAssembly("EHealthMonitoringSystemBackend.Data");
        }
    );
});

services.AddTransient<IEmailSender, EmailSender>();
services.AddSingleton<IJWTManager, JWTManager>();
services.AddSingleton<ITokenRepository, TokenRepository>();
services.Configure<AuthMessageSenderOptions>(builder.Configuration);

var app = builder.Build();

if (builder.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

app.UseSwagger();
app.UseSwaggerUI(c =>
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "InventoryManagementBackend.Api v1")
);

using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    Console.WriteLine("Running EF migrations...");
    dbContext.Database.Migrate();
}

app.UseHttpsRedirection();

app.UseRouting();
app.UseCors("EHealthMonitoringSystemPolicy");

app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.Run();
