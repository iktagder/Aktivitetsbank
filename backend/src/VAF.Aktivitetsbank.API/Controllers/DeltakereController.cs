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
        private readonly AppOptions _options;
        private readonly int _eventIdRead = 30000;
        private readonly int _eventIdModify = 31000;

        public DeltakereController(IQueryDispatcher queryDispatcher, ICommandDispatcher commandDispatcher, IOptions<AppOptions> options)
        {

            _queryDispatcher = queryDispatcher;
            _commandDispatcher = commandDispatcher;
            _options = options.Value;
        }

        [HttpGet("{aktivitetId}/deltakere")]
        [ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
        public IEnumerable<DeltakerDto> Get(Guid aktivitetId)
        {
            var result = _queryDispatcher.Query<DeltakereSearchQuery, IList<DeltakerDto>>(new DeltakereSearchQuery(aktivitetId)).ToList();
            return result;
        }
        [HttpGet("{aktivitetId}/deltakere/{deltakerId}")]
        [ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
        public DeltakerDto Get(Guid aktivitetId, Guid deltakerId)
        {
            var result = _queryDispatcher.Query<DeltakerQuery, DeltakerDto>(new DeltakerQuery(aktivitetId, deltakerId));
            return result;
        }
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
            if (opprettDeltakerDto == null || opprettDeltakerDto.AktivitetId != aktivitetId)
            {
                return BadRequest();
            }
            opprettDeltakerDto.Id = Guid.NewGuid();
            opprettDeltakerDto.BrukerId = HttpContext.User.Identity.Name;
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                _commandDispatcher.Execute(new OpprettDeltakerCommand(opprettDeltakerDto));
                //return new NoContentResult();
                return new CreatedAtRouteResult("opprettDeltaker", new {id = opprettDeltakerDto.Id});

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return new StatusCodeResult(500);
            }
        }

        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpPut("{aktivitetId}/deltakere/{deltakerId}")]
        public IActionResult EndreDeltaker(Guid aktivitetId, Guid deltakerId, [FromBody] EndreDeltakerDto endreDeltakerDto)
        {
            if (endreDeltakerDto == null || endreDeltakerDto.Id != deltakerId || endreDeltakerDto.AktivitetId != aktivitetId)
            {

                return BadRequest();
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            endreDeltakerDto.BrukerId = HttpContext.User.Identity.Name;

            try
            {
                _commandDispatcher.Execute(new EndreDeltakerCommand(endreDeltakerDto));
                return new NoContentResult();

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return new StatusCodeResult(500);
            }
        }

        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpDelete("{aktivitetId}/deltakere/{deltakerId}")]
        public IActionResult SlettDeltaker(Guid aktivitetId, Guid deltakerId)
        {
            if (aktivitetId == Guid.Empty || deltakerId == Guid.Empty)
            {

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
                return new NoContentResult();

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return new StatusCodeResult(500);
            }
        }

    }
}
