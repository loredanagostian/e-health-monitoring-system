# build backend
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS builder
WORKDIR /app/

COPY **/EHealthMonitoringSystemBackend.Api.csproj /app/EHealthMonitoringSystemBackend.Api/
COPY **/EHealthMonitoringSystemBackend.Core.csproj /app/EHealthMonitoringSystemBackend.Core/
COPY **/EHealthMonitoringSystemBackend.Data.csproj /app/EHealthMonitoringSystemBackend.Data/
COPY *.sln /app/

RUN dotnet restore

COPY ./ /app

RUN dotnet publish --output "/app/bin" -c release 

FROM mcr.microsoft.com/dotnet/aspnet:8.0

WORKDIR /app/bin

COPY --from=builder /app/bin /app/bin

CMD ["dotnet", "EHealthMonitoringSystemBackend.Api.dll"]
