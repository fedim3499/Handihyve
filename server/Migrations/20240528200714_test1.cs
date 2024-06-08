using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WebApi.Migrations
{
    public partial class test1 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Review",
                schema: "HR",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    ProfessionId = table.Column<int>(type: "int", nullable: true),
                    ClientId = table.Column<int>(type: "int", nullable: true),
                    Rating = table.Column<double>(type: "float", nullable: true),
                    Comment = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Review", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Profession_ProfessionTypeId",
                schema: "HR",
                table: "Profession",
                column: "ProfessionTypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Profession_StatusId",
                schema: "HR",
                table: "Profession",
                column: "StatusId");

            migrationBuilder.AddForeignKey(
                name: "FK_Profession_ProfessionType_ProfessionTypeId",
                schema: "HR",
                table: "Profession",
                column: "ProfessionTypeId",
                principalSchema: "HR",
                principalTable: "ProfessionType",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Profession_Status_StatusId",
                schema: "HR",
                table: "Profession",
                column: "StatusId",
                principalSchema: "Common",
                principalTable: "Status",
                principalColumn: "Id");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Profession_ProfessionType_ProfessionTypeId",
                schema: "HR",
                table: "Profession");

            migrationBuilder.DropForeignKey(
                name: "FK_Profession_Status_StatusId",
                schema: "HR",
                table: "Profession");

            migrationBuilder.DropTable(
                name: "Review",
                schema: "HR");

            migrationBuilder.DropIndex(
                name: "IX_Profession_ProfessionTypeId",
                schema: "HR",
                table: "Profession");

            migrationBuilder.DropIndex(
                name: "IX_Profession_StatusId",
                schema: "HR",
                table: "Profession");
        }
    }
}
