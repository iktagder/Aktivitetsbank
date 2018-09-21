using System;
using System.Collections.Generic;
using System.Linq;
using AutoMapper;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Query;
using Microsoft.Extensions.Logging;
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
            var skoler = _context.SkoleSet.OrderBy(x => x.Navn).AsNoTracking().AsEnumerable();
            var skolerMapped = Mapper.Map<IEnumerable<SkoleDto>>(skoler);
            var trinn = _context.TrinnSet.OrderBy(x => x.Navn).AsNoTracking().AsEnumerable();
            var trinnMapped = Mapper.Map<IEnumerable<TrinnDto>>(trinn);
            var fag = _context.FagSet.OrderBy(x => x.Navn).AsNoTracking().AsEnumerable();
            var fagMapped = Mapper.Map<IEnumerable<FagDto>>(fag);
            var aktivitetsTyper = _context.AktivitetstypeSet.OrderBy(x => x.Navn).AsNoTracking().AsEnumerable();
            var aktivitetsTyperMapped = Mapper.Map<IEnumerable<AktivitetstypeDto>>(aktivitetsTyper);
            var utdanningsProgrammer = _context.UtdanningsprogramSet.OrderBy(x => x.Navn).AsNoTracking().AsEnumerable();
            var utdanningsProgrammerMapped = Mapper.Map<IEnumerable<UtdanningsprogramDto>>(utdanningsProgrammer);
            var skoleAar = _context.SkoleAarSet.OrderBy(x => x.Navn).AsNoTracking().AsEnumerable();
            var skoleAarMapped = Mapper.Map<IEnumerable<SkoleAarDto>>(skoleAar);


            var metadata = new AktivitetsbankMetadata();
            metadata.Skoler = skolerMapped;
            metadata.TrinnListe = trinnMapped;
            metadata.FagListe = fagMapped;
            metadata.Aktivitetstyper = aktivitetsTyperMapped;
            metadata.Utdanningsprogrammer = utdanningsProgrammerMapped;
            metadata.SkoleAar = skoleAarMapped;
            return metadata;
        }

        public IList<AktivitetDto> HentAktiviteter(FilterDto filterQuery)
        {
            var aktiviteter = _context.AktivitetSet.AsQueryable();
            if (filterQuery != null)
            {
                aktiviteter = FiltrerAktiviteter(aktiviteter, filterQuery);
            }
            aktiviteter = aktiviteter.OrderBy(x => x.Navn).AsNoTracking();
            var aktiviteterMapped = Mapper.Map<IList<AktivitetDto>>(aktiviteter.ToList());
            return aktiviteterMapped;
        }

        private IQueryable<Aktivitet> FiltrerAktiviteter(IQueryable<Aktivitet> aktiviteter, FilterDto filterQuery)
        {
            aktiviteter = aktiviteter.Include(x => x.Skole).Include(x => x.Aktivitetstype).Include(x => x.SkoleAar);
            aktiviteter = aktiviteter.Where(x => x.Aktiv);
            if (filterQuery.Skoler != null)
            {
                aktiviteter = aktiviteter.Where(x => filterQuery.Skoler.Contains(x.SkoleId));
            }
            if (filterQuery.Aktivitetstyper != null)
            {
                aktiviteter = aktiviteter.Where(x => filterQuery.Aktivitetstyper.Contains(x.AktivitetstypeId));
            }
            if (filterQuery.Utdanningsprogrammer != null)
            {
                aktiviteter = from a in aktiviteter
                              join d in _context.DeltakerSet on a.Id equals d.AktivitetId
                              where filterQuery.Utdanningsprogrammer.Contains(d.UtdanningsprogramId)
                    select a;
            }
            if (filterQuery.TrinnListe != null)
            {
                aktiviteter = from a in aktiviteter
                              join d in _context.DeltakerSet on a.Id equals d.AktivitetId
                              where filterQuery.TrinnListe.Contains(d.TrinnId)
                    select a;
            }
            if (filterQuery.FagListe != null)
            {
                aktiviteter = from a in aktiviteter
                              join d in _context.DeltakerSet on a.Id equals d.AktivitetId
                              where filterQuery.FagListe.Contains(d.FagId)
                    select a;
            }
            if (filterQuery.SkoleAar != null)
            {
                aktiviteter = aktiviteter.Where(x => filterQuery.SkoleAar.Contains(x.SkoleAarId));
            }
            if (!String.IsNullOrEmpty(filterQuery.FriTekst))
            {
                var friTekst = filterQuery.FriTekst.Trim().ToLowerInvariant();
                aktiviteter = from a in aktiviteter
                              join d in _context.DeltakerSet on a.Id equals d.AktivitetId
                              //join skoler in _context.SkoleSet on a.SkoleId equals skoler.Id
                              //join aktivitetstyper in _context.AktivitetstypeSet on a.AktivitetstypeId equals aktivitetstyper.Id
                              //join utdanningsprogrammer in _context.UtdanningsprogramSet on d.UtdanningsprogramId equals utdanningsprogrammer.Id
                              //join trinn in _context.TrinnSet on d.TrinnId equals trinn.Id
                              //join fag in _context.FagSet on d.FagId equals fag.Id
                              where (a.Beskrivelse.ToLowerInvariant().Contains(friTekst) 
                              || d.Kompetansemaal.ToLowerInvariant().Contains(friTekst)
                              //|| skoler.Navn.ToLowerInvariant().Contains(friTekst)
                              //|| aktivitetstyper.Navn.ToLowerInvariant().Contains(friTekst)
                              //|| utdanningsprogrammer.Navn.ToLowerInvariant().Contains(friTekst)
                              //|| trinn.Navn.ToLowerInvariant().Contains(friTekst)
                              //|| fag.Navn.ToLowerInvariant().Contains(friTekst)
                              )
                
                    select a;
            }
            return aktiviteter;
        }

        public IList<DeltakerDto> HentDeltakere(Guid queryAktivitetId)
        {
            var deltakere = _context.DeltakerSet.Where(x => x.AktivitetId.Equals(queryAktivitetId) && x.Aktiv).OrderBy(x => x.Utdanningsprogram.Navn).ThenBy(x => x.Trinn.Navn).Include(x => x.Utdanningsprogram).Include(x => x.Fag).Include(x => x.Trinn).Include(x => x.Aktivitet).AsNoTracking().ToList();
            var deltakereMapped = Mapper.Map<IList<DeltakerDto>>(deltakere);
            return deltakereMapped;
        }

        public AktivitetDto HentAktivitet(Guid queryId)
        {
            var aktivitet = _context.AktivitetSet.Where(x => x.Id.Equals(queryId)).Include(x => x.Skole).Include(x => x.Aktivitetstype).Include(x => x.SkoleAar).AsNoTracking().FirstOrDefault();
            var aktivitetMapped = Mapper.Map<AktivitetDto>(aktivitet);
            return aktivitetMapped;
        }

        public DeltakerDto HentDeltaker(Guid queryAktivitetId, Guid queryDeltakerId)
        {
            var deltaker = _context.DeltakerSet.Where(x => x.AktivitetId.Equals(queryAktivitetId) && x.Id.Equals(queryDeltakerId)).Include(x => x.Utdanningsprogram).Include(x => x.Fag).Include(x => x.Trinn).Include(x => x.Aktivitet).AsNoTracking().FirstOrDefault();
            var deltakerMapped = Mapper.Map<DeltakerDto>(deltaker);
            return deltakerMapped;
        }

        public void OpprettAktivitet(OpprettAktivitetDto commandOpprettAktivitetDto)
        {
            try
            {
                var aktivitet = _context.AktivitetSet.Add(new Aktivitet
                    {
                        Id = commandOpprettAktivitetDto.Id,
                        Navn = commandOpprettAktivitetDto.Navn,
                        Beskrivelse = commandOpprettAktivitetDto.Beskrivelse,
                        OmfangTimer = commandOpprettAktivitetDto.OmfangTimer,
                        SkoleId = commandOpprettAktivitetDto.SkoleId,
                        AktivitetstypeId = commandOpprettAktivitetDto.AktivitetstypeId,
                        SkoleAarId = commandOpprettAktivitetDto.SkoleAarId,
                        Opprettet = DateTime.Now,
                        Endret = DateTime.Now,
                        OpprettetAv = commandOpprettAktivitetDto.BrukerId,
                        EndretAv = commandOpprettAktivitetDto.BrukerId,
                        Aktiv = true,
                    }
                );
                _context.SaveChanges();

            }
            catch (Exception e)
            {
                //_logger.LogError("Kunne ikke opprette aktivitet til databasen.", e); 
                throw;
            }
        }

        public void OpprettDeltaker(OpprettDeltakerDto commandOpprettDeltakerDto)
        {
            try
            {
                var deltaker = _context.DeltakerSet.Add(new Deltaker
                {
                    Id = commandOpprettDeltakerDto.Id,
                    AktivitetId = commandOpprettDeltakerDto.AktivitetId,
                    FagId = commandOpprettDeltakerDto.FagId,
                    TrinnId = commandOpprettDeltakerDto.TrinnId,
                    UtdanningsprogramId = commandOpprettDeltakerDto.UtdanningsprogramId,
                    Timer = commandOpprettDeltakerDto.Timer,
                    Larertimer = commandOpprettDeltakerDto.Larertimer,
                    Elevgrupper = commandOpprettDeltakerDto.Elevgrupper,
                    Kompetansemaal = commandOpprettDeltakerDto.Kompetansemaal,
                    Opprettet = DateTime.Now,
                    Endret = DateTime.Now,
                    OpprettetAv = commandOpprettDeltakerDto.BrukerId,
                    EndretAv = commandOpprettDeltakerDto.BrukerId,
                    Aktiv = true,
                });
                _context.SaveChanges();

            }
            catch (Exception e)
            {
                //_logger.LogError("Kunne ikke opprette deltaker til databasen.", e); 
                throw;
            }
        }

        public void EndreAktivitet(EndreAktivitetDto commandEndreAktivitetDto)
        {
            try
            {
                var gammelAktivitet = _context.AktivitetSet.Find(commandEndreAktivitetDto.Id);
                if (gammelAktivitet != null)
                {
                    gammelAktivitet.Navn = commandEndreAktivitetDto.Navn;
                    gammelAktivitet.Beskrivelse = commandEndreAktivitetDto.Beskrivelse;
                    gammelAktivitet.OmfangTimer = commandEndreAktivitetDto.OmfangTimer;
                    gammelAktivitet.SkoleId = commandEndreAktivitetDto.SkoleId;
                    gammelAktivitet.AktivitetstypeId = commandEndreAktivitetDto.AktivitetstypeId;
                    gammelAktivitet.SkoleAarId = commandEndreAktivitetDto.SkoleAarId;

                    gammelAktivitet.Endret = DateTime.Now;
                    gammelAktivitet.EndretAv = commandEndreAktivitetDto.BrukerId;
                    _context.SaveChanges();
                }
                else
                {
                    //_logger.LogError("Kunne ikke lagre endret aktivitet til databasen.", commandEndreAktivitetDto); 
                    throw new NullReferenceException();
                }

            }
            catch (Exception e)
            {
                //_logger.LogError("Kunne ikke lagre endret aktivitet til databasen.", e); 
                throw;
            }
        }

        public void EndreDeltaker(EndreDeltakerDto commandEndreDeltakerDto)
        {
            try
            {
                var gammelDeltaker = _context.DeltakerSet.Find(commandEndreDeltakerDto.Id);
                if (gammelDeltaker != null)
                {
                    gammelDeltaker.Timer = commandEndreDeltakerDto.Timer;
                    gammelDeltaker.Larertimer = commandEndreDeltakerDto.Larertimer;
                    gammelDeltaker.Elevgrupper = commandEndreDeltakerDto.Elevgrupper;
                    gammelDeltaker.Kompetansemaal = commandEndreDeltakerDto.Kompetansemaal;
                    gammelDeltaker.UtdanningsprogramId = commandEndreDeltakerDto.UtdanningsprogramId;
                    gammelDeltaker.TrinnId = commandEndreDeltakerDto.TrinnId;
                    gammelDeltaker.FagId = commandEndreDeltakerDto.FagId;
                    gammelDeltaker.Endret = DateTime.Now;
                    gammelDeltaker.EndretAv = commandEndreDeltakerDto.BrukerId;
                    _context.SaveChanges();
                }
                else
                {
                    //_logger.LogError("Kunne ikke lagre endret deltaker til databasen.", commandEndreDeltakerDto); 
                    throw new NullReferenceException();
                }

            }
            catch (Exception e)
            {
                //_logger.LogError("Kunne ikke lagre endret deltaker til databasen.", e); 
                throw;
            }
        }

        public void KopierAktivitet(KopierAktivitetDto commandKopierAktivitetDto)
        {
            try
            {
                var gammelAktivitet =
                    _context.AktivitetSet.Include(x => x.Deltakere).Include(x => x.Skole)
                        .FirstOrDefault(x => x.Id == commandKopierAktivitetDto.Id);
                if (gammelAktivitet != null)
                {
                    var nyAktivitet = new Aktivitet
                    {
                        Id = commandKopierAktivitetDto.NyAktivitetId,
                        Navn = gammelAktivitet.Navn,
                        Beskrivelse = gammelAktivitet.Beskrivelse + " - kopiert " + DateTime.Now.ToString("d/M/yyyy HH:mm") + " fra " + gammelAktivitet.Skole.Navn,
                        OmfangTimer = gammelAktivitet.OmfangTimer,
                        SkoleId = commandKopierAktivitetDto.SkoleId,
                        AktivitetstypeId = gammelAktivitet.AktivitetstypeId,
                        SkoleAarId =  gammelAktivitet.SkoleAarId,
                        Aktiv = true,
                        OpprettetAv = commandKopierAktivitetDto.BrukerId,
                        Opprettet = DateTime.Now,
                        EndretAv = commandKopierAktivitetDto.BrukerId,
                        Endret = DateTime.Now
                    };
                    nyAktivitet.Deltakere = new List<Deltaker>();
                    foreach (var deltaker in gammelAktivitet.Deltakere)
                    {
                        nyAktivitet.Deltakere.Add(
                            new Deltaker
                            {
                                Id = Guid.NewGuid(),
                                FagId = deltaker.FagId,
                                TrinnId = deltaker.TrinnId,
                                UtdanningsprogramId = deltaker.UtdanningsprogramId,
                                Timer = deltaker.Timer,
                                Larertimer = deltaker.Larertimer,
                                Elevgrupper = deltaker.Elevgrupper,
                                Kompetansemaal = deltaker.Kompetansemaal,
                                Aktiv = true,
                                OpprettetAv = commandKopierAktivitetDto.BrukerId,
                                Opprettet = DateTime.Now,
                                EndretAv = commandKopierAktivitetDto.BrukerId,
                                Endret = DateTime.Now
                            });
                    }
                    _context.AktivitetSet.Add(nyAktivitet);
                    _context.SaveChanges();
                }
                else
                {
                    //_logger.LogError("Kunne ikke kopiere aktivitet til databasen.", commandKopierAktivitetDto); 
                    throw new NullReferenceException();
                }

            }
            catch (Exception e)
            {
                //_logger.LogError("Kunne ikke kopiere aktivitet til databasen.", e);
                throw;
            }
        }

        public void SlettAktivitet(SlettAktivitetDto commandSlettAktivitetDto)
        {
            try
            {
                var gammelAktivitet = _context.AktivitetSet.Find(commandSlettAktivitetDto.Id);
                if (gammelAktivitet != null)
                {
                    gammelAktivitet.Aktiv = false;
                    gammelAktivitet.Endret = DateTime.Now;
                    gammelAktivitet.EndretAv = commandSlettAktivitetDto.BrukerId;
                    _context.SaveChanges();
                }
                else
                {
                    //_logger.LogError("Kunne ikke deaktivere aktivitet i databasen.", commandSlettAktivitetDto); 
                    throw new NullReferenceException();
                }

            }
            catch (Exception e)
            {
                //_logger.LogError("Kunne ikke deaktivere aktivitet i databasen.", e); 
                throw;
            }
        }

        public void SlettDeltaker(SlettDeltakerDto commandSlettDeltakerDto)
        {
            try
            {
                var gammelDeltaker = _context.DeltakerSet.Find(commandSlettDeltakerDto.Id);
                if (gammelDeltaker != null)
                {
                    gammelDeltaker.Aktiv = false;
                    gammelDeltaker.Endret = DateTime.Now;
                    gammelDeltaker.EndretAv = commandSlettDeltakerDto.BrukerId;
                    _context.SaveChanges();
                }
                else
                {
                    //_logger.LogError("Kunne ikke deaktivere deltaker i databasen.", commandSlettDeltakerDto); 
                    throw new NullReferenceException();
                }

            }
            catch (Exception e)
            {
                //_logger.LogError("Kunne ikke deaktivere deltaker i databasen.", e); 
                throw;
            }
        }
    }
}