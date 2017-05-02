using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class DeltakereSearchQueryHandler : IQueryHandler<DeltakereSearchQuery, IList<DeltakerDto>>
    {
        private readonly IAktivitetsbankService _aktivitetsbankService;

        public DeltakereSearchQueryHandler(IAktivitetsbankService aktivitetsbankService)
        {
            _aktivitetsbankService = aktivitetsbankService;
        }
        public IList<DeltakerDto> Handle(DeltakereSearchQuery query)
        {

            return _aktivitetsbankService.HentDeltakere(query.AktivitetId);
        }
    }
}
