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
    public class AktivitetController : Controller
    {
        private readonly IQueryDispatcher _queryDispatcher;
        private readonly ICommandDispatcher _commandDispatcher;
        private readonly ILogger<UserController> _logger;
        private readonly AppOptions _options;

        public AktivitetController(IQueryDispatcher queryDispatcher, ICommandDispatcher commandDispatcher, IOptions<AppOptions> options, ILogger<UserController> logger )
        {
            _queryDispatcher = queryDispatcher;
            _commandDispatcher = commandDispatcher;
            _logger = logger;
            _options = options.Value;
        }

        [HttpGet]
        public IEnumerable<AktivitetDto> Get()
        {
            _logger.LogInformation("Lister ut aktiviteter");
            return _queryDispatcher.Query<AktivitetSearchQuery, IList<AktivitetDto>>(new AktivitetSearchQuery("")).ToList();
        }

        [HttpGet("{id}")]
        public AktivitetDto GetAktivitet(Guid id)
        {
            _logger.LogInformation("Aktivitet detalj");
            return _queryDispatcher.Query<AktivitetQuery, AktivitetDto>(new AktivitetQuery(id));
        }

        //[AllowAnonymous]
        [HttpOptions("opprettAktivitet")]
        public IActionResult GetOptions()
        {
            Response.Headers.Add("Allow", "GET, OPTIONS, POST");
            return Ok();
        }

        [HttpPost("opprettAktivitet")]
        public IActionResult OpprettAktivitet([FromBody] OpprettAktivitetDto opprettAktivitetDto)
        {
            if (opprettAktivitetDto == null)
            {
                _logger.LogError("Feil data ved oppretting av aktivitet. Mangler input data.");
                return BadRequest();
            }
            if (!ModelState.IsValid)
            {
                _logger.LogError("Feil data ved oppretting av aktivitet. Feil i input data.", ModelState);
                return BadRequest(ModelState);
            }

            try
            {
                _commandDispatcher.Execute(new OpprettAktivitetCommand(opprettAktivitetDto));
                return new NoContentResult();

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                _logger.LogError("Feil i oppretting av aktivitet. Serverfeil.", e);
                return new StatusCodeResult(500);
            }
        }
    }
}
