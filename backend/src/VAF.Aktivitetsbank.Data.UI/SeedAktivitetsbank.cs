using System;
using System.Collections.Generic;
using System.Runtime.InteropServices.ComTypes;
using System.Text;
using VAF.Aktivitetsbank.Data.Entiteter;

namespace VAF.Aktivitetsbank.Data.UI
{
    public static class SeedAktivitetsbank
    {
        public static void SeedUtdanningsprogram()
        {
            var factory = new AktivitetsbankContextFactory();
            var context = factory.Create();

            var utdanningsProgramAlle = new Utdanningsprogram {Id = Guid.NewGuid(), Navn = "Alle"};
            var utdanningsProgramSF = new Utdanningsprogram {Id = Guid.NewGuid(), OverordnetUtdanningsprogramId = utdanningsProgramAlle.Id, Navn = "SF-Alle"};
            var utdanningsProgramYF = new Utdanningsprogram {Id = Guid.NewGuid(), OverordnetUtdanningsprogramId = utdanningsProgramAlle.Id, Navn = "YF-Alle"};

            var utdanningsProgram = new List<Utdanningsprogram>
            {
                utdanningsProgramAlle,
                utdanningsProgramSF,
                utdanningsProgramYF,
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramSF.Id,
                    Navn = "Idrettsfag"
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramSF.Id,
                    Navn = "Kunst, design og arkitektur "
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramSF.Id,
                    Navn = "Medier og kommunikasjon "
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramSF.Id,
                    Navn = "Musikk, dans og drama "
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramSF.Id,
                    Navn = "Studiespesialisering "
                },

                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramYF.Id,
                    Navn = "Studiespesialisering "
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramYF.Id,
                    Navn = "Bygg- og anleggsteknikk"
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramYF.Id,
                    Navn = "Design og håndverk"
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramYF.Id,
                    Navn = "Design og håndverk - medieproduksjon"
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramYF.Id,
                    Navn = "Elektrofag"
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramYF.Id,
                    Navn = "Helse- og oppvekstfag"
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramYF.Id,
                    Navn = "Naturbruk"
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramYF.Id,
                    Navn = "Restaurant- og matfag"
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramYF.Id,
                    Navn = "Service og samferdsel"
                },
                new Utdanningsprogram
                {
                    Id = Guid.NewGuid(),
                    OverordnetUtdanningsprogramId = utdanningsProgramYF.Id,
                    Navn = "Teknikk og industriell produksjon"
                },

            };

