using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class skoleaar_aktivitet_nullable : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<Guid>(
                name: "SkoleAarId",
                table: "Aktivitet",
                nullable: true);

            migrationBuilder.Sql(@"UPDATE dbo.Aktivitet SET SkoleAarId = '2720F51B-F73F-4C05-8784-07F230F952A5' where SkoleAarId IS NULL");

        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "SkoleAarId",
                table: "Aktivitet");
        }
    }
}
