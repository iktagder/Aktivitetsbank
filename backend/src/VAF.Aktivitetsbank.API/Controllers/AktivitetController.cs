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
        [ResponseCache(Location = ResponseCacheLocation.None, NoStore = true)]
        public IEnumerable<AktivitetDto> Get()
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation("Lister ut aktiviteter. Brukernavn: {Brukernavn}", HttpContext.User.Identity.Name);
            var query = HttpContext.Request.QueryString.Value;
            _logger.LogInformation("Lister ut aktiviteter - Spørring: {Query}. Brukernavn: {Brukernavn}", query, HttpContext.User.Identity.Name);
            var filter = OpprettFilter(query);
            var result = _queryDispatcher.Query<AktivitetSearchQuery, IList<AktivitetDto>>(new AktivitetSearchQuery(filter)).ToList();
            watch.Stop();
            _logger.LogInformation("Lister ut aktiviteter - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", watch.ElapsedMilliseconds, HttpContext.User.Identity.Name);
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
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation("Aktivitet detalj {AktivitetId}. Brukernavn: {Brukernavn}", id, HttpContext.User.Identity.Name);
            var result = _queryDispatcher.Query<AktivitetQuery, AktivitetDto>(new AktivitetQuery(id));
            watch.Stop();
            _logger.LogInformation("Aktivitet detalj {AktivitetId} - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", id, watch.ElapsedMilliseconds, HttpContext.User.Identity.Name);
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
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation("Aktivitet oppretting. Brukernavn: {Brukernavn}", HttpContext.User.Identity.Name);
            if (opprettAktivitetDto == null)
            {
                _logger.LogError("Feil data ved oppretting av aktivitet. Mangler input data. Brukernavn: {Brukernavn}", HttpContext.User.Identity.Name);
                watch.Stop();
                return BadRequest();
            }
            opprettAktivitetDto.Id = Guid.NewGuid();
            opprettAktivitetDto.BrukerId = HttpContext.User.Identity.Name;
            if (!ModelState.IsValid)
            {
                _logger.LogError("Feil data ved oppretting av aktivitet. Feil i input data.", ModelState);
                watch.Stop();
                return BadRequest(ModelState);
            }

            try
            {
                _commandDispatcher.Execute(new OpprettAktivitetCommand(opprettAktivitetDto));
                //return new NoContentResult();
                watch.Stop();
                _logger.LogInformation("Aktivitet oppretting {AktivitetId} - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", opprettAktivitetDto.Id, watch.ElapsedMilliseconds, HttpContext.User.Identity.Name);
                return new CreatedAtRouteResult("opprettaktivitet", new {id = opprettAktivitetDto.Id});

            }
            catch (Exception e)
            {
                watch.Stop();
                _logger.LogError("Feil i oppretting av aktivitet. Serverfeil.", e);
                return new StatusCodeResult(500);
            }
        }


        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpPost("{aktivitetId}/kopier")]
        public IActionResult KopierAktivitet(Guid aktivitetId, [FromBody] KopierAktivitetDto kopierAktivitetDto)
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation("Aktivitet kopiering fra {AktivitetId}. Brukernavn: {Brukernavn}", aktivitetId, HttpContext.User.Identity.Name);
            if (kopierAktivitetDto == null || kopierAktivitetDto.Id != aktivitetId)
            {
                _logger.LogError("Feil data ved kopiering av aktivitet. Mangler input data. Brukernavn: {Brukernavn}", HttpContext.User.Identity.Name);
                return BadRequest();
            }
            if (!ModelState.IsValid)
            {
                _logger.LogError("Feil data ved kopiering av aktivitet. Feil i input data.", ModelState);
                return BadRequest(ModelState);
            }
            kopierAktivitetDto.NyAktivitetId = Guid.NewGuid();
            kopierAktivitetDto.BrukerId = HttpContext.User.Identity.Name;

            try
            {
                _commandDispatcher.Execute(new KopierAktivitetCommand(kopierAktivitetDto));
                watch.Stop();
                _logger.LogInformation("Aktivitet kopiering fra {AktivitetId} til {KopiertTilAktivitetId} - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", aktivitetId, kopierAktivitetDto.NyAktivitetId, watch.ElapsedMilliseconds, HttpContext.User.Identity.Name);
                return new CreatedAtRouteResult("kopier", new {id = kopierAktivitetDto.NyAktivitetId});

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                _logger.LogError("Feil i kopiering av aktivitet. Serverfeil.", e);
                return new StatusCodeResult(500);
            }
        }


        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpPut("{id}")]
        public IActionResult EndreAktivitet(Guid id, [FromBody] EndreAktivitetDto endreAktivitetDto)
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation("Aktivitet endring {AktivitetId}. Brukernavn: {Brukernavn}", id, HttpContext.User.Identity.Name);
            if (endreAktivitetDto == null || endreAktivitetDto.Id != id)
            {
                _logger.LogError("Feil data ved endring av aktivitet. Mangler input data. Brukernavn: {Brukernavn}", HttpContext.User.Identity.Name);
                return BadRequest();
            }
            if (!ModelState.IsValid)
            {
                _logger.LogError("Feil data ved endring av aktivitet. Feil i input data.", ModelState);
                return BadRequest(ModelState);
            }

            endreAktivitetDto.BrukerId = HttpContext.User.Identity.Name;
            try
            {
                _commandDispatcher.Execute(new EndreAktivitetCommand(endreAktivitetDto));
                watch.Stop();
                _logger.LogInformation("Aktivitet endring {AktivitetId} - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", id, watch.ElapsedMilliseconds, HttpContext.User.Identity.Name);
                return new NoContentResult();

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                _logger.LogError("Feil i endring av aktivitet. Serverfeil.", e);
                return new StatusCodeResult(500);
            }
        }
        [Authorize(Policy = "KanRedigereAktiviteter")]
        [HttpDelete("{id}")]
        public IActionResult SlettAktivitet(Guid id)
        {
            Stopwatch watch = new Stopwatch();
            watch.Start();
            _logger.LogInformation("Aktivitet sletting {AktivitetId}. Brukernavn: {Brukernavn}", id, HttpContext.User.Identity.Name);
            //validere guid? nullable?
            if (id == Guid.Empty)
            {
                _logger.LogError("Feil data ved sletting av aktivitet. Mangler input data. Brukernavn: {Brukernavn}", HttpContext.User.Identity.Name);
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
                watch.Stop();
                _logger.LogInformation("Aktivitet sletting {AktivitetId} - ferdig på {Tidsbruk:000} ms. Brukernavn: {Brukernavn}", id, watch.ElapsedMilliseconds, HttpContext.User.Identity.Name);
                return new NoContentResult();

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                _logger.LogError("Feil i sletting av aktivitet. Serverfeil.", e);
                return new StatusCodeResult(500);
            }
        }
    }
}
