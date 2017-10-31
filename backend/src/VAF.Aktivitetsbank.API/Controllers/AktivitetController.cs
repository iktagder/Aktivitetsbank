using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Runtime.InteropServices;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Microsoft.Extensions.Primitives;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Commands;
using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.API.Controllers
{
    [Route("aktiviteter")]
    public class AktivitetController : Controller
    {
        private readonly IQueryDispatcher _queryDispatcher;
        private readonly ICommandDispatcher _commandDispatcher;
        private readonly AppOptions _options;
        private readonly int _eventIdRead = 20000;
        private readonly int _eventIdModify = 21000;

        public AktivitetController(IQueryDispatcher queryDispatcher, ICommandDispatcher commandDispatcher, IOptions<AppOptions> options)
        {
            _queryDispatcher = queryDispatcher;
            _commandDispatcher = commandDispatcher;
            _options = options.Value;
        }

        [HttpGet]
        [ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
        public IEnumerable<AktivitetDto> Get()
        {
            var query = HttpContext.Request.QueryString.Value;
            var filter = OpprettFilter(query);
            var result = _queryDispatcher.Query<AktivitetSearchQuery, IList<AktivitetDto>>(new AktivitetSearchQuery(filter)).ToList();
            return result;
        }


        private static FilterDto OpprettFilter(string query)
        {
            var queryDictionary = Microsoft.AspNetCore.WebUtilities.QueryHelpers.ParseQuery(query);
            var filter = new FilterDto();
            filter.Skoler = HentFilterVerdier("filter[skoler]", queryDictionary);
            filter.Aktivitetstyper = HentFilterVerdier("filter[aktivitetstyper]", queryDictionary);
            filter.SkoleAar = HentFilterVerdier("filter[skoleaar]", queryDictionary);
            filter.Utdanningsprogrammer = HentFilterVerdier("filter[utdanningsprogram]", queryDictionary);
            filter.TrinnListe = HentFilterVerdier("filter[trinn]", queryDictionary);
            filter.FagListe = HentFilterVerdier("filter[fag]", queryDictionary);
            filter.FriTekst = HentFritekstFilter("filter[fritekst]", queryDictionary);
            return filter;
        }

        private static List<Guid> HentFilterVerdier(string key, Dictionary<string, StringValues> queryDictionary)
        {
            if (queryDictionary.ContainsKey(key))
            {
                var verdier = new List<Guid>();
                foreach (var stringValue in queryDictionary[key].ToString().Split(','))
                {
                    Guid newGuid;
                    var success = Guid.TryParse(stringValue, out newGuid);
                    if (success)
                    {
                        verdier.Add(newGuid);
                    }
                }
                return verdier.Count > 0 ? verdier : null;
            }
            return null;
        }

        private static string HentFritekstFilter(string key, Dictionary<string, StringValues> queryDictionary)
        {
            if (queryDictionary.ContainsKey(key))
            {
                return queryDictionary[key].FirstOrDefault();
            }
            return null;
        }

        [HttpGet("{id}")]
        [ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
        public AktivitetDto GetAktivitet(Guid id)
        {
            var result = _queryDispatcher.Query<AktivitetQuery, AktivitetDto>(new AktivitetQuery(id));
            return result;
        }

        //[AllowAnonymous]
        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpOptions("opprettAktivitet")]
        public IActionResult GetOptions()
        {
            Response.Headers.Add("Allow", "GET, OPTIONS, POST");
            return Ok();
        }

        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpPost("opprettAktivitet")]
        public IActionResult OpprettAktivitet([FromBody] OpprettAktivitetDto opprettAktivitetDto)
        {
            if (opprettAktivitetDto == null)
            {
                return BadRequest();
            }
            opprettAktivitetDto.Id = Guid.NewGuid();
            opprettAktivitetDto.BrukerId = HttpContext.User.Identity.Name;
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            try
            {
                _commandDispatcher.Execute(new OpprettAktivitetCommand(opprettAktivitetDto));
                //return new NoContentResult();
                return new CreatedAtRouteResult("opprettaktivitet", new {id = opprettAktivitetDto.Id});

            }
            catch (Exception e)
            {
                return new StatusCodeResult(500);
            }
        }


        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpPost("{aktivitetId}/kopier")]
        public IActionResult KopierAktivitet(Guid aktivitetId, [FromBody] KopierAktivitetDto kopierAktivitetDto)
        {
            if (kopierAktivitetDto == null || kopierAktivitetDto.Id != aktivitetId)
            {
                return BadRequest();
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }
            kopierAktivitetDto.NyAktivitetId = Guid.NewGuid();
            kopierAktivitetDto.BrukerId = HttpContext.User.Identity.Name;

            try
            {
                _commandDispatcher.Execute(new KopierAktivitetCommand(kopierAktivitetDto));
                return new CreatedAtRouteResult("kopier", new {id = kopierAktivitetDto.NyAktivitetId});

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return new StatusCodeResult(500);
            }
        }


        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpPut("{id}")]
        public IActionResult EndreAktivitet(Guid id, [FromBody] EndreAktivitetDto endreAktivitetDto)
        {
            if (endreAktivitetDto == null || endreAktivitetDto.Id != id)
            {
                return BadRequest();
            }
            if (!ModelState.IsValid)
            {
                return BadRequest(ModelState);
            }

            endreAktivitetDto.BrukerId = HttpContext.User.Identity.Name;
            try
            {
                _commandDispatcher.Execute(new EndreAktivitetCommand(endreAktivitetDto));
                return new NoContentResult();

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return new StatusCodeResult(500);
            }
        }
        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpDelete("{id}")]
        public IActionResult SlettAktivitet(Guid id)
        {
            //validere guid? nullable?
            if (id == Guid.Empty)
            {
                return BadRequest();
            }
            var slettAktivitetDto = new SlettAktivitetDto()
            {
                Id = id,
                BrukerId = HttpContext.User.Identity.Name
            };
            try
            {
                _commandDispatcher.Execute(new SlettAktivitetCommand(slettAktivitetDto));
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
