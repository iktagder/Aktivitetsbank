using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class skoleaar_table : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "SkoleAar",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    Navn = table.Column<string>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_SkoleAar", x => x.Id);
                });
            migrationBuilder.Sql("INSERT INTO [SkoleAar] ([Id], [Navn]) VALUES('2720F51B-F73F-4C05-8784-07F230F952A5', '17/18'); ");
            migrationBuilder.Sql("INSERT INTO [SkoleAar] ([Id], [Navn]) VALUES('38C52DF9-3324-490E-8ED8-A82B7EEE4D12', '18/19'); ");
            migrationBuilder.Sql("INSERT INTO [SkoleAar] ([Id], [Navn]) VALUES('B8033B67-439A-4748-992B-E1AB5099F982', '19/20'); ");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "SkoleAar");
        }
    }
}
