using System;
using System.ComponentModel.DataAnnotations;

namespace VAF.Aktivitetsbank.Application.Handlers.Dtos
{
    public class OpprettDeltakerDto
    {
        [Required]
        public Guid Id { get; set; }
        [Required]
        public Guid AktivitetId { get; set; }
        [Required]
        public Guid UtdanningsprogramId { get; set; }
        [Required]
        public Guid TrinnId { get; set; }
        [Required]
        public Guid FagId { get; set; }
        [Required]
        public int Timer { get; set; }
        [Required]
        [StringLength(500, ErrorMessage = "Kompetansem�l m� v�re mindre enn 500 tegn.")]
        public string Kompetansemaal { get; set; }
    }
}