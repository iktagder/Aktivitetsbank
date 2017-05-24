using System;
using System.Collections.Generic;
using System.Text;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;

namespace VAF.Aktivitetsbank.Application.Queries
{
    public class AktivitetSearchQuery : IQuery
    {
        public readonly FilterDto QueryFilter;

        public AktivitetSearchQuery(FilterDto queryFilter)
        {
            QueryFilter = queryFilter;
        }
    }
}
