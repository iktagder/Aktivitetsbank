using VAF.Aktivitetsbank.Application.Commands;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class OpprettDeltakerCommandHandler : ICommandHandler<OpprettDeltakerCommand>
    {
        private readonly IEventDispatcher _dispatcher;
        private readonly IAktivitetsbankService _aktivitetsbankService;

        public OpprettDeltakerCommandHandler(IEventDispatcher dispatcher, IAktivitetsbankService aktivitetsbankService)
        {
            _dispatcher = dispatcher;
            _aktivitetsbankService = aktivitetsbankService;
        }

        public void Execute(OpprettDeltakerCommand command)
        {
            ////Do stuff!
            //var emp = new VAF.Aktivitetsbank.Domain.Employee();

            //emp.ChangeNumbers(command.Phone, command.Mobile, command.InternalNumber);

            //foreach (var @event in emp.Events)
            //{
            //    //Send event!
            //    _dispatcher.Send(@event);
            //}

            _aktivitetsbankService.OpprettDeltaker(command.OpprettDeltakerDto);
        }
    }
}
