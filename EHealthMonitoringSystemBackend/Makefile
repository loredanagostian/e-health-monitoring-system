API_DIR=EHealthMonitoringSystemBackend.Api
DATA_DIR=EHealthMonitoringSystemBackend.Data
API_PROJECT=$(API_DIR)/EHealthMonitoringSystemBackend.Api.csproj
DATA_PROJECT=$(DATA_DIR)/EHealthMonitoringSystemBackend.Data.csproj
APPSETTINGS=$(API_DIR)/appsettings.Development.json

.PHONY: run migration migrate

run: $(APPSETTINGS)
	dotnet watch run --project $(API_PROJECT)

migration: $(APPSETTINGS)
ifndef name
	$(error Migration name not provided. Use: make migration name=YourMigrationName)
endif
	dotnet ef migrations add $(name) --project $(DATA_PROJECT) --startup-project $(API_PROJECT)

migrate: $(APPSETTINGS)
	dotnet ef database update --project $(DATA_PROJECT) --startup-project $(API_PROJECT)