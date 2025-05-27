using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EHealthMonitoringSystemBackend.Data.Migrations
{
    /// <inheritdoc />
    public partial class AddedSpecializationIcon : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Icon",
                table: "Specializations",
                type: "text",
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Icon",
                table: "Specializations");
        }
    }
}
