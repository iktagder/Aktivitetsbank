using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class skoleaar_aktivitet_fk : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            //migrationBuilder.AlterColumn<Guid>(
            //    name: "SkoleAarId",
            //    table: "Aktivitet",
            //    nullable: false,
            //    oldClrType: typeof(Guid),
            //    oldNullable: true);
            migrationBuilder.Sql(@"DECLARE @default1 sysname;
SELECT @default1 = [d].[name]
FROM [sys].[default_constraints] [d]
INNER JOIN [sys].[columns] [c] ON [d].[parent_column_id] = [c].[column_id] AND [d].[parent_object_id] = [c].[object_id]
WHERE ([d].[parent_object_id] = OBJECT_ID(N'Aktivitet') AND [c].[name] = N'SkoleAarId');
IF @default1 IS NOT NULL EXEC(N'ALTER TABLE [Aktivitet] DROP CONSTRAINT [' + @default1 + '];');
ALTER TABLE [Aktivitet] ALTER COLUMN [SkoleAarId] uniqueidentifier NOT NULL;");

            migrationBuilder.CreateIndex(
                name: "IX_Aktivitet_SkoleAarId",
                table: "Aktivitet",
                column: "SkoleAarId");

            migrationBuilder.AddForeignKey(
                name: "FK_Aktivitet_SkoleAar_SkoleAarId",
                table: "Aktivitet",
                column: "SkoleAarId",
                principalTable: "SkoleAar",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Aktivitet_SkoleAar_SkoleAarId",
                table: "Aktivitet");

            migrationBuilder.DropIndex(
                name: "IX_Aktivitet_SkoleAarId",
                table: "Aktivitet");

            migrationBuilder.AlterColumn<Guid>(
                name: "SkoleAarId",
                table: "Aktivitet",
                nullable: true,
                oldClrType: typeof(Guid));
        }
    }
}
