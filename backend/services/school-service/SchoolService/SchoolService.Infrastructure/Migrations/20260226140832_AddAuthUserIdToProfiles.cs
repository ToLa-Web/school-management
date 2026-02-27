using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SchoolService.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddAuthUserIdToProfiles : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "AuthUserId",
                table: "Teachers",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "AuthUserId",
                table: "Students",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Email",
                table: "Students",
                type: "text",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Teachers_AuthUserId",
                table: "Teachers",
                column: "AuthUserId",
                unique: true,
                filter: "\"AuthUserId\" IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_Students_AuthUserId",
                table: "Students",
                column: "AuthUserId",
                unique: true,
                filter: "\"AuthUserId\" IS NOT NULL");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Teachers_AuthUserId",
                table: "Teachers");

            migrationBuilder.DropIndex(
                name: "IX_Students_AuthUserId",
                table: "Students");

            migrationBuilder.DropColumn(
                name: "AuthUserId",
                table: "Teachers");

            migrationBuilder.DropColumn(
                name: "AuthUserId",
                table: "Students");

            migrationBuilder.DropColumn(
                name: "Email",
                table: "Students");
        }
    }
}
