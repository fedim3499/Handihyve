using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace WebApi.Migrations
{
    public partial class wr : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "idProf",
                table: "WorkRequests",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "idclient",
                table: "WorkRequests",
                type: "int",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "idProf",
                table: "WorkRequests");

            migrationBuilder.DropColumn(
                name: "idclient",
                table: "WorkRequests");
        }
    }
}
