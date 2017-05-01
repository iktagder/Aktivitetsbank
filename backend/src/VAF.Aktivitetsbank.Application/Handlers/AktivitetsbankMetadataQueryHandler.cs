using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class AktivitetsbankMetadataQueryHandler : IQueryHandler<AktivitetsbankMetadataQuery, AktivitetsbankMetadata>
    {
        private readonly IAktivitetsbankService _aktivitetsbankService;

        public AktivitetsbankMetadataQueryHandler(IAktivitetsbankService aktivitetsbankService)
        {
            _aktivitetsbankService = aktivitetsbankService;
        }
        public AktivitetsbankMetadata Handle(AktivitetsbankMetadataQuery query)
        {

            return _aktivitetsbankService.HenteAlleMetadata();
        }
    }
}
