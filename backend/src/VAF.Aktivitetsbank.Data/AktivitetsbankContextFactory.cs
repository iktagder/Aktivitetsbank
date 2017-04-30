using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.Extensions.Configuration;

namespace VAF.Aktivitetsbank.Data
{
    public class AktivitetsbankContextFactory : IDbContextFactory<AktivitetsbankContext>
    {
        private IConfigurationRoot _configuration;

        public AktivitetsbankContextFactory()
        {
            var builder = new Microsoft.Extensions.Configuration.ConfigurationBuilder()
                .SetBasePath(System.AppContext.BaseDirectory)
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);

            _configuration = builder.Build();
        }

        public AktivitetsbankContext Create()
        {
            var optionsBuilder = new DbContextOptionsBuilder<AktivitetsbankContext>();
            optionsBuilder.UseSqlServer(_configuration.GetConnectionString("DefaultConnection"), m => { m.EnableRetryOnFailure(); });

            return new AktivitetsbankContext(optionsBuilder.Options);
        }

        public AktivitetsbankContext Create(DbContextFactoryOptions options)
        {
            var optionsBuilder = new DbContextOptionsBuilder<AktivitetsbankContext>();
            optionsBuilder.UseSqlServer(_configuration.GetConnectionString("DefaultConnection"), m => { m.EnableRetryOnFailure(); });

            return new AktivitetsbankContext(optionsBuilder.Options);
        }
    }
}
