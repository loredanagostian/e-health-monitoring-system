using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EHealthMonitoringSystemBackend.Data.Migrations
{
    /// <inheritdoc />
    public partial class RemoveKeys : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_PatientInfos_AspNetUsers_AspNetUserId",
                table: "PatientInfos");

            migrationBuilder.DropForeignKey(
                name: "FK_UserRefreshTokens_AspNetUsers_AspNetUserId",
                table: "UserRefreshTokens");

            migrationBuilder.DropIndex(
                name: "IX_UserRefreshTokens_AspNetUserId",
                table: "UserRefreshTokens");

            migrationBuilder.DropIndex(
                name: "IX_PatientInfos_AspNetUserId",
                table: "PatientInfos");

            migrationBuilder.DropColumn(
                name: "AspNetUserId",
                table: "UserRefreshTokens");

            migrationBuilder.DropColumn(
                name: "AspNetUserId",
                table: "PatientInfos");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "AspNetUserId",
                table: "UserRefreshTokens",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "AspNetUserId",
                table: "PatientInfos",
                type: "text",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserRefreshTokens_AspNetUserId",
                table: "UserRefreshTokens",
                column: "AspNetUserId");

            migrationBuilder.CreateIndex(
                name: "IX_PatientInfos_AspNetUserId",
                table: "PatientInfos",
                column: "AspNetUserId");

            migrationBuilder.AddForeignKey(
                name: "FK_PatientInfos_AspNetUsers_AspNetUserId",
                table: "PatientInfos",
                column: "AspNetUserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_UserRefreshTokens_AspNetUsers_AspNetUserId",
                table: "UserRefreshTokens",
                column: "AspNetUserId",
                principalTable: "AspNetUsers",
                principalColumn: "Id");
        }
    }
}
