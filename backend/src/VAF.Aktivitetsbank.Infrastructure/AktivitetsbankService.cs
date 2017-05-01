using System.Collections.Generic;
using System.Linq;
using AutoMapper;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Data;

namespace VAF.Aktivitetsbank.Infrastructure
{
    public class AktivitetsbankService : IAktivitetsbankService
    {
        private readonly AktivitetsbankContext _context;

        public AktivitetsbankService(AktivitetsbankContext context)
        {
            _context = context;
        }
        public AktivitetsbankMetadata HenteAlleMetadata()
        {
            var skoler = _context.SkoleSet.AsEnumerable();
            var skolerMapped = Mapper.Map<IEnumerable<SkoleDto>>(skoler);
            var trinn = _context.TrinnSet.AsEnumerable();
            var trinnMapped = Mapper.Map<IEnumerable<TrinnDto>>(trinn);
            var fag = _context.FagSet.AsEnumerable();
            var fagMapped = Mapper.Map<IEnumerable<FagDto>>(fag);
            var aktivitetsTyper = _context.AktivitetstypeSet.AsEnumerable();
            var aktivitetsTyperMapped = Mapper.Map<IEnumerable<AktivitetstypeDto>>(aktivitetsTyper);
            var utdanningsProgrammer = _context.UtdanningsprogramSet.AsEnumerable();
            var utdanningsProgrammerMapped = Mapper.Map<IEnumerable<UtdanningsprogramDto>>(utdanningsProgrammer);


            var metadata = new AktivitetsbankMetadata();
            metadata.Skoler = skolerMapped;
            metadata.TrinnListe = trinnMapped;
            metadata.FagListe = fagMapped;
            metadata.Aktivitetstyper = aktivitetsTyperMapped;
            metadata.Utdanningsprogrammer = utdanningsProgrammerMapped;
            return metadata;
        }

        public IList<AktivitetDto> HentAktiviteter(string queryQueryTerm)
        {
            var aktiviteter = _context.AktivitetSet.ToList();
            var aktiviteterMapped = Mapper.Map<IList<AktivitetDto>>(aktiviteter);
            return aktiviteterMapped;
        }
    }
}