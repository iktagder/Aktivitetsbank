using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Commands;
using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Application.Queries;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using VAF.Aktivitetsbank.API.Authorization;

namespace VAF.Aktivitetsbank.API.Controllers
{
    public class UserInfo
    {
        public string navn = "test";
        public string brukernavn = "test";
        public string rolle = "test2";
    }


    [Route("[controller]")]
    public class UserController : Controller
    {
        private readonly ILogger<UserController> _logger;
        private readonly IAuthorizationService _authorizationService;
        private readonly AppOptions _options;
        private readonly int _eventIdRead = 50000;
        private readonly int _eventIdModify = 51000;

        public UserController(ILogger<UserController> logger, IOptions<AppOptions> options, IAuthorizationService authorizationService)
        {
            _logger = logger;
            _authorizationService = authorizationService;
            _options = options.Value;
        }

        [HttpGet()]
        public async Task<dynamic> Get()
        {
            _logger.LogInformation(_eventIdRead + 1, "Bruker pålogging startet.");
            var userInfo = new UserInfo();
            userInfo.brukernavn = HttpContext.User.Identity.Name;
            if (await _authorizationService.AuthorizeAsync(HttpContext.User, "", new ErAktivitetsbankRedigererRequirement()))
            {
                userInfo.rolle = "Rediger";
            }
            else
            {
                userInfo.rolle = "Les";
            }
            _logger.LogWarning(_eventIdRead + 2, "Pålogget brukernavn: {Brukernavn}", userInfo.brukernavn);
            _logger.LogWarning(_eventIdRead + 3, "Pålogget bruker rolle: {BrukerRolle}", userInfo.rolle);

            return userInfo;
        }

    }
}
