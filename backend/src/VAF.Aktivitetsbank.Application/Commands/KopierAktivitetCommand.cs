using System;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;

namespace VAF.Aktivitetsbank.Application.Commands
{
    public class KopierAktivitetCommand : Command
    {
        public KopierAktivitetDto KopierAktivitetDto { get; set; }

        public KopierAktivitetCommand(KopierAktivitetDto kopierAktivitetDto)
        {
            KopierAktivitetDto = kopierAktivitetDto;
        }
    }
}
