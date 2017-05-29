using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using Microsoft.AspNetCore.Authorization;
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
    [Route("aktiviteter")]
    public class DeltakereController : Controller
    {
        private readonly IQueryDispatcher _queryDispatcher;
        private readonly ICommandDispatcher _commandDispatcher;
        private readonly ILogger<UserController> _logger;
        private readonly AppOptions _options;
        private readonly int _eventIdRead = 30000;
        private readonly int _eventIdModify = 31000;

        public DeltakereController(IQueryDispatcher queryDispatcher, ICommandDispatcher commandDispatcher, IOptions<AppOptions> options, ILogger<UserController> logger )
        {

            _queryDispatcher = queryDispatcher;
            _commandDispatcher = commandDispatcher;
            _logger = logger;
            _options = options.Value;
        }

        [HttpGet("{aktivitetId}/deltakere")]
        [ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
        public IEnumerable<DeltakerDto> Get(Guid aktivitetId)
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation(_eventIdRead + 1, "Lister ut deltakere for aktivitet {AktivitetId}. Brukernavn: {Brukernavn}", aktivitetId, HttpContext.User.Identity.Name);
            var result = _queryDispatcher.Query<DeltakereSearchQuery, IList<DeltakerDto>>(new DeltakereSearchQuery(aktivitetId)).ToList();
            watch.Stop();
            _logger.LogInformation(_eventIdRead + 2, "Lister ut deltakere for aktivitet {AktivitetId} - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", aktivitetId, watch.ElapsedMilliseconds, HttpContext.User.Identity.Name);
            return result;
        }
        [HttpGet("{aktivitetId}/deltakere/{deltakerId}")]
        [ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
        public DeltakerDto Get(Guid aktivitetId, Guid deltakerId)
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation(_eventIdRead + 10, "Henter deltaker {DeltakerId}. Brukernavn: {Brukernavn}", deltakerId, HttpContext.User.Identity.Name);
            var result = _queryDispatcher.Query<DeltakerQuery, DeltakerDto>(new DeltakerQuery(aktivitetId, deltakerId));
            watch.Stop();
            _logger.LogInformation(_eventIdRead + 11, "Henter deltaker {DeltakerId} - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", deltakerId, watch.ElapsedMilliseconds, HttpContext.User.Identity.Name);
            return result;
        }
        //[AllowAnonymous]
        [HttpOptions("{aktivitetId}/opprettDeltaker")]
        public IActionResult GetOptions()
        {
            Response.Headers.Add("Allow", "GET, OPTIONS, POST");
            return Ok();
        }

        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpPost("{aktivitetId}/opprettDeltaker")]
        public IActionResult OpprettDeltaker(Guid aktivitetId, [FromBody] OpprettDeltakerDto opprettDeltakerDto)
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation(_eventIdModify + 1, "Opprett deltaker. Brukernavn: {Brukernavn}", HttpContext.User.Identity.Name);
            if (opprettDeltakerDto == null || opprettDeltakerDto.AktivitetId != aktivitetId)
            {
                _logger.LogError("Feil data ved oppretting av deltaker. Mangler eller feil i input data. Brukernavn: {0}", HttpContext.User.Identity.Name);

                return BadRequest();
            }
            opprettDeltakerDto.Id = Guid.NewGuid();
            opprettDeltakerDto.BrukerId = HttpContext.User.Identity.Name;
            if (!ModelState.IsValid)
            {
                _logger.LogError("Feil data ved oppretting av deltaker. Feil i input data.", ModelState);
                return BadRequest(ModelState);
            }

            try
            {
                _commandDispatcher.Execute(new OpprettDeltakerCommand(opprettDeltakerDto));
                //return new NoContentResult();
                watch.Stop();
                _logger.LogInformation(_eventIdModify + 2, "Opprett deltaker {DeltakerId} - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", opprettDeltakerDto.Id, watch.ElapsedMilliseconds, HttpContext.User.Identity.Name);
                return new CreatedAtRouteResult("opprettDeltaker", new {id = opprettDeltakerDto.Id});

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                _logger.LogError("Feil i oppretting av deltaker. Serverfeil.", e);
                return new StatusCodeResult(500);
            }
        }

        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpPut("{aktivitetId}/deltakere/{deltakerId}")]
        public IActionResult EndreDeltaker(Guid aktivitetId, Guid deltakerId, [FromBody] EndreDeltakerDto endreDeltakerDto)
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation(_eventIdModify + 10, "Endre deltaker {DeltakerId}. Brukernavn: {Brukernavn}", deltakerId, HttpContext.User.Identity.Name);
            if (endreDeltakerDto == null || endreDeltakerDto.Id != deltakerId || endreDeltakerDto.AktivitetId != aktivitetId)
            {
                _logger.LogError("Feil data ved endring av deltaker. Mangler input data. Brukernavn: {Brukernavn}", HttpContext.User.Identity.Name);

                return BadRequest();
            }
            if (!ModelState.IsValid)
            {
                _logger.LogError("Feil data ved endring av deltaker. Feil i input data.", ModelState);
                return BadRequest(ModelState);
            }
            endreDeltakerDto.BrukerId = HttpContext.User.Identity.Name;

            try
            {
                _commandDispatcher.Execute(new EndreDeltakerCommand(endreDeltakerDto));
                watch.Stop();
                _logger.LogInformation(_eventIdModify + 11, "Endre deltaker {DeltakerId} - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", deltakerId, watch.ElapsedMilliseconds, HttpContext.User.Identity.Name);
                return new NoContentResult();

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                _logger.LogError("Feil i endring av deltaker. Serverfeil.", e);
                return new StatusCodeResult(500);
            }
        }

        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpDelete("{aktivitetId}/deltakere/{deltakerId}")]
        public IActionResult SlettDeltaker(Guid aktivitetId, Guid deltakerId)
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation(_eventIdModify + 20, "Slett deltaker {DeltakerId}. Brukernavn: {Brukernavn}", deltakerId, HttpContext.User.Identity.Name);
            if (aktivitetId == Guid.Empty || deltakerId == Guid.Empty)
            {
                _logger.LogError("Feil data ved sletting av deltaker. Mangler input data. Brukernavn: {Brukernavn}", HttpContext.User.Identity.Name);

                return BadRequest();
            }
            var slettDeltakerDto = new SlettDeltakerDto()
            {
                Id = deltakerId,
                AktivitetId = aktivitetId,
                BrukerId = HttpContext.User.Identity.Name
            };
            try
            {
                _commandDispatcher.Execute(new SlettDeltakerCommand(slettDeltakerDto));
                watch.Stop();
                _logger.LogInformation(_eventIdModify + 21, "Slett deltaker {DeltakerId} - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", deltakerId, watch.ElapsedMilliseconds, HttpContext.User.Identity.Name);
                return new NoContentResult();

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                _logger.LogError("Feil i sletting av deltaker. Serverfeil.", e);
                return new StatusCodeResult(500);
            }
        }

    }
}
