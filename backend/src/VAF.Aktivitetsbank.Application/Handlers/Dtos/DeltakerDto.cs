using System;

namespace VAF.Aktivitetsbank.Application.Handlers.Dtos
{
    public class DeltakerDto
    {
        public Guid Id { get; set; }
        public Guid AktivitetId { get; set; }
        public string AktivitetNavn { get; set; }
        public Guid UtdanningsprogramId { get; set; } //Beskrevet som programområde?
        public string UtdanningsprogramNavn { get; set; }
        public Guid TrinnId { get; set; }
        public string TrinnNavn { get; set; }
        public Guid FagId { get; set; }
        public string FagNavn { get; set; }
        public int Timer { get; set; }
        public int Larertimer { get; set; }
        public string Kompetansemaal { get; set; }
    }
}