using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Domain;

namespace VAF.Aktivitetsbank.Application
{
    public class NotificationQueueHandler : IEventHandler<NumberChangedEvent>
    {
        private readonly INotificationService<NumberChangedEvent> _notificationService;

        public NotificationQueueHandler(INotificationService<NumberChangedEvent> notificationService)
        {
            _notificationService = notificationService;
        }
        public void Handle(NumberChangedEvent @event)
        {
            _notificationService.Publish(@event);
        }
    }
}