using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore.Design;
using System.Diagnostics;

namespace VAF.Aktivitetsbank.Data
{
    public class AktivitetsbankContextFactory : IDesignTimeDbContextFactory<AktivitetsbankContext>
    {
        public AktivitetsbankContext CreateDbContext(string[] args)
        {
            var builder = new DbContextOptionsBuilder<AktivitetsbankContext>();
            IConfigurationRoot configuration = new ConfigurationBuilder()
              .SetBasePath(System.AppContext.BaseDirectory)
              //.SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
              .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
              .Build();
            Console.WriteLine("Henter connection string:");
            Console.WriteLine(configuration.GetConnectionString("DefaultConnection"));
            Console.WriteLine("Henter connection.. ferdig");

            builder.UseSqlServer(configuration.GetConnectionString("DefaultConnection"));
            return new AktivitetsbankContext(builder.Options);
        }
    }
}
