using System;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;

namespace VAF.Aktivitetsbank.Application.Commands
{
    public class EndreAktivitetCommand : Command
    {
        public EndreAktivitetDto EndreAktivitetDto { get; set; }

        public EndreAktivitetCommand(EndreAktivitetDto endreAktivitetDto)
        {
            EndreAktivitetDto = endreAktivitetDto;
        }
    }
}
