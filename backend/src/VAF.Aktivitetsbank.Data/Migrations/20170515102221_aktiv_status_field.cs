using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class aktiv_status_field : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<bool>(
                name: "Aktiv",
                table: "Deltaker",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "Aktiv",
                table: "Aktivitet",
                nullable: true);

            migrationBuilder.Sql(@"UPDATE dbo.Aktivitet SET Aktiv = 1
              where Aktiv IS NULL");

            migrationBuilder.Sql(@"UPDATE dbo.Deltaker SET Aktiv = 1
              where Aktiv IS NULL");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Aktiv",
                table: "Deltaker");

            migrationBuilder.DropColumn(
                name: "Aktiv",
                table: "Aktivitet");
        }
    }
}