            utdanningsProgram.ForEach(x => context.UtdanningsprogramSet.Add(x));
            context.SaveChanges();
        }
        public static void SeedAktivitetsType()
        {
            var factory = new AktivitetsbankContextFactory();
            var context = factory.Create();

            var aktivitetsTyper = new List<Aktivitetstype>
            {
                new Aktivitetstype { Id = Guid.NewGuid(), Navn = "Aktivitet uten kompetansemål (Karriere, trafikk, rus etc.)" },
                new Aktivitetstype {Id = Guid.NewGuid(), Navn = "Alternative opplegg"},
                new Aktivitetstype {Id = Guid.NewGuid(), Navn = "Den kulturelle skolesekken"},
                new Aktivitetstype {Id = Guid.NewGuid(), Navn = "Eksamen"},
                new Aktivitetstype {Id = Guid.NewGuid(), Navn = "Ekskursjon"},
                new Aktivitetstype {Id = Guid.NewGuid(), Navn = "Eksterne (bedre ord?)"},
                new Aktivitetstype {Id = Guid.NewGuid(), Navn = "Elevreise"},
                new Aktivitetstype {Id = Guid.NewGuid(), Navn = "Internasjonalisering (OD)"},
                new Aktivitetstype {Id = Guid.NewGuid(), Navn = "Lesedag"},
                new Aktivitetstype {Id = Guid.NewGuid(), Navn = "Tentamen"},
                new Aktivitetstype {Id = Guid.NewGuid(), Navn = "Utplassering/YFF"}
            };

            aktivitetsTyper.ForEach(x => context.AktivitetstypeSet.Add(x));
            context.SaveChanges();
        }
        public static void SeedTrinn()
        {
            var factory = new AktivitetsbankContextFactory();
            var context = factory.Create();

            var trinn = new List<Trinn>
            {
                new Trinn {Id = Guid.NewGuid(), Navn = "Vg1"},
                new Trinn {Id = Guid.NewGuid(), Navn = "Vg2"},
                new Trinn {Id = Guid.NewGuid(), Navn = "Vg3"},
            };

            trinn.ForEach(x => context.TrinnSet.Add(x));
            context.SaveChanges();
        }
        public static void SeedSkole()
        {
            var factory = new AktivitetsbankContextFactory();
            var context = factory.Create();
            var fag = new List<Skole>
            {
                new Skole {Id = Guid.NewGuid(), Navn = "Byremo", Kode = "BYR"},
                new Skole {Id = Guid.NewGuid(), Navn = "Byremo", Kode = "BYR"},
                new Skole {Id = Guid.NewGuid(), Navn = "Eilert Sundt", Kode = "EVG"},
                new Skole {Id = Guid.NewGuid(), Navn = "KKG", Kode = "KKG"},
                new Skole {Id = Guid.NewGuid(), Navn = "Kvadraturen Skolesenter", Kode = "KVA"},
                new Skole {Id = Guid.NewGuid(), Navn = "Mandal", Kode = "MAN"},
                new Skole {Id = Guid.NewGuid(), Navn = "Sirdal", Kode = "SIR"},
                new Skole {Id = Guid.NewGuid(), Navn = "SMI", Kode = "SMI"},
                new Skole {Id = Guid.NewGuid(), Navn = "Søgne", Kode = "SOG"},
                new Skole {Id = Guid.NewGuid(), Navn = "Tangen", Kode = "TAN"},
                new Skole {Id = Guid.NewGuid(), Navn = "Vennesla", Kode = "VEN"},
                new Skole {Id = Guid.NewGuid(), Navn = "Vågsbygd", Kode = "VAG"},
                new Skole {Id = Guid.NewGuid(), Navn = "Flekkefjord", Kode = "FVG"},
                new Skole {Id = Guid.NewGuid(), Navn = "Alle", Kode = "ALLE"}
            };

            fag.ForEach(x => context.SkoleSet.Add(x));
            context.SaveChanges();
        }
        public static void SeedFag()
        {
            var factory = new AktivitetsbankContextFactory();
            var context = factory.Create();

            var fag = new List<Fag>
            {
                new Fag {Id=Guid.NewGuid(), Navn = "Matte"},
                new Fag {Id=Guid.NewGuid(), Navn = "Biologi"},
                new Fag {Id=Guid.NewGuid(), Navn = "Engelsk"},
                new Fag {Id=Guid.NewGuid(), Navn = "Felles programfag"},
                new Fag {Id=Guid.NewGuid(), Navn = "Fremmedspråk"},
                new Fag {Id=Guid.NewGuid(), Navn = "Fysikk"},
                new Fag {Id=Guid.NewGuid(), Navn = "Geografi"},
                new Fag {Id=Guid.NewGuid(), Navn = "Historie"},
                new Fag {Id=Guid.NewGuid(), Navn = "Kjemi"},
                new Fag {Id=Guid.NewGuid(), Navn = "Kroppsøving"},
                new Fag {Id=Guid.NewGuid(), Navn = "Matematikk"},
                new Fag {Id=Guid.NewGuid(), Navn = "Naturfag"},
                new Fag {Id=Guid.NewGuid(), Navn = "Norsk"},
                new Fag {Id=Guid.NewGuid(), Navn = "Programfag til valg"},
                new Fag {Id=Guid.NewGuid(), Navn = "Religion og etikk"},
                new Fag {Id=Guid.NewGuid(), Navn = "Samfunnsfag"},
                new Fag {Id=Guid.NewGuid(), Navn = "YFF (Yrkesfaglig fordypning)"}

            };
            fag.ForEach(x => context.FagSet.Add(x));
            context.SaveChanges();
        }

    }
}
