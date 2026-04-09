using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SchoolService.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class RemoveYearLevelFromSubjectAndAddSubjectToClassroom : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "YearLevel",
                table: "Subjects");

            migrationBuilder.AddColumn<Guid>(
                name: "SubjectId",
                table: "Classrooms",
                type: "uuid",
                nullable: true);

            // Update existing classrooms to reference the first available subject
            migrationBuilder.Sql(@"
                UPDATE ""Classrooms"" c
                SET ""SubjectId"" = (SELECT ""Id"" FROM ""Subjects"" LIMIT 1)
                WHERE ""SubjectId"" IS NULL AND EXISTS (SELECT 1 FROM ""Subjects"" LIMIT 1);
            ");

            // Make the column non-nullable after data is populated
            migrationBuilder.AlterColumn<Guid>(
                name: "SubjectId",
                table: "Classrooms",
                type: "uuid",
                nullable: false,
                oldClrType: typeof(Guid),
                oldType: "uuid",
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Classrooms_SubjectId",
                table: "Classrooms",
                column: "SubjectId");

            migrationBuilder.AddForeignKey(
                name: "FK_Classrooms_Subjects_SubjectId",
                table: "Classrooms",
                column: "SubjectId",
                principalTable: "Subjects",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Classrooms_Subjects_SubjectId",
                table: "Classrooms");

            migrationBuilder.DropIndex(
                name: "IX_Classrooms_SubjectId",
                table: "Classrooms");

            migrationBuilder.DropColumn(
                name: "SubjectId",
                table: "Classrooms");

            migrationBuilder.AddColumn<int>(
                name: "YearLevel",
                table: "Subjects",
                type: "integer",
                nullable: false,
                defaultValue: 0);
        }
    }
}
