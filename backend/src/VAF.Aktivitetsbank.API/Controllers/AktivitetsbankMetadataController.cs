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
        private readonly int _eventIdRead = 40000;
        //private readonly int _eventIdModify = 41000;

        public AktivitetsbankMetadataController(IQueryDispatcher queryDispatcher, ICommandDispatcher commandDispatcher)
        {
            _queryDispatcher = queryDispatcher;
            _commandDispatcher = commandDispatcher;
        }


        [HttpGet]
        public AktivitetsbankMetadata Get()
        {
            var result = _queryDispatcher.Query<AktivitetsbankMetadataQuery, AktivitetsbankMetadata>(new AktivitetsbankMetadataQuery());
            return result;
        }
    }
}
