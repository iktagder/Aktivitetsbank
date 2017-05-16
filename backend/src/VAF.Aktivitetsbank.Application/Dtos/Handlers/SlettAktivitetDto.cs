using System;
using System.ComponentModel.DataAnnotations;

namespace VAF.Aktivitetsbank.Application.Handlers.Dtos
{
    public class SlettAktivitetDto
    {
        [Required]
        public Guid Id { get; set; }
        public string BrukerId { get; set; }
    }
}