using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class aktivitet_skole_navigasjon : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_Aktivitet_SkoleId",
                table: "Aktivitet",
                column: "SkoleId");

            migrationBuilder.AddForeignKey(
                name: "FK_Aktivitet_Skole_SkoleId",
                table: "Aktivitet",
                column: "SkoleId",
                principalTable: "Skole",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Aktivitet_Skole_SkoleId",
                table: "Aktivitet");

            migrationBuilder.DropIndex(
                name: "IX_Aktivitet_SkoleId",
                table: "Aktivitet");
        }
    }
}
