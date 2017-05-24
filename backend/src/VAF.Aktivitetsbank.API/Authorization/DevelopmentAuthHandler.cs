using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using VAF.Aktivitetsbank.Application;

namespace VAF.Aktivitetsbank.API.Authorization
{
    public class DevelopmentAuthHandler : AuthorizationHandler<ErAktivitetsbankRedigererRequirement>
    {
        private readonly ILogger _logger;
        private readonly AppOptions _options;

        public DevelopmentAuthHandler(ILoggerFactory loggerFactory, IOptions<AppOptions> options)
        {
            _logger = loggerFactory.CreateLogger(this.GetType().Name);
            _options = options.Value;

        }

        protected override Task HandleRequirementAsync(AuthorizationHandlerContext context, ErAktivitetsbankRedigererRequirement requirement)
        {
            //var roles = context.User.Claims.Where(q => q.Type == ClaimTypes.GroupSid).Select(q => q.Value);
            //foreach (var role in roles)
            //{
            //    var name = new System.Security.Principal.SecurityIdentifier(role).Translate(typeof(System.Security.Principal.NTAccount)).ToString();
            //    _logger.LogInformation("Got role {0}", name);
            //}
            if (_options.UtviklerKanRedigere)
            {
                context.Succeed(requirement);
            }
            else
            {
                context.Fail();
            }
            return Task.CompletedTask;
            //if (context.User.HasClaim(c => c.Type == ClaimTypes.Name) && context.User.IsInRole("BOUVET\\Dep.AlleKristiansand"))
            //{
            //    context.Succeed(requirement);
            //}
            //else
            //{
            //    context.Fail();
            //}
            //return Task.CompletedTask;
        }
    }
}
