using System;
using System.Collections.Generic;
using System.Net;
using Autofac;
using Autofac.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Diagnostics;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;
using Serilog;
using Swashbuckle.AspNetCore.Swagger;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Commands;
using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Application.Queries;
using VAF.Aktivitetsbank.API.Authorization;
using VAF.Aktivitetsbank.Data;
using VAF.Aktivitetsbank.Data.Entiteter;
using VAF.Aktivitetsbank.Domain;
using VAF.Aktivitetsbank.Infrastructure;

namespace VAF.Aktivitetsbank.API
{
    public class Startup
    {
        private IHostingEnvironment currentEnvironment;

        public Startup(IHostingEnvironment env)
        {
            var builder = new ConfigurationBuilder()
                .SetBasePath(env.ContentRootPath)
                .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true)
                .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true)
                .AddEnvironmentVariables();
            Configuration = builder.Build();

            Log.Logger = new LoggerConfiguration()
              .ReadFrom.Configuration(Configuration)
              .CreateLogger();

            currentEnvironment = env;
        }

        public IConfigurationRoot Configuration { get; }

        public IContainer ApplicationContainer { get; private set; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public IServiceProvider ConfigureServices(IServiceCollection services)
        {
            services.Configure<AppOptions>(Configuration.GetSection("VafOptions"));
            // Add framework services.
            services.Configure<IISOptions>(options =>
            {
                options.ForwardWindowsAuthentication = true;
            });

            services.AddAuthorization(options =>
            {
                options.AddPolicy("CanChangePhoneNumbers", policyBuilder => policyBuilder.AddRequirements(new IsPhoneAdminRequirement()));
            });


            // Tilgang avhenging av miljø
            if (currentEnvironment.IsDevelopment())
            {
                services.AddSingleton<IAuthorizationHandler, DevelopmentAuthHandler>();
            }
            else
            {
                services.AddSingleton<IAuthorizationHandler, PhoneAdminAuthHandler>();
            }
            services.AddDbContext<AktivitetsbankContext>(
                options => options.UseSqlServer(Configuration.GetConnectionString("DefaultConnection")));

            services.AddMvc(opts =>
            {
                opts.Filters.Add(new CustomAuthorize(new AuthorizationPolicyBuilder().RequireAuthenticatedUser().Build()));
                var policy = new AuthorizationPolicyBuilder()
                    .RequireAuthenticatedUser()
                    .Build();
                opts.Filters.Add(new AuthorizeFilter(policy));
            });
            services.AddCors();

            //Register the Swagger generator, defining one or more Swagger documents
            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new Info { Title = "VAF.Telefonskjema API", Version = "v1" });
            });

            var builder = new ContainerBuilder();

            builder.RegisterType<QueryDispatcher>().As<IQueryDispatcher>();
            builder.RegisterType<CommandDispatcher>().As<ICommandDispatcher>();
            builder.RegisterType<EventDispatcher>().As<IEventDispatcher>();
            builder.RegisterType<NotificationQueueHandler>().As<IEventHandler<NumberChangedEvent>>();

            builder.RegisterType < AktivitetsbankMetadataQueryHandler>().As<IQueryHandler<AktivitetsbankMetadataQuery, AktivitetsbankMetadata>>();
            builder.RegisterType < AktivitetSearchQueryHandler>().As<IQueryHandler<AktivitetSearchQuery, IList<AktivitetDto>>>();
            builder.RegisterType < AktivitetQueryHandler>().As<IQueryHandler<AktivitetQuery, AktivitetDto>>();
            builder.RegisterType < DeltakereSearchQueryHandler>().As<IQueryHandler<DeltakereSearchQuery, IList<DeltakerDto>>>();
            builder.RegisterType < DeltakerQueryHandler>().As<IQueryHandler<DeltakerQuery, DeltakerDto>>();
            builder.RegisterType<OpprettAktivitetCommandHandler>().As<ICommandHandler<OpprettAktivitetCommand>>();
            builder.RegisterType<EndreAktivitetCommandHandler>().As<ICommandHandler<EndreAktivitetCommand>>();
            builder.RegisterType<OpprettDeltakerCommandHandler>().As<ICommandHandler<OpprettDeltakerCommand>>();
            builder.RegisterType<EndreDeltakerCommandHandler>().As<ICommandHandler<EndreDeltakerCommand>>();
            builder.RegisterType<AktivitetsbankService>().As<IAktivitetsbankService>();
            builder.RegisterType<RabbitMqNotificationService>().As<INotificationService<NumberChangedEvent>>();


            builder.Populate(services);
            ApplicationContainer = builder.Build();

            //RegisterCommandHandlers();
            return new AutofacServiceProvider(ApplicationContainer);

        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, ILoggerFactory loggerFactory, IApplicationLifetime appLifeTime)
        {
            if (env.IsDevelopment())
            {
                loggerFactory.AddSerilog();
                appLifeTime.ApplicationStopped.Register(Log.CloseAndFlush);
            }
            else
            {
                loggerFactory.AddSerilog();
                appLifeTime.ApplicationStopped.Register(Log.CloseAndFlush);
            }
            app.UseExceptionHandler(
             builder =>
             {
                 builder.Run(
                   async context =>
                   {
                       context.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
                       context.Response.ContentType = "text/html";

                       var error = context.Features.Get<IExceptionHandlerFeature>();
                       if (error != null)
                       {
                           await context.Response.WriteAsync($"<h1>Error: {error.Error.Message}</h1>").ConfigureAwait(false);
                           var logger = loggerFactory.CreateLogger("Global exception logger");
                           logger.LogError(500, error.Error, error.Error.Message);
                       }
                   });
             });

            if (env.IsDevelopment())
            {
                app.UseCors(builder =>
                    builder.WithOrigins("http://localhost:8080").AllowAnyMethod().AllowAnyHeader().AllowCredentials());
            }
            AutoMapper.Mapper.Initialize(cfg =>
            {
                cfg.CreateMap<Skole, SkoleDto>();
                cfg.CreateMap<Trinn, TrinnDto>();
                cfg.CreateMap<Fag, FagDto>();
                cfg.CreateMap<Aktivitetstype, AktivitetstypeDto>();
                cfg.CreateMap<Utdanningsprogram, UtdanningsprogramDto>();
                cfg.CreateMap<Aktivitet, AktivitetDto>();
                cfg.CreateMap<Deltaker, DeltakerDto>();

            });
            
            app.UseMvc();


            if (env.IsDevelopment())
            {
                // Enable middleware to serve generated Swagger as a JSON endpoint.
                app.UseSwagger();

                // Enable middleware to serve swagger-ui (HTML, JS, CSS etc.), specifying the Swagger JSON endpoint.
                app.UseSwaggerUI(c =>
                {
                    c.SwaggerEndpoint("/swagger/v1/swagger.json", "VAF.Aktivitetsbank API v1");
                });
            }
        }
    }
}
