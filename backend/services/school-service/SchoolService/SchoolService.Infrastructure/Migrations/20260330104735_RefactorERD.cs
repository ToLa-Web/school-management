using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace SchoolService.Infrastructure.Migrations
{
    /// <inheritdoc />
    public partial class RefactorERD : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Enrollments");

            migrationBuilder.DropColumn(
                name: "Day",
                table: "Schedules");

            migrationBuilder.DropColumn(
                name: "Time",
                table: "Schedules");

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Teachers",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Department",
                table: "Teachers",
                type: "character varying(150)",
                maxLength: 150,
                nullable: true);

            migrationBuilder.AddColumn<DateOnly>(
                name: "HireDate",
                table: "Teachers",
                type: "date",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Subjects",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Students",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "ClassroomId",
                table: "StudentGrades",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "GradingMethod",
                table: "StudentGrades",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<int>(
                name: "Status",
                table: "StudentClassrooms",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTime>(
                name: "UnenrolledAt",
                table: "StudentClassrooms",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "DayOfWeek",
                table: "Schedules",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Schedules",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<TimeOnly>(
                name: "EndTime",
                table: "Schedules",
                type: "time without time zone",
                nullable: false,
                defaultValue: new TimeOnly(0, 0, 0));

            migrationBuilder.AddColumn<TimeOnly>(
                name: "StartTime",
                table: "Schedules",
                type: "time without time zone",
                nullable: false,
                defaultValue: new TimeOnly(0, 0, 0));

            migrationBuilder.AddColumn<int>(
                name: "Type",
                table: "Schedules",
                type: "integer",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTime>(
                name: "DeletedAt",
                table: "Classrooms",
                type: "timestamp with time zone",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "RoomId",
                table: "Classrooms",
                type: "uuid",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "Semester",
                table: "Classrooms",
                type: "character varying(20)",
                maxLength: 20,
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "ScheduleId",
                table: "Attendances",
                type: "uuid",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "Announcements",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Title = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    Body = table.Column<string>(type: "text", nullable: false),
                    ClassroomId = table.Column<Guid>(type: "uuid", nullable: true),
                    AuthorTeacherId = table.Column<Guid>(type: "uuid", nullable: false),
                    PublishedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Announcements", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Announcements_Classrooms_ClassroomId",
                        column: x => x.ClassroomId,
                        principalTable: "Classrooms",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.SetNull);
                    table.ForeignKey(
                        name: "FK_Announcements_Teachers_AuthorTeacherId",
                        column: x => x.AuthorTeacherId,
                        principalTable: "Teachers",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Restrict);
                });

            migrationBuilder.CreateTable(
                name: "Materials",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    ClassroomId = table.Column<Guid>(type: "uuid", nullable: false),
                    Title = table.Column<string>(type: "character varying(200)", maxLength: 200, nullable: false),
                    Description = table.Column<string>(type: "text", nullable: true),
                    Url = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    Type = table.Column<int>(type: "integer", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    DeletedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Materials", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Materials_Classrooms_ClassroomId",
                        column: x => x.ClassroomId,
                        principalTable: "Classrooms",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Rooms",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    Name = table.Column<string>(type: "character varying(150)", maxLength: 150, nullable: false),
                    Location = table.Column<string>(type: "character varying(500)", maxLength: 500, nullable: true),
                    Capacity = table.Column<int>(type: "integer", nullable: false, defaultValue: 0),
                    Type = table.Column<int>(type: "integer", nullable: false),
                    IsActive = table.Column<bool>(type: "boolean", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    DeletedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Rooms", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Submissions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    MaterialId = table.Column<Guid>(type: "uuid", nullable: false),
                    StudentId = table.Column<Guid>(type: "uuid", nullable: false),
                    SubmissionUrl = table.Column<string>(type: "character varying(1000)", maxLength: 1000, nullable: true),
                    SubmittedAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false),
                    Grade = table.Column<decimal>(type: "numeric(5,2)", precision: 5, scale: 2, nullable: true),
                    Feedback = table.Column<string>(type: "text", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Submissions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Submissions_Materials_MaterialId",
                        column: x => x.MaterialId,
                        principalTable: "Materials",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Submissions_Students_StudentId",
                        column: x => x.StudentId,
                        principalTable: "Students",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_StudentGrades_ClassroomId",
                table: "StudentGrades",
                column: "ClassroomId");

            migrationBuilder.CreateIndex(
                name: "IX_Classrooms_RoomId",
                table: "Classrooms",
                column: "RoomId");

            migrationBuilder.CreateIndex(
                name: "IX_Attendances_ScheduleId",
                table: "Attendances",
                column: "ScheduleId");

            migrationBuilder.CreateIndex(
                name: "IX_Announcements_AuthorTeacherId",
                table: "Announcements",
                column: "AuthorTeacherId");

            migrationBuilder.CreateIndex(
                name: "IX_Announcements_ClassroomId",
                table: "Announcements",
                column: "ClassroomId");

            migrationBuilder.CreateIndex(
                name: "IX_Materials_ClassroomId",
                table: "Materials",
                column: "ClassroomId");

            migrationBuilder.CreateIndex(
                name: "IX_Submissions_MaterialId",
                table: "Submissions",
                column: "MaterialId");

            migrationBuilder.CreateIndex(
                name: "IX_Submissions_StudentId",
                table: "Submissions",
                column: "StudentId");

            migrationBuilder.AddForeignKey(
                name: "FK_Attendances_Schedules_ScheduleId",
                table: "Attendances",
                column: "ScheduleId",
                principalTable: "Schedules",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_Classrooms_Rooms_RoomId",
                table: "Classrooms",
                column: "RoomId",
                principalTable: "Rooms",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);

            migrationBuilder.AddForeignKey(
                name: "FK_StudentGrades_Classrooms_ClassroomId",
                table: "StudentGrades",
                column: "ClassroomId",
                principalTable: "Classrooms",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Attendances_Schedules_ScheduleId",
                table: "Attendances");

            migrationBuilder.DropForeignKey(
                name: "FK_Classrooms_Rooms_RoomId",
                table: "Classrooms");

            migrationBuilder.DropForeignKey(
                name: "FK_StudentGrades_Classrooms_ClassroomId",
                table: "StudentGrades");

            migrationBuilder.DropTable(
                name: "Announcements");

            migrationBuilder.DropTable(
                name: "Rooms");

            migrationBuilder.DropTable(
                name: "Submissions");

            migrationBuilder.DropTable(
                name: "Materials");

            migrationBuilder.DropIndex(
                name: "IX_StudentGrades_ClassroomId",
                table: "StudentGrades");

            migrationBuilder.DropIndex(
                name: "IX_Classrooms_RoomId",
                table: "Classrooms");

            migrationBuilder.DropIndex(
                name: "IX_Attendances_ScheduleId",
                table: "Attendances");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Teachers");

            migrationBuilder.DropColumn(
                name: "Department",
                table: "Teachers");

            migrationBuilder.DropColumn(
                name: "HireDate",
                table: "Teachers");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Subjects");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Students");

            migrationBuilder.DropColumn(
                name: "ClassroomId",
                table: "StudentGrades");

            migrationBuilder.DropColumn(
                name: "GradingMethod",
                table: "StudentGrades");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "StudentClassrooms");

            migrationBuilder.DropColumn(
                name: "UnenrolledAt",
                table: "StudentClassrooms");

            migrationBuilder.DropColumn(
                name: "DayOfWeek",
                table: "Schedules");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Schedules");

            migrationBuilder.DropColumn(
                name: "EndTime",
                table: "Schedules");

            migrationBuilder.DropColumn(
                name: "StartTime",
                table: "Schedules");

            migrationBuilder.DropColumn(
                name: "Type",
                table: "Schedules");

            migrationBuilder.DropColumn(
                name: "DeletedAt",
                table: "Classrooms");

            migrationBuilder.DropColumn(
                name: "RoomId",
                table: "Classrooms");

            migrationBuilder.DropColumn(
                name: "Semester",
                table: "Classrooms");

            migrationBuilder.DropColumn(
                name: "ScheduleId",
                table: "Attendances");

            migrationBuilder.AddColumn<string>(
                name: "Day",
                table: "Schedules",
                type: "character varying(20)",
                maxLength: 20,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "Time",
                table: "Schedules",
                type: "character varying(30)",
                maxLength: 30,
                nullable: false,
                defaultValue: "");

            migrationBuilder.CreateTable(
                name: "Enrollments",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uuid", nullable: false),
                    StudentId = table.Column<Guid>(type: "uuid", nullable: false),
                    SubjectId = table.Column<Guid>(type: "uuid", nullable: false),
                    EnrolledAt = table.Column<DateTime>(type: "timestamp with time zone", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Enrollments", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Enrollments_Students_StudentId",
                        column: x => x.StudentId,
                        principalTable: "Students",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Enrollments_Subjects_SubjectId",
                        column: x => x.SubjectId,
                        principalTable: "Subjects",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Enrollments_StudentId_SubjectId",
                table: "Enrollments",
                columns: new[] { "StudentId", "SubjectId" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_Enrollments_SubjectId",
                table: "Enrollments",
                column: "SubjectId");
        }
    }
}
