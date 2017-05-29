using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Commands;
using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.API.Controllers
{
    [Route("[controller]")]
    public class AktivitetsbankMetadataController : Controller
    {
        private readonly IQueryDispatcher _queryDispatcher;
        private readonly ICommandDispatcher _commandDispatcher;
        private readonly ILogger<AktivitetsbankMetadataController> _logger;

        public AktivitetsbankMetadataController(IQueryDispatcher queryDispatcher, ICommandDispatcher commandDispatcher, ILogger<AktivitetsbankMetadataController> logger)
        {
            _queryDispatcher = queryDispatcher;
            _commandDispatcher = commandDispatcher;
            _logger = logger;
        }


        [HttpGet]
        public AktivitetsbankMetadata Get()
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation("Henter metadata. Brukernavn: {Brukernavn}", HttpContext.User.Identity.Name);
            var result = _queryDispatcher.Query<AktivitetsbankMetadataQuery, AktivitetsbankMetadata>(new AktivitetsbankMetadataQuery());
            watch.Stop();
            _logger.LogInformation("Henter metadata - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", watch.Elapsed.Milliseconds, HttpContext.User.Identity.Name);
            return result;
        }
    }
}
