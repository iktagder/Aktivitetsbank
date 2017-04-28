using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class EmployeesQueryHandler : IQueryHandler<EmployeesQuery, IList<Employee>>
    {
        private readonly IAdService _adService;

        public EmployeesQueryHandler(IAdService adService)
        {
            _adService = adService;
        }
        public IList<Employee> Handle(EmployeesQuery query)
        {

            return _adService.GetEmployees();
        }
    }
}
