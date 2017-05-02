using System;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;

namespace VAF.Aktivitetsbank.Application.Commands
{
    public class OpprettDeltakerCommand : Command
    {
        public OpprettDeltakerDto OpprettDeltakerDto { get; set; }

        public OpprettDeltakerCommand(OpprettDeltakerDto opprettDeltakerDto)
        {
            OpprettDeltakerDto = opprettDeltakerDto;
        }
    }
}
