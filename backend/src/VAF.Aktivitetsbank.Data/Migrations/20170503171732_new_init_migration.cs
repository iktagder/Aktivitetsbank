using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class new_init_migration : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
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
                    Navn = table.Column<string>(nullable: false),
                    OverordnetUtdanningsprogramId = table.Column<Guid>(nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Utdanningsprogram", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "Aktivitet",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    AktivitetstypeId = table.Column<Guid>(nullable: false),
                    Beskrivelse = table.Column<string>(nullable: false),
                    Navn = table.Column<string>(maxLength: 50, nullable: false),
                    OmfangTimer = table.Column<int>(nullable: false),
                    SkoleId = table.Column<Guid>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Aktivitet", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Aktivitet_Aktivitetstype_AktivitetstypeId",
                        column: x => x.AktivitetstypeId,
                        principalTable: "Aktivitetstype",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Aktivitet_Skole_SkoleId",
                        column: x => x.SkoleId,
                        principalTable: "Skole",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "Deltaker",
                columns: table => new
                {
                    Id = table.Column<Guid>(nullable: false),
                    AktivitetId = table.Column<Guid>(nullable: false),
                    FagId = table.Column<Guid>(nullable: false),
                    Kompetansemaal = table.Column<string>(nullable: false),
                    Timer = table.Column<int>(nullable: false),
                    TrinnId = table.Column<Guid>(nullable: false),
                    UtdanningsprogramId = table.Column<Guid>(nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_Deltaker", x => x.Id);
                    table.ForeignKey(
                        name: "FK_Deltaker_Aktivitet_AktivitetId",
                        column: x => x.AktivitetId,
                        principalTable: "Aktivitet",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Deltaker_Fag_FagId",
                        column: x => x.FagId,
                        principalTable: "Fag",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Deltaker_Trinn_TrinnId",
                        column: x => x.TrinnId,
                        principalTable: "Trinn",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_Deltaker_Utdanningsprogram_UtdanningsprogramId",
                        column: x => x.UtdanningsprogramId,
                        principalTable: "Utdanningsprogram",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Aktivitet_AktivitetstypeId",
                table: "Aktivitet",
                column: "AktivitetstypeId");

            migrationBuilder.CreateIndex(
                name: "IX_Aktivitet_SkoleId",
                table: "Aktivitet",
                column: "SkoleId");

            migrationBuilder.CreateIndex(
                name: "IX_Deltaker_AktivitetId",
                table: "Deltaker",
                column: "AktivitetId");

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
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropTable(
                name: "Deltaker");

            migrationBuilder.DropTable(
                name: "Aktivitet");

            migrationBuilder.DropTable(
                name: "Fag");

            migrationBuilder.DropTable(
                name: "Trinn");

            migrationBuilder.DropTable(
                name: "Utdanningsprogram");

            migrationBuilder.DropTable(
                name: "Aktivitetstype");

            migrationBuilder.DropTable(
                name: "Skole");
        }
    }
}
