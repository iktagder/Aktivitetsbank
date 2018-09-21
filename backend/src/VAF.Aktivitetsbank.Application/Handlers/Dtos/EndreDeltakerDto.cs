using System;
using System.ComponentModel.DataAnnotations;

namespace VAF.Aktivitetsbank.Application.Handlers.Dtos
{
    public class EndreDeltakerDto
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
        public int Larertimer { get; set; }

        [Required]
        [StringLength(4000, ErrorMessage = "Kompetansemål må være mindre enn 4000 tegn.")]
        public string Kompetansemaal { get; set; }

        public string BrukerId { get; set; }
    }
}