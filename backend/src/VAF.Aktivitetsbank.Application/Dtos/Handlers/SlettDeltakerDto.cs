using System;
using System.ComponentModel.DataAnnotations;

namespace VAF.Aktivitetsbank.Application.Handlers.Dtos
{
    public class SlettDeltakerDto
    {
        [Required]
        public Guid Id { get; set; }
        [Required]
        public Guid AktivitetId { get; set; }
        public string BrukerId { get; set; }
    }
}