using System;
using System.Collections.Generic;
using System.Text;

namespace VAF.Aktivitetsbank.Application.Queries
{
    public class AktivitetQuery : IQuery
    {
        public AktivitetQuery(Guid id)
        {
            Id = id;
        }
        public Guid Id { get; set; }
    }
}
