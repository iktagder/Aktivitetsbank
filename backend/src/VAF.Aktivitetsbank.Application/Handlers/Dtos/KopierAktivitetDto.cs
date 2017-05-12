using System;
using System.ComponentModel.DataAnnotations;

namespace VAF.Aktivitetsbank.Application.Handlers.Dtos
{
    public class KopierAktivitetDto
    {
        [Required]
        public Guid Id { get; set; }
        [Required]
        public Guid SkoleId { get; set; }
        public Guid NyAktivitetId { get; set; }
        public string BrukerId { get; set; }
    }
}