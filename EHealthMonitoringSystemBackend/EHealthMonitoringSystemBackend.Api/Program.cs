using EHealthMonitoringSystemBackend.Data;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);
var services = builder.Services;
var configuration = builder.Configuration;

services.AddSwaggerGen(options =>
{
    options.SwaggerDoc("v1", new OpenApiInfo { Title = "E-Health Monitoring System", Version = "V1'"} );
    options.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme
    {
        In = ParameterLocation.Header,
        Description = "Please enter into field the JWT token",
        Name = "Authorization",
        Type = SecuritySchemeType.Http,
        BearerFormat = "JWT",
        Scheme = "Bearer"
    });
    options.AddSecurityRequirement(new OpenApiSecurityRequirement
    {
        {
            new OpenApiSecurityScheme
            {
                Reference = new OpenApiReference
                {
                    Type=ReferenceType.SecurityScheme,
                    Id="Bearer"
                }
            },
            new string[]{}
        }
    });
});

services.AddCors(options =>
{
    options.AddPolicy("EHealthMonitoringSystemPolicy", builder =>
    {
        builder
            .WithOrigins("http://localhost:3000")
            .AllowAnyMethod()
            .AllowAnyHeader();
    });
});

services.AddDefaultIdentity<IdentityUser>()
    .AddRoles<IdentityRole>()
    .AddEntityFrameworkStores<AppDbContext>()
    .AddDefaultTokenProviders();

var connectionString = configuration.GetConnectionString("Default");

services.AddDbContext<AppDbContext>(options => {
    if (builder.Environment.IsDevelopment())
    {
        options.EnableSensitiveDataLogging();
    }
    options.UseNpgsql(connectionString, x =>
    {
        x.MigrationsAssembly("EHealthMonitoringSystemBackend.Data");
    });
});

var app = builder.Build();

if (builder.Environment.IsDevelopment())
{
    app.UseDeveloperExceptionPage();
}

AppContext.SetSwitch("Npgsql.EnableLegacyTimestampBehavior", true);

app.UseSwagger();
app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "InventoryManagementBackend.Api v1"));

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

app.UseEndpoints(endpoints =>
{
    endpoints.MapControllerRoute(
        name: "default",
        pattern: "admin/{controller=Home}/{action=Index}/{id?}");
    endpoints.MapRazorPages();
});

app.Run();

app.Run();
