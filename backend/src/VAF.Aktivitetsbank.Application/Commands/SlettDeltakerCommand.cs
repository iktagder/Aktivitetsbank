using VAF.Aktivitetsbank.Application.Handlers.Dtos;

namespace VAF.Aktivitetsbank.Application.Commands
{
    public class SlettDeltakerCommand : Command
    {
        public SlettDeltakerDto SlettDeltakerDto { get; set; }

        public SlettDeltakerCommand(SlettDeltakerDto slettDeltakerDto)
        {
            SlettDeltakerDto = slettDeltakerDto;
        }
    }
}