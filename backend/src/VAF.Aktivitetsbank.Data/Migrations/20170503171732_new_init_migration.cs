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

            migrationBuilder.Sql(
                @"INSERT [dbo].[Aktivitetstype] ([Id], [Navn]) VALUES (N'4e675682-b427-4746-b7a2-1bc9236d2f64', N'Eksamen')
INSERT [dbo].[Aktivitetstype] ([Id], [Navn]) VALUES (N'246b1b12-8320-4c91-93fb-1e5d5886fd7a', N'Eksterne')
INSERT [dbo].[Aktivitetstype] ([Id], [Navn]) VALUES (N'03d2a990-d304-4b9b-9b40-326d8bbe4998', N'Ekskursjon')
INSERT [dbo].[Aktivitetstype] ([Id], [Navn]) VALUES (N'5fca7efe-3b5a-4d17-b94f-4930892aedf2', N'Uten kompetansemål')
INSERT [dbo].[Aktivitetstype] ([Id], [Navn]) VALUES (N'c6dcc000-b9ff-4cec-a923-53f907b6a959', N'Den kulturelle skolesekken')
INSERT [dbo].[Aktivitetstype] ([Id], [Navn]) VALUES (N'94f012b4-6a7f-46b5-bcb2-6b2e4391a5d9', N'Internasjonalisering (OD)')
INSERT [dbo].[Aktivitetstype] ([Id], [Navn]) VALUES (N'0427ad56-20f1-463b-a902-882076b50363', N'Lesedag/forberedelsesdag')
INSERT [dbo].[Aktivitetstype] ([Id], [Navn]) VALUES (N'5ae9aa5e-447f-4e01-80c0-8fbc320106bd', N'Elevreise')
INSERT [dbo].[Aktivitetstype] ([Id], [Navn]) VALUES (N'a9d136d8-bf94-41d4-8539-94d64c726193', N'Alternative opplegg')
INSERT [dbo].[Aktivitetstype] ([Id], [Navn]) VALUES (N'f5b76c7c-882d-478c-904b-ae2d8e2b785a', N'Tentamen/fagdag')
INSERT [dbo].[Aktivitetstype] ([Id], [Navn]) VALUES (N'db49633c-ab6f-41e2-8046-d6c1a53ffd37', N'Utplassering/YFF')

INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'2235085e-6c67-4f91-9e98-0aca5791f129', N'Samfunnsfag')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'009ec080-f7ac-4d33-ba89-16c654154e53', N'Kroppsøving')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'5eee5e3e-fd66-4174-9a91-1a5ef8d9870c', N'Norsk')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'616eb779-b552-4283-8038-2f8c0de2f665', N'Matte')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'6f2570eb-f5a0-4698-9d38-3238eebb0df6', N'Kjemi')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'd0cd4ab4-c17c-40e2-bd0d-38d38570c29d', N'YFF (Yrkesfaglig fordypning)')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'39564173-dadc-4549-ab85-42ac2f864971', N'Felles programfag')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'4aadb77b-c8ce-4b22-9dc3-51db7d3fe29d', N'Biologi')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'cbd7825e-5606-4050-8491-5aed15067776', N'Naturfag')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'4dadd878-d4e6-4881-9c7f-64ebbb2524aa', N'Engelsk')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'1a0d9073-cb01-491a-9906-7472b5a82aa9', N'Geografi')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'40e19ea5-824a-4859-b983-7ba893c53aa8', N'Fremmedspråk')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'd066acab-46ee-4f23-806e-85de25025c95', N'Religion og etikk')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'0f4548f2-c02f-42c7-bcae-935b7bd46a1c', N'Historie')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'cd18ab2e-50da-43a4-bbaf-9bb5d5c0de9a', N'Programfag til valg')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'0654705a-3831-4e7f-8281-ac3ee3651a61', N'Matematikk')
INSERT [dbo].[Fag] ([Id], [Navn]) VALUES (N'b3d51adc-d3cd-477b-b2d8-cdea247e2c08', N'Fysikk')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'c7edb43f-86d0-4c1a-bccb-1fb0f7c4b4e1', N'SIR', N'Sirdal')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'340576ef-4cc5-4709-9f63-1fea3fbf5cd1', N'BYR', N'Byremo')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'ae10a09e-ff02-4d31-99cb-243964bdd887', N'VAG', N'Vågsbygd')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'0ee3658c-d8c8-4f00-93af-335d2f3fca88', N'MAN', N'Mandal')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'e3dac0d5-0a4e-4cd1-a9d8-503aa98f005a', N'VEN', N'Vennesla')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'269576c5-1c7b-4e6b-be9e-6c40026a898f', N'FVG', N'Flekkefjord')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'6d584e76-ea83-4935-afc2-8d23d22d8b28', N'ALLE', N'Alle')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'83911fda-028b-4e4f-bf00-9a86e503d935', N'SOG', N'Søgne')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'd018042f-9490-4fb8-911e-a7b40a955f3e', N'KKG', N'KKG')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'0e317497-7aa5-47ff-aa8a-beaab05b852d', N'SMI', N'SMI')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'1f99050c-1fa2-4d7e-ad64-db13b1932977', N'KVA', N'Kvadraturen Skolesenter')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'afc07a60-c76f-4fa8-9eb6-f60c1a9bc2f5', N'TAN', N'Tangen')
INSERT [dbo].[Skole] ([Id], [Kode], [Navn]) VALUES (N'86c826c9-160e-4c82-93dd-f8c04c1c1bc1', N'EVG', N'Eilert Sundt')
INSERT [dbo].[Trinn] ([Id], [Navn]) VALUES (N'9b537918-a5a5-474d-95a7-0249ba5f52b5', N'Vg2')
INSERT [dbo].[Trinn] ([Id], [Navn]) VALUES (N'49394741-3d86-423a-b8ab-40d1bd619c02', N'Vg3')
INSERT [dbo].[Trinn] ([Id], [Navn]) VALUES (N'd1d715f2-fccc-46fd-a63b-b65b1705e94d', N'Vg1')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'e2fd61fb-bd32-4377-a16c-26b379eb1b82', N'YF-Alle', N'4f0d9c08-4f63-441a-ad64-fd9d5a8108f9')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'ce0b1cdf-f983-4264-8b2d-596c5eba9c7a', N'Design og håndverk', N'e2fd61fb-bd32-4377-a16c-26b379eb1b82')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'8a98fc52-3262-4fd1-9c80-745845a93015', N'Service og samferdsel', N'e2fd61fb-bd32-4377-a16c-26b379eb1b82')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'2f79d406-80fc-449b-88cc-7a9a03d6fa97', N'Helse- og oppvekstfag', N'e2fd61fb-bd32-4377-a16c-26b379eb1b82')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'51df1c05-90c0-49c1-9bf0-7c2ad93bc8a3', N'Medier og kommunikasjon ', N'23f5a037-286f-4208-99dd-fa9fa66988a6')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'5d60f34d-c583-4fa7-80ad-81cf491d42c5', N'Elektrofag', N'e2fd61fb-bd32-4377-a16c-26b379eb1b82')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'3952ca8e-72c9-4692-89a2-85bf432d35ea', N'Kunst, design og arkitektur ', N'23f5a037-286f-4208-99dd-fa9fa66988a6')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'23c32996-bc63-4114-bb92-8d72b48325a3', N'Studiespesialisering ', N'23f5a037-286f-4208-99dd-fa9fa66988a6')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'8a2dacde-be25-4c6b-9c54-9101903a7e72', N'Teknikk og industriell produksjon', N'e2fd61fb-bd32-4377-a16c-26b379eb1b82')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'd6b1c425-4d0f-4817-b97b-92d2a470b98f', N'Naturbruk', N'e2fd61fb-bd32-4377-a16c-26b379eb1b82')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'20006252-084a-45b5-811d-aceafdd7a329', N'Design og håndverk - medieproduksjon', N'e2fd61fb-bd32-4377-a16c-26b379eb1b82')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'29c4870d-07e4-4763-9f5c-aef17f7183cf', N'Bygg- og anleggsteknikk', N'e2fd61fb-bd32-4377-a16c-26b379eb1b82')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'f1310c34-c98c-4b1a-a543-c55376c06626', N'Idrettsfag', N'23f5a037-286f-4208-99dd-fa9fa66988a6')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'343e9a88-0408-4557-94fe-cf2648a08081', N'Studiespesialisering ', N'e2fd61fb-bd32-4377-a16c-26b379eb1b82')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'801a232d-4e7a-4e71-8360-ddf1521d2f2e', N'Restaurant- og matfag', N'e2fd61fb-bd32-4377-a16c-26b379eb1b82')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'23f5a037-286f-4208-99dd-fa9fa66988a6', N'SF-Alle', N'4f0d9c08-4f63-441a-ad64-fd9d5a8108f9')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'94366852-7429-49aa-8879-fb8bef1d5590', N'Musikk, dans og drama ', N'23f5a037-286f-4208-99dd-fa9fa66988a6')
INSERT [dbo].[Utdanningsprogram] ([Id], [Navn], [OverordnetUtdanningsprogramId]) VALUES (N'4f0d9c08-4f63-441a-ad64-fd9d5a8108f9', N'Alle', NULL)");
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
