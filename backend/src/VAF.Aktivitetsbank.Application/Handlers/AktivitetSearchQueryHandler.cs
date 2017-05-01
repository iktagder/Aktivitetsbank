using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class AktivitetSearchQueryHandler : IQueryHandler<AktivitetSearchQuery, IList<AktivitetDto>>
    {
        private readonly IAktivitetsbankService _aktivitetsbankService;

        public AktivitetSearchQueryHandler(IAktivitetsbankService aktivitetsbankService)
        {
            _aktivitetsbankService = aktivitetsbankService;
        }
        public IList<AktivitetDto> Handle(AktivitetSearchQuery query)
        {

            return _aktivitetsbankService.HentAktiviteter(query.QueryTerm);
        }
    }
}
