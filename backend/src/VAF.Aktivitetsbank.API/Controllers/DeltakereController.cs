using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Commands;
using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.API.Controllers
{
    [Route("api/aktiviteter")]
    public class DeltakereController : Controller
    {
        private readonly IQueryDispatcher _queryDispatcher;
        private readonly ICommandDispatcher _commandDispatcher;
        private readonly ILogger<UserController> _logger;
        private readonly AppOptions _options;

        public DeltakereController(IQueryDispatcher queryDispatcher, ICommandDispatcher commandDispatcher, IOptions<AppOptions> options, ILogger<UserController> logger )
        {
            _queryDispatcher = queryDispatcher;
            _commandDispatcher = commandDispatcher;
            _logger = logger;
            _options = options.Value;
        }

        //[HttpGet("{query}")]
        [HttpGet("{aktivitetId}/deltakere")]
        public IEnumerable<DeltakerDto> Get(Guid aktivitetId)
        {
            _logger.LogInformation("Lister ut deltakere for aktivitet");
            return _queryDispatcher.Query<DeltakereSearchQuery, IList<DeltakerDto>>(new DeltakereSearchQuery(aktivitetId)).ToList();
        }
        [HttpGet("{aktivitetId}/deltakere/{deltakerId}")]
        public DeltakerDto Get(Guid aktivitetId, Guid deltakerId)
        {
            _logger.LogInformation("Henter deltaker");
            return _queryDispatcher.Query<DeltakerQuery, DeltakerDto>(new DeltakerQuery(aktivitetId, deltakerId));
        }
        //[AllowAnonymous]
        [HttpOptions("{aktivitetId}/opprettDeltaker")]
        public IActionResult GetOptions()
        {
            Response.Headers.Add("Allow", "GET, OPTIONS, POST");
            return Ok();
        }

        [HttpPost("{aktivitetId}/opprettDeltaker")]
        public IActionResult OpprettDeltaker(Guid aktivitetId, [FromBody] OpprettDeltakerDto opprettDeltakerDto)
        {
            if (opprettDeltakerDto == null || opprettDeltakerDto.AktivitetId != aktivitetId)
            {
                _logger.LogError("Feil data ved oppretting av deltaker. Mangler eller feil i input data.");
                return BadRequest();
            }
            if (!ModelState.IsValid)
            {
                _logger.LogError("Feil data ved oppretting av deltaker. Feil i input data.", ModelState);
                return BadRequest(ModelState);
            }

            try
            {
                _commandDispatcher.Execute(new OpprettDeltakerCommand(opprettDeltakerDto));
                return new NoContentResult();

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                _logger.LogError("Feil i oppretting av deltaker. Serverfeil.", e);
                return new StatusCodeResult(500);
            }
        }

    }
}
