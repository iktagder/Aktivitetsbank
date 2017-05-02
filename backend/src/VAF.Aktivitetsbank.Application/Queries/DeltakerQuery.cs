using System;
using System.Collections.Generic;
using System.Text;

namespace VAF.Aktivitetsbank.Application.Queries
{
    public class DeltakerQuery : IQuery
    {
        public DeltakerQuery(Guid aktivitetId, Guid deltakerId)
        {
            AktivitetId = aktivitetId;
            DeltakerId = deltakerId;
        }
        public Guid AktivitetId { get; set; }
        public Guid DeltakerId { get; set; }
    }
}
