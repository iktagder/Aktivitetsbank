using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using VAF.Aktivitetsbank.Data.Entiteter;

namespace VAF.Aktivitetsbank.Data
{
    public class AktivitetsbankContext : DbContext
    {
        public AktivitetsbankContext(DbContextOptions<AktivitetsbankContext> options) : base(options)
        {
            
        }


        public DbSet<Fag> FagSet { get; set; }
        public DbSet<Trinn> TrinnSet { get; set; }
        public DbSet<Skole> SkoleSet { get; set; }
        public DbSet<Aktivitetstype> AktivitetstypeSet { get; set; }
        public DbSet<Utdanningsprogram> UtdanningsprogramSet { get; set; }
        public DbSet<Aktivitet> AktivitetSet { get; set; }
        public DbSet<Deltaker> DeltakerSet { get; set; }
        public DbSet<SkoleAar> SkoleAarSet { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Fag>().ToTable("Fag");
            modelBuilder.Entity<Trinn>().ToTable("Trinn");
            modelBuilder.Entity<Skole>().ToTable("Skole");
            modelBuilder.Entity<Aktivitetstype>().ToTable("Aktivitetstype");
            modelBuilder.Entity<Utdanningsprogram>().ToTable("Utdanningsprogram");
            modelBuilder.Entity<Aktivitet>().ToTable("Aktivitet");
            modelBuilder.Entity<Deltaker>().ToTable("Deltaker");
            modelBuilder.Entity<SkoleAar>().ToTable("SkoleAar");
        }

        //protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        //{
        //    optionsBuilder.UseSqlServer(
        //        "Server=(localdb)\\mssqllocaldb;Database=Aktivitetsbank_dev;Trusted_Connection=True;MultipleActiveResultSets=true");
        //}
    }

}
