using System;

namespace VAF.Aktivitetsbank.Application.Handlers.Dtos
{
    public class UtdanningsprogramDto
    {
        public Guid Id { get; set; }
        public Guid? OverordnetUtdanningsprogramId { get; set; }
        public string Navn { get; set; }
    }
}