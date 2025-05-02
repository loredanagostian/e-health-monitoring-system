using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace EHealthMonitoringSystemBackend.Data.Migrations
{
    /// <inheritdoc />
    public partial class ChangeId : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUsers_UserRefreshTokens_RefreshTokenId",
                table: "AspNetUsers");

            migrationBuilder.RenameColumn(
                name: "RefreshTokenId",
                table: "AspNetUsers",
                newName: "UserRefreshTokenId");

            migrationBuilder.RenameIndex(
                name: "IX_AspNetUsers_RefreshTokenId",
                table: "AspNetUsers",
                newName: "IX_AspNetUsers_UserRefreshTokenId");

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUsers_UserRefreshTokens_UserRefreshTokenId",
                table: "AspNetUsers",
                column: "UserRefreshTokenId",
                principalTable: "UserRefreshTokens",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_AspNetUsers_UserRefreshTokens_UserRefreshTokenId",
                table: "AspNetUsers");

            migrationBuilder.RenameColumn(
                name: "UserRefreshTokenId",
                table: "AspNetUsers",
                newName: "RefreshTokenId");

            migrationBuilder.RenameIndex(
                name: "IX_AspNetUsers_UserRefreshTokenId",
                table: "AspNetUsers",
                newName: "IX_AspNetUsers_RefreshTokenId");

            migrationBuilder.AddForeignKey(
                name: "FK_AspNetUsers_UserRefreshTokens_RefreshTokenId",
                table: "AspNetUsers",
                column: "RefreshTokenId",
                principalTable: "UserRefreshTokens",
                principalColumn: "Id");
        }
    }
}
