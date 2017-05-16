using VAF.Aktivitetsbank.Application.Handlers.Dtos;

namespace VAF.Aktivitetsbank.Application.Commands
{
    public class SlettAktivitetCommand : Command
    {
        public SlettAktivitetDto SlettAktivitetDto { get; set; }

        public SlettAktivitetCommand(SlettAktivitetDto slettAktivitetDto)
        {
            SlettAktivitetDto = slettAktivitetDto;
        }
    }
}