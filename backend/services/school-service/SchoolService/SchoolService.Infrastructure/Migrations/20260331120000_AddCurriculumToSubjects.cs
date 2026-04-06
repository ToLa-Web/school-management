using Microsoft.EntityFrameworkCore.Migrations;

namespace SchoolService.Infrastructure.Migrations
{
    public partial class AddCurriculumToSubjects : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "YearLevel",
                table: "Subjects",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "Category",
                table: "Subjects",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Department",
                table: "Subjects",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Description",
                table: "Subjects",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Code",
                table: "Subjects",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "YearLevel",
                table: "Subjects");

            migrationBuilder.DropColumn(
                name: "Category",
                table: "Subjects");

            migrationBuilder.DropColumn(
                name: "Department",
                table: "Subjects");

            migrationBuilder.DropColumn(
                name: "Description",
                table: "Subjects");

            migrationBuilder.DropColumn(
                name: "Code",
                table: "Subjects");
        }
    }
}
