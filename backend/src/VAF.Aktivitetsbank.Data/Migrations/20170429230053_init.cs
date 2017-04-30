using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class init : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateTable(
                name: "Aktivitet",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    Beskrivelse = table.Column<string>(nullable: false),
                    Navn = table.Column<string>(maxLength: 50, nullable: false),
                    OmfangTimer = table.Column<int>(nullable: false),
                    SkoleId = table.Column<Guid>(nullable: false),
                    Type = table.Column<string>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Aktivitet", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Aktivitetstype",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    Navn = table.Column<string>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Aktivitetstype", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Deltaker",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    FagId = table.Column<Guid>(nullable: false),
                    Kompetansemaal = table.Column<string>(nullable: false),
                    Timer = table.Column<int>(nullable: false),
                    TrinnId = table.Column<Guid>(nullable: false),
                    UtdanningsprogramId = table.Column<Guid>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Deltaker", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Fag",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    Navn = table.Column<string>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Fag", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Skole",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    Kode = table.Column<string>(nullable: false),
                    Navn = table.Column<string>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Skole", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Trinn",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    Navn = table.Column<string>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Trinn", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Utdanningsprogram",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    Navn = table.Column<string>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Utdanningsprogram", x => x.Id);
                });
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Aktivitet");

            migrationBuilder.DropTable(
                name: "Aktivitetstype");

            migrationBuilder.DropTable(
                name: "Deltaker");

            migrationBuilder.DropTable(
                name: "Fag");

            migrationBuilder.DropTable(
                name: "Skole");

            migrationBuilder.DropTable(
                name: "Trinn");

            migrationBuilder.DropTable(
                name: "Utdanningsprogram");
        }
    }
}
