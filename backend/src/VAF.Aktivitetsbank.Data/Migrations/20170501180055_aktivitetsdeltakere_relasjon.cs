using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class aktivitetsdeltakere_relasjon : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "AktivitetId",
                table: "Deltaker",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.CreateIndex(
                name: "IX_Deltaker_AktivitetId",
                table: "Deltaker",
                column: "AktivitetId");

            migrationBuilder.AddForeignKey(
                name: "FK_Deltaker_Aktivitet_AktivitetId",
                table: "Deltaker",
                column: "AktivitetId",
                principalTable: "Aktivitet",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deltaker_Aktivitet_AktivitetId",
                table: "Deltaker");

            migrationBuilder.DropIndex(
                name: "IX_Deltaker_AktivitetId",
                table: "Deltaker");

            migrationBuilder.DropColumn(
                name: "AktivitetId",
                table: "Deltaker");
        }
    }
}
