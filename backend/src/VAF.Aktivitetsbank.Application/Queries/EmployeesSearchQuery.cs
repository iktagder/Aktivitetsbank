using System;
using System.Collections.Generic;
using System.Text;

namespace VAF.Aktivitetsbank.Application.Queries
{
    public class EmployeesSearchQuery : IQuery
    {
        public readonly string QueryTerm;

        public EmployeesSearchQuery(string queryTerm)
        {
            QueryTerm = queryTerm;
        }
    }
}
