using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class EmployeeQueryHandler : IQueryHandler<EmployeeQuery, Employee>
    {
        private readonly IAdService _adService;

        public EmployeeQueryHandler(IAdService adService)
        {
            _adService = adService;
        }
        public Employee Handle(EmployeeQuery query)
        {
            return _adService.GetEmployee(query.Id);
        }
    }
}
