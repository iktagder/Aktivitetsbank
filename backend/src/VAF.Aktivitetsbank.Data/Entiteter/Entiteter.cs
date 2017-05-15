using System;
using System.Collections.Generic;
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
        public Skole Skole { get; set; }
        [Required]
        public Guid AktivitetstypeId { get; set; }
        public Aktivitetstype Aktivitetstype { get; set; }
        public List<Deltaker> Deltakere { get; set; }
        [Required]
        public string OpprettetAv { get; set; }
        [Required]
        public string EndretAv { get; set; }
        public DateTime Opprettet { get; set; }
        public DateTime Endret { get; set; }
        public Boolean Aktiv { get; set; }
        public Guid SkoleAarId { get; set; }
        public SkoleAar SkoleAar { get; set; }
    }

    public class Deltaker
    {
        public Guid Id { get; set; }
        public Guid AktivitetId { get; set; }
        public Aktivitet Aktivitet { get; set; }
        public Guid UtdanningsprogramId { get; set; } //Beskrevet som programområde?
        public Utdanningsprogram Utdanningsprogram { get; set; }
        public Guid TrinnId { get; set; }
        public Trinn Trinn { get; set; }
        public Guid FagId { get; set; }
        public Fag Fag { get; set; }
        public int Timer { get; set; }
        [Required]
        public string Kompetansemaal { get; set; }
        [Required]
        public string OpprettetAv { get; set; }
        [Required]
        public string EndretAv { get; set; }
        public DateTime Opprettet { get; set; }
        public DateTime Endret { get; set; }
        public Boolean Aktiv { get; set; }
    }
    public class Skole
    {
        public Guid Id { get; set; }
        [Required]
        public string Navn { get; set; }
        [Required]
        public string Kode { get; set; }
        public List<Aktivitet> Aktiviteter { get; set; }
    }

    public class Utdanningsprogram
    {
        public Guid Id { get; set; }
        public Guid? OverordnetUtdanningsprogramId { get; set; }
        [Required]
        public string Navn { get; set; }
        public List<Deltaker> Deltakere { get; set; }
    }

    public class Fag
    {
        public Guid Id { get; set; }
        [Required]
        public string Navn { get; set; }
        public List<Deltaker> Deltakere { get; set; }
    }
    public class Trinn
    {
        public Guid Id { get; set; }
        [Required]
        public string Navn { get; set; }
        public List<Deltaker> Deltakere { get; set; }
    }
    public class Aktivitetstype
    {
        public Guid Id { get; set; }
        [Required]
        public string Navn { get; set; }
        public List<Aktivitet> Aktiviteter { get; set; }
    }
    public class SkoleAar
    {
        public Guid Id { get; set; }
        [Required]
        public string Navn { get; set; }
        public List<Aktivitet> Aktiviteter { get; set; }
    }
}
