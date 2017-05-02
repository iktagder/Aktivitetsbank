using System;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;

namespace VAF.Aktivitetsbank.Application.Commands
{
    public class OpprettAktivitetCommand : Command
    {
        public OpprettAktivitetDto OpprettAktivitetDto { get; set; }

        public OpprettAktivitetCommand(OpprettAktivitetDto opprettAktivitetDto)
        {
            OpprettAktivitetDto = opprettAktivitetDto;
        }
    }
}
