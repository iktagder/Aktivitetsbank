using System.Collections.Generic;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc.Authorization;
using Microsoft.AspNetCore.Mvc.Filters;

namespace VAF.Aktivitetsbank.API.Authorization
{
    //[Attribute]
    public class CustomAuthorize : AuthorizeFilter
    {
        public CustomAuthorize(AuthorizationPolicy policy) : base(policy)
        {
        }

        public CustomAuthorize(IAuthorizationPolicyProvider policyProvider, IEnumerable<IAuthorizeData> authorizeData) : base(policyProvider, authorizeData)
        {
        }

        public CustomAuthorize(IEnumerable<IAuthorizeData> authorizeData) : base(authorizeData)
        {
        }

        public CustomAuthorize(string policy) : base(policy)
        {
        }

        public override Task OnAuthorizationAsync(AuthorizationFilterContext context)
        {
            return base.OnAuthorizationAsync(context);
        }
    }
}
