using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class parentUtdanningsprogram : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "OverordnetUtdanningsprogramId",
                table: "Utdanningsprogram",
                nullable: true);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "OverordnetUtdanningsprogramId",
                table: "Utdanningsprogram");
        }
    }
}
