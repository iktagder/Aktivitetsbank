using System.Collections.Generic;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;

namespace VAF.Aktivitetsbank.Application
{
    public interface IAktivitetsbankService
    {
        AktivitetsbankMetadata HenteAlleMetadata();
        IList<AktivitetDto> HentAktiviteter(string queryQueryTerm);
    }
}
