using System;
using System.Collections.Generic;
using System.Text;

namespace VAF.Aktivitetsbank.Application.Queries
{
    public class DeltakereSearchQuery : IQuery
    {
        public readonly Guid AktivitetId;

        public DeltakereSearchQuery(Guid aktivitetId)
        {
            AktivitetId = aktivitetId;
        }
    }
}
