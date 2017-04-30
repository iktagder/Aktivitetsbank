using System;
using System.ComponentModel.DataAnnotations;

namespace VAF.Aktivitetsbank.Data.Entiteter
{
    public class Aktivitet
    {
        public Guid Id { get; set; }
        [Required]
        [StringLength(50, ErrorMessage = "Navn må være mindre enn 50 tegn.")]
        public string Navn { get; set; }
        [Required]
        public string Beskrivelse { get; set; }
        public int OmfangTimer { get; set; }
        public Guid SkoleId { get; set; }
        [Required]
        public string Type { get; set; }
    }

    public class Deltaker
    {
        public Guid Id { get; set; }
        public Guid UtdanningsprogramId { get; set; } //Beskrevet som programområde?
        public Guid TrinnId { get; set; }
        public Guid FagId { get; set; }
        public int Timer { get; set; }
        [Required]
        public string Kompetansemaal { get; set; }
    }
    public class Skole
    {
        public Guid Id { get; set; }
        [Required]
        public string Navn { get; set; }
        [Required]
        public string Kode { get; set; }
    }

    public class Utdanningsprogram
    {
        public Guid Id { get; set; }
        public Guid? OverordnetUtdanningsprogramId { get; set; }
        [Required]
        public string Navn { get; set; }
    }

    public class Fag
    {
        public Guid Id { get; set; }
        [Required]
        public string Navn { get; set; }
    }
    public class Trinn
    {
        public Guid Id { get; set; }
        [Required]
        public string Navn { get; set; }
    }
    public class Aktivitetstype
    {
        public Guid Id { get; set; }
        [Required]
        public string Navn { get; set; }
    }
}
