using System;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;

namespace VAF.Aktivitetsbank.Application.Commands
{
    public class EndreDeltakerCommand : Command
    {
        public EndreDeltakerDto EndreDeltakerDto { get; set; }

        public EndreDeltakerCommand(EndreDeltakerDto endreDeltakerDto)
        {
            EndreDeltakerDto = endreDeltakerDto;
        }
    }
}
