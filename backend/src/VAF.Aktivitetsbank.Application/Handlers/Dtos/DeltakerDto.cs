using System;

namespace VAF.Aktivitetsbank.Application.Handlers.Dtos
{
    public class DeltakerDto
    {
        public Guid Id { get; set; }
        public Guid UtdanningsprogramId { get; set; } //Beskrevet som programområde?
        public Guid TrinnId { get; set; }
        public Guid FagId { get; set; }
        public int Timer { get; set; }
        public string Kompetansemaal { get; set; }
    }
}