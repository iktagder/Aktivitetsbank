using System.Collections.Generic;

namespace VAF.Aktivitetsbank.Application.Handlers.Dtos
{
    public class AktivitetsbankMetadata
    {
        public IEnumerable<SkoleDto> Skoler { get; set; }
        public IEnumerable<FagDto> FagListe { get; set; }
        public IEnumerable<TrinnDto> TrinnListe { get; set; }
        public IEnumerable<AktivitetstypeDto> Aktivitetstyper { get; set; }
        public IEnumerable<UtdanningsprogramDto> Utdanningsprogrammer { get; set; }

    }
}