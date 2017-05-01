using System;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using VAF.Aktivitetsbank.Data;

namespace VAF.Aktivitetsbank.Data.Migrations
{
    [DbContext(typeof(AktivitetsbankContext))]
    [Migration("20170501180055_aktivitetsdeltakere_relasjon")]
    partial class aktivitetsdeltakere_relasjon
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

                    b.Property<string>("Beskrivelse")
                        .IsRequired();

                    b.Property<string>("Navn")
                        .IsRequired()
                        .HasMaxLength(50);

                    b.Property<int>("OmfangTimer");

                    b.Property<Guid>("SkoleId");

                    b.Property<string>("Type")
                        .IsRequired();

                    b.HasKey("Id");

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

                    b.Property<Guid>("AktivitetId");

                    b.Property<Guid>("FagId");

                    b.Property<string>("Kompetansemaal")
                        .IsRequired();

                    b.Property<int>("Timer");

                    b.Property<Guid>("TrinnId");

                    b.Property<Guid>("UtdanningsprogramId");

                    b.HasKey("Id");

                    b.HasIndex("AktivitetId");

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

            modelBuilder.Entity("VAF.Aktivitetsbank.Data.Entiteter.Deltaker", b =>
                {
                    b.HasOne("VAF.Aktivitetsbank.Data.Entiteter.Aktivitet")
                        .WithMany("Deltakere")
                        .HasForeignKey("AktivitetId")
                        .OnDelete(DeleteBehavior.Cascade);
                });
        }
    }
}
