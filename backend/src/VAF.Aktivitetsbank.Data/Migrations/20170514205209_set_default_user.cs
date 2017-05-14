using System;
using System.Collections.Generic;
using Microsoft.EntityFrameworkCore.Migrations;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    public partial class set_default_user : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"UPDATE dbo.Aktivitet SET OpprettetAv = 'System'
              where OpprettetAv IS NULL");

            migrationBuilder.Sql(@"UPDATE dbo.Aktivitet SET EndretAv = 'System'
              where EndretAv IS NULL");

            migrationBuilder.Sql(@"UPDATE dbo.Deltaker SET OpprettetAv = 'System'
              where OpprettetAv IS NULL");

            migrationBuilder.Sql(@"UPDATE dbo.Deltaker SET EndretAv = 'System'
              where EndretAv IS NULL");

        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
