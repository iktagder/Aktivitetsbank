using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class DeltakerQueryHandler : IQueryHandler<DeltakerQuery, DeltakerDto>
    {
        private readonly IAktivitetsbankService _aktivitetsbankService;

        public DeltakerQueryHandler(IAktivitetsbankService aktivitetsbankService)
        {
            _aktivitetsbankService = aktivitetsbankService;
        }
        public DeltakerDto Handle(DeltakerQuery query)
        {

            return _aktivitetsbankService.HentDeltaker(query.AktivitetId, query.DeltakerId);
        }
    }
}
