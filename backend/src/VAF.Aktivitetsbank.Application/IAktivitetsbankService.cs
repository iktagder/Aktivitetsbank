using System;
using System.Collections.Generic;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;

namespace VAF.Aktivitetsbank.Application
{
    public interface IAktivitetsbankService
    {
        AktivitetsbankMetadata HenteAlleMetadata();
        IList<AktivitetDto> HentAktiviteter(string queryQueryTerm);
        IList<DeltakerDto> HentDeltakere(Guid queryAktivitetId);
        AktivitetDto HentAktivitet(Guid queryId);
        DeltakerDto HentDeltaker(Guid queryAktivitetId, Guid queryDeltakerId);
        void OpprettAktivitet(OpprettAktivitetDto commandOpprettAktivitetDto);
    }
}
