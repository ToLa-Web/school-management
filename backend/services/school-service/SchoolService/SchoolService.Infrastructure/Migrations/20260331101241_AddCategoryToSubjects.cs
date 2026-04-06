using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SchoolService.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class AddCategoryToSubjects : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<string>(
                name: "Category",
                table: "Subjects",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Code",
                table: "Subjects",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Department",
                table: "Subjects",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Description",
                table: "Subjects",
                type: "text",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "YearLevel",
                table: "Subjects",
                type: "integer",
                nullable: false,
                defaultValue: 0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Category",
                table: "Subjects");

            migrationBuilder.DropColumn(
                name: "Code",
                table: "Subjects");

            migrationBuilder.DropColumn(
                name: "Department",
                table: "Subjects");

            migrationBuilder.DropColumn(
                name: "Description",
                table: "Subjects");

            migrationBuilder.DropColumn(
                name: "YearLevel",
                table: "Subjects");
        }
    }
}
