using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class timestamp_user : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "Endret",
                table: "Deltaker",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "EndretAv",
                table: "Deltaker",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "Opprettet",
                table: "Deltaker",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "OpprettetAv",
                table: "Deltaker",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "Endret",
                table: "Aktivitet",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "EndretAv",
                table: "Aktivitet",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "Opprettet",
                table: "Aktivitet",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "OpprettetAv",
                table: "Aktivitet",
                nullable: true);
            
            migrationBuilder.Sql(@"UPDATE dbo.Aktivitet SET Opprettet = GETDATE()
              where Opprettet IS NULL");

            migrationBuilder.Sql(@"UPDATE dbo.Aktivitet SET Endret = GETDATE()
              where Endret IS NULL");

            migrationBuilder.Sql(@"UPDATE dbo.Deltaker SET Opprettet = GETDATE()
              where Opprettet IS NULL");

            migrationBuilder.Sql(@"UPDATE dbo.Deltaker SET Endret = GETDATE()
              where Endret IS NULL");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Endret",
                table: "Deltaker");

            migrationBuilder.DropColumn(
                name: "EndretAv",
                table: "Deltaker");

            migrationBuilder.DropColumn(
                name: "Opprettet",
                table: "Deltaker");

            migrationBuilder.DropColumn(
                name: "OpprettetAv",
                table: "Deltaker");

            migrationBuilder.DropColumn(
                name: "Endret",
                table: "Aktivitet");

            migrationBuilder.DropColumn(
                name: "EndretAv",
                table: "Aktivitet");

            migrationBuilder.DropColumn(
                name: "Opprettet",
                table: "Aktivitet");

            migrationBuilder.DropColumn(
                name: "OpprettetAv",
                table: "Aktivitet");
        }
    }
}
