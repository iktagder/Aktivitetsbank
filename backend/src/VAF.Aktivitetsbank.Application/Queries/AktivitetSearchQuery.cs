using System;
using System.Collections.Generic;
using System.Text;

namespace VAF.Aktivitetsbank.Application.Queries
{
    public class AktivitetSearchQuery : IQuery
    {
        public readonly string QueryTerm;

        public AktivitetSearchQuery(string queryTerm)
        {
            QueryTerm = queryTerm;
        }
    }
}
