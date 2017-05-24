using System;
using System.Collections.Generic;
using System.Text;

namespace VAF.Aktivitetsbank.Application.Handlers.Dtos
{
    public class FilterDto
    {
        public List<Guid> Skoler { get; set; }
        public IEnumerable<Guid> FagListe { get; set; }
        public IEnumerable<Guid> TrinnListe { get; set; }
        public IEnumerable<Guid> Aktivitetstyper { get; set; }
        public IEnumerable<Guid> Utdanningsprogrammer { get; set; }
        public IEnumerable<Guid> SkoleAar { get; set; }
        public string FriTekst { get; set; }

    }
}
