using VAF.Aktivitetsbank.Application.Commands;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class EndreDeltakerCommandHandler : ICommandHandler<EndreDeltakerCommand>
    {
        private readonly IEventDispatcher _dispatcher;
        private readonly IAktivitetsbankService _aktivitetsbankService;

        public EndreDeltakerCommandHandler(IEventDispatcher dispatcher, IAktivitetsbankService aktivitetsbankService)
        {
            _dispatcher = dispatcher;
            _aktivitetsbankService = aktivitetsbankService;
        }

        public void Execute(EndreDeltakerCommand command)
        {
            ////Do stuff!
            //var emp = new VAF.Aktivitetsbank.Domain.Employee();

            //emp.ChangeNumbers(command.Phone, command.Mobile, command.InternalNumber);

            //foreach (var @event in emp.Events)
            //{
            //    //Send event!
            //    _dispatcher.Send(@event);
            //}

            _aktivitetsbankService.EndreDeltaker(command.EndreDeltakerDto);
        }
    }
}
