using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using VAF.Aktivitetsbank.Data;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    [DbContext(typeof(AktivitetsbankContext))]
    [Migration("20170515120311_skoleaar_table")]
    partial class skoleaar_table
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
            modelBuilder
                .HasAnnotation("ProductVersion", "1.1.1")
                .HasAnnotation("SqlServer:ValueGenerationStrategy", SqlServerValueGenerationStrategy.IdentityColumn);

            modelBuilder.Entity("VAF.Aktivitetsbank.Data.Entiteter.Aktivitet", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd();

                    b.Property<bool>("Aktiv");

                    b.Property<Guid>("AktivitetstypeId");

                    b.Property<string>("Beskrivelse")
                        .IsRequired();

                    b.Property<DateTime>("Endret");

                    b.Property<string>("EndretAv")
                        .IsRequired();

                    b.Property<string>("Navn")
                        .IsRequired()
                        .HasMaxLength(50);

                    b.Property<int>("OmfangTimer");

                    b.Property<DateTime>("Opprettet");

                    b.Property<string>("OpprettetAv")
                        .IsRequired();

                    b.Property<Guid>("SkoleId");

                    b.HasKey("Id");

                    b.HasIndex("AktivitetstypeId");

                    b.HasIndex("SkoleId");

                    b.ToTable("Aktivitet");
                });

            modelBuilder.Entity("VAF.Aktivitetsbank.Data.Entiteter.Aktivitetstype", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd();

                    b.Property<string>("Navn")
                        .IsRequired();

                    b.HasKey("Id");

                    b.ToTable("Aktivitetstype");
                });

            modelBuilder.Entity("VAF.Aktivitetsbank.Data.Entiteter.Deltaker", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd();

                    b.Property<bool>("Aktiv");

                    b.Property<Guid>("AktivitetId");

                    b.Property<DateTime>("Endret");

                    b.Property<string>("EndretAv")
                        .IsRequired();

                    b.Property<Guid>("FagId");

                    b.Property<string>("Kompetansemaal")
                        .IsRequired();

                    b.Property<DateTime>("Opprettet");

                    b.Property<string>("OpprettetAv")
                        .IsRequired();

                    b.Property<int>("Timer");

                    b.Property<Guid>("TrinnId");

                    b.Property<Guid>("UtdanningsprogramId");

                    b.HasKey("Id");

                    b.HasIndex("AktivitetId");

                    b.HasIndex("FagId");

                    b.HasIndex("TrinnId");

                    b.HasIndex("UtdanningsprogramId");

                    b.ToTable("Deltaker");
                });

            modelBuilder.Entity("VAF.Aktivitetsbank.Data.Entiteter.Fag", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd();

                    b.Property<string>("Navn")
                        .IsRequired();

                    b.HasKey("Id");

                    b.ToTable("Fag");
                });

            modelBuilder.Entity("VAF.Aktivitetsbank.Data.Entiteter.Skole", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd();

                    b.Property<string>("Kode")
                        .IsRequired();

                    b.Property<string>("Navn")
                        .IsRequired();

                    b.HasKey("Id");

                    b.ToTable("Skole");
                });

            modelBuilder.Entity("VAF.Aktivitetsbank.Data.Entiteter.SkoleAar", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd();

                    b.Property<string>("Navn")
                        .IsRequired();

                    b.HasKey("Id");

                    b.ToTable("SkoleAar");
                });

            modelBuilder.Entity("VAF.Aktivitetsbank.Data.Entiteter.Trinn", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd();

                    b.Property<string>("Navn")
                        .IsRequired();

                    b.HasKey("Id");

                    b.ToTable("Trinn");
                });

            modelBuilder.Entity("VAF.Aktivitetsbank.Data.Entiteter.Utdanningsprogram", b =>
                {
                    b.Property<Guid>("Id")
                        .ValueGeneratedOnAdd();

                    b.Property<string>("Navn")
                        .IsRequired();

                    b.Property<Guid?>("OverordnetUtdanningsprogramId");

                    b.HasKey("Id");

                    b.ToTable("Utdanningsprogram");
                });

            modelBuilder.Entity("VAF.Aktivitetsbank.Data.Entiteter.Aktivitet", b =>
                {
                    b.HasOne("VAF.Aktivitetsbank.Data.Entiteter.Aktivitetstype", "Aktivitetstype")
                        .WithMany("Aktiviteter")
                        .HasForeignKey("AktivitetstypeId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.HasOne("VAF.Aktivitetsbank.Data.Entiteter.Skole", "Skole")
                        .WithMany("Aktiviteter")
                        .HasForeignKey("SkoleId")
                        .OnDelete(DeleteBehavior.Cascade);
                });

            modelBuilder.Entity("VAF.Aktivitetsbank.Data.Entiteter.Deltaker", b =>
                {
                    b.HasOne("VAF.Aktivitetsbank.Data.Entiteter.Aktivitet", "Aktivitet")
                        .WithMany("Deltakere")
                        .HasForeignKey("AktivitetId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.HasOne("VAF.Aktivitetsbank.Data.Entiteter.Fag", "Fag")
                        .WithMany("Deltakere")
                        .HasForeignKey("FagId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.HasOne("VAF.Aktivitetsbank.Data.Entiteter.Trinn", "Trinn")
                        .WithMany("Deltakere")
                        .HasForeignKey("TrinnId")
                        .OnDelete(DeleteBehavior.Cascade);

                    b.HasOne("VAF.Aktivitetsbank.Data.Entiteter.Utdanningsprogram", "Utdanningsprogram")
                        .WithMany("Deltakere")
                        .HasForeignKey("UtdanningsprogramId")
                        .OnDelete(DeleteBehavior.Cascade);
                });
        }
    }
}
