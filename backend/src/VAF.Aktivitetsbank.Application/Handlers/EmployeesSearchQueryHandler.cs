using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class EmployeesSearchQueryHandler : IQueryHandler<EmployeesSearchQuery, IList<EmployeeListItem>>
    {
        private readonly IAdService _adService;

        public EmployeesSearchQueryHandler(IAdService adService)
        {
            _adService = adService;
        }
        public IList<EmployeeListItem> Handle(EmployeesSearchQuery query)
        {

            return _adService.GetEmployees(query.QueryTerm);
        }
    }
}
