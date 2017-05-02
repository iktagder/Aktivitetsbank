using System;
using System.Collections.Generic;
using System.Linq;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Data;
using VAF.Aktivitetsbank.Data.Entiteter;

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
            var aktiviteter = _context.AktivitetSet.Include(x => x.Skole).ToList();
            var aktiviteterMapped = Mapper.Map<IList<AktivitetDto>>(aktiviteter);
            return aktiviteterMapped;
        }

        public IList<DeltakerDto> HentDeltakere(Guid queryAktivitetId)
        {
            var deltakere = _context.DeltakerSet.Where(x => x.AktivitetId.Equals(queryAktivitetId)).Include(x => x.Utdanningsprogram).Include(x => x.Fag).Include(x => x.Trinn).Include(x => x.Aktivitet).ToList();
            var deltakereMapped = Mapper.Map<IList<DeltakerDto>>(deltakere);
            return deltakereMapped;
        }

        public AktivitetDto HentAktivitet(Guid queryId)
        {
            var aktivitet = _context.AktivitetSet.Where(x => x.Id.Equals(queryId)).Include(x => x.Skole).FirstOrDefault();
            var aktivitetMapped = Mapper.Map<AktivitetDto>(aktivitet);
            return aktivitetMapped;
        }

        public DeltakerDto HentDeltaker(Guid queryAktivitetId, Guid queryDeltakerId)
        {
            var deltaker = _context.DeltakerSet.Where(x => x.AktivitetId.Equals(queryAktivitetId) && x.Id.Equals(queryDeltakerId)).Include(x => x.Utdanningsprogram).Include(x => x.Fag).Include(x => x.Trinn).Include(x => x.Aktivitet).FirstOrDefault();
            var deltakerMapped = Mapper.Map<DeltakerDto>(deltaker);
            return deltakerMapped;
        }

        public void OpprettAktivitet(OpprettAktivitetDto commandOpprettAktivitetDto)
        {
            var aktivitet = _context.AktivitetSet.Add(new Aktivitet
                {
                    Id = commandOpprettAktivitetDto.Id,
                    Navn = commandOpprettAktivitetDto.Navn,
                    Beskrivelse = commandOpprettAktivitetDto.Beskrivelse,
                    OmfangTimer = commandOpprettAktivitetDto.OmfangTimer,
                    SkoleId = commandOpprettAktivitetDto.SkoleId,
                    Type = commandOpprettAktivitetDto.Type
                }
            );
            _context.SaveChanges();
        }

        public void OpprettDeltaker(OpprettDeltakerDto commandOpprettDeltakerDto)
        {
            var deltaker = _context.DeltakerSet.Add(new Deltaker
            {
                Id = commandOpprettDeltakerDto.Id,
                AktivitetId = commandOpprettDeltakerDto.AktivitetId,
                FagId = commandOpprettDeltakerDto.FagId,
                TrinnId = commandOpprettDeltakerDto.TrinnId,
                UtdanningsprogramId = commandOpprettDeltakerDto.UtdanningsprogramId,
                Timer = commandOpprettDeltakerDto.Timer,
                Kompetansemaal = commandOpprettDeltakerDto.Kompetansemaal
            });
            _context.SaveChanges();
        }
    }
}