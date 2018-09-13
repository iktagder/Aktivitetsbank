using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace VAF.Aktivitetsbank.API.Authorization
{
    public class AktivitetsbankRedigererAuthHandler : AuthorizationHandler<ErAktivitetsbankRedigererRequirement>
    {
        private readonly ILogger _logger;
        private IConfiguration _configuration;

        public AktivitetsbankRedigererAuthHandler(ILoggerFactory loggerFactory, IConfiguration Configuration)
        {
            _logger = loggerFactory.CreateLogger(this.GetType().Name);
            _configuration = Configuration;
        }

        protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, ErAktivitetsbankRedigererRequirement requirement)
        {
            //var roles = context.User.Claims.Where(q => q.Type == ClaimTypes.GroupSid).Select(q => q.Value);
            //foreach (var role in roles)
            //{
            //    var name = new System.Security.Principal.SecurityIdentifier(role).Translate(typeof(System.Security.Principal.NTAccount)).ToString();
            //    _logger.LogInformation("Got role {0}", name);
            //}

            //context.Succeed(requirement);
            //return Task.CompletedTask;
            if (context.User.HasClaim(c => c.Type == ClaimTypes.Name) && context.User.IsInRole(_configuration["AdGroupForWriteAccess"]))
            {
                context.Succeed(requirement);
            }
            else
            {
                context.Fail();
            }
            return Task.CompletedTask;
        }
    }
}
