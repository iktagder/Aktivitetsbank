using System;

namespace VAF.Aktivitetsbank.Application.Handlers.Dtos
{
    public class AktivitetDto
    {
        public Guid Id { get; set; }
        public string Navn { get; set; }
        public string Beskrivelse { get; set; }
        public int OmfangTimer { get; set; }
        public Guid SkoleId { get; set; }
        public string Type { get; set; }
    }
}