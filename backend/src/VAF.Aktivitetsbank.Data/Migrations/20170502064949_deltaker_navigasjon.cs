using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class deltaker_navigasjon : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_Deltaker_FagId",
                table: "Deltaker",
                column: "FagId");

            migrationBuilder.CreateIndex(
                name: "IX_Deltaker_TrinnId",
                table: "Deltaker",
                column: "TrinnId");

            migrationBuilder.CreateIndex(
                name: "IX_Deltaker_UtdanningsprogramId",
                table: "Deltaker",
                column: "UtdanningsprogramId");

            migrationBuilder.AddForeignKey(
                name: "FK_Deltaker_Fag_FagId",
                table: "Deltaker",
                column: "FagId",
                principalTable: "Fag",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Deltaker_Trinn_TrinnId",
                table: "Deltaker",
                column: "TrinnId",
                principalTable: "Trinn",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Deltaker_Utdanningsprogram_UtdanningsprogramId",
                table: "Deltaker",
                column: "UtdanningsprogramId",
                principalTable: "Utdanningsprogram",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Deltaker_Fag_FagId",
                table: "Deltaker");

            migrationBuilder.DropForeignKey(
                name: "FK_Deltaker_Trinn_TrinnId",
                table: "Deltaker");

            migrationBuilder.DropForeignKey(
                name: "FK_Deltaker_Utdanningsprogram_UtdanningsprogramId",
                table: "Deltaker");

            migrationBuilder.DropIndex(
                name: "IX_Deltaker_FagId",
                table: "Deltaker");

            migrationBuilder.DropIndex(
                name: "IX_Deltaker_TrinnId",
                table: "Deltaker");

            migrationBuilder.DropIndex(
                name: "IX_Deltaker_UtdanningsprogramId",
                table: "Deltaker");
        }
    }
}
