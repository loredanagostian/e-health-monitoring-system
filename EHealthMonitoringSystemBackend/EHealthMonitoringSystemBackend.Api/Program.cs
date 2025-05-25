using EHealthMonitoringSystemBackend.Api.Services;
using EHealthMonitoringSystemBackend.Api.Services.Abstractions;
using EHealthMonitoringSystemBackend.Core.Models;
using EHealthMonitoringSystemBackend.Data;
using EHealthMonitoringSystemBackend.Data.Services;
using EHealthMonitoringSystemBackend.Data.Services.Abstractions;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Identity.UI.Services;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.FileProviders;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);
builder.WebHost.ConfigureAppConfiguration((builderContext, config) =>
{
    config
        .AddJsonFile("secrets/appsettings.secrets.json", optional: true) 
        .AddEnvironmentVariables();
});

var services = builder.Services;
var configuration = builder.Configuration;

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

services.AddSingleton<IJWTManager, JWTManager>();
services.AddTransient<IEmailSender, EmailSender>();
services.AddTransient<ITokenRepository, TokenRepository>();
services.AddTransient<IUploadManager, UploadManager>();
services.AddTransient<IDoctorRepository, DoctorRepository>();
services.AddTransient<ISpecializationRepository, SpecializationRepository>();
services.AddTransient<IAppointmentTypeRepository, AppointmentTypeRepository>();
services.AddTransient<IDoctorSpecializationsRepository, DoctorSpecializationRepository>();
services.AddTransient<IAppointmentRepository, AppointmentRepository>();
services.AddTransient<IAppointmentFileRepository, AppointmentFileRepository>();
services.Configure<AuthMessageSenderOptions>(builder.Configuration);

var app = builder.Build();

if (builder.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

app.UseSwagger();
app.UseSwaggerUI(c =>
    c.SwaggerEndpoint("/swagger/v1/swagger.json", "EHealthMonitoringSystemBackend.Api v1")
);

using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    Console.WriteLine("Running EF migrations...");
    dbContext.Database.Migrate();
}

var contentDir = configuration["Content_Directory"];
contentDir = Path.GetFullPath(Path.Combine(Directory.GetCurrentDirectory(), contentDir));
if (!Directory.Exists(contentDir))
{
    Console.WriteLine("Creating CONTENT_DIRECTORY: " + contentDir);
    Directory.CreateDirectory(contentDir);
}

// app.UseHttpsRedirection();
app.UseStaticFiles();
app.UseStaticFiles(new StaticFileOptions
{
    FileProvider = new PhysicalFileProvider(contentDir),
    RequestPath = "/content",
    ServeUnknownFileTypes = true
});
app.UseRouting();
app.UseCors("EHealthMonitoringSystemPolicy");
app.UseAuthentication();
app.UseAuthorization();
app.MapControllers();
app.Run();
