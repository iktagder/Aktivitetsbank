using VAF.Aktivitetsbank.Application.Commands;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class SlettAktivitetCommandHandler : ICommandHandler<SlettAktivitetCommand>
    {
        private readonly IEventDispatcher _dispatcher;
        private readonly IAktivitetsbankService _aktivitetsbankService;

        public SlettAktivitetCommandHandler(IEventDispatcher dispatcher, IAktivitetsbankService aktivitetsbankService)
        {
            _dispatcher = dispatcher;
            _aktivitetsbankService = aktivitetsbankService;
        }

        public void Execute(SlettAktivitetCommand command)
        {
            ////Do stuff!
            //var emp = new VAF.Aktivitetsbank.Domain.Employee();

            //emp.ChangeNumbers(command.Phone, command.Mobile, command.InternalNumber);

            //foreach (var @event in emp.Events)
            //{
            //    //Send event!
            //    _dispatcher.Send(@event);
            //}

            _aktivitetsbankService.SlettAktivitet(command.SlettAktivitetDto);
        }
    }
}