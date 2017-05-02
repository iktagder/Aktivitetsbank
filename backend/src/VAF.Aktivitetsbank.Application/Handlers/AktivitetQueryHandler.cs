using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class AktivitetQueryHandler : IQueryHandler<AktivitetQuery, AktivitetDto>
    {
        private readonly IAktivitetsbankService _aktivitetsbankService;

        public AktivitetQueryHandler(IAktivitetsbankService aktivitetsbankService)
        {
            _aktivitetsbankService = aktivitetsbankService;
        }
        public AktivitetDto Handle(AktivitetQuery query)
        {

            return _aktivitetsbankService.HentAktivitet(query.Id);
        }
    }
}
