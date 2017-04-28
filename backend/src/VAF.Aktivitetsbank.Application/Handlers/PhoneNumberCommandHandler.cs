using VAF.Aktivitetsbank.Application.Commands;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class PhoneNumberCommandHandler : ICommandHandler<UpdatePhoneNumberCommand>
    {
        private readonly IEventDispatcher _dispatcher;
        private readonly IAdService _adService;

        public PhoneNumberCommandHandler(IEventDispatcher dispatcher, IAdService adService)
        {
            _dispatcher = dispatcher;
            _adService = adService;
        }

        public void Execute(UpdatePhoneNumberCommand command)
        {
            //Do stuff!
            var emp = new VAF.Aktivitetsbank.Domain.Employee();

            emp.ChangeNumbers(command.Phone, command.Mobile, command.InternalNumber);

            foreach (var @event in emp.Events)
            {
                //Send event!
                _dispatcher.Send(@event);
            }

            _adService.UpdateEmployeePhone(command.Id, new Employee() {Id = command.Id, PhoneNumber = command.Phone});
        }
    }
}
