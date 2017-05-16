using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Security.Principal;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Commands;
using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Application.Queries;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;

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
        private readonly AppOptions _options;

        public UserController(ILogger<UserController> logger, IOptions<AppOptions> options)
        {
            _logger = logger;
            _options = options.Value;
        }

        [HttpGet()]
        public UserInfo Get()
        {
            var userInfo = new UserInfo();
            //userInfo.brukernavn = "Username: " + WindowsIdentity.GetCurrent().Name;
            userInfo.brukernavn = HttpContext.User.Identity.Name;

            if (HttpContext.User.HasClaim(c => c.Type == ClaimTypes.Name) && HttpContext.User.IsInRole("ADM\\RES_Aktivitetsbank"))
            {
                userInfo.rolle = "Rediger";
            }
            else
            {
                userInfo.rolle = "Les";
            }
            _logger.LogInformation("Current ad api:{0}", _options.AdApi);
            _logger.LogInformation("Current ad api path:{0}", _options.AdApiPath);
            _logger.LogWarning("user logged in: {0}", userInfo.brukernavn);

            return userInfo;
        }

    }
}
