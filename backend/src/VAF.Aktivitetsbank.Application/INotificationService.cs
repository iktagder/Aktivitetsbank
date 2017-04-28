using VAF.Aktivitetsbank.Domain;

namespace VAF.Aktivitetsbank.Application
{
    public interface INotificationService<T> where T : IEvent
    {
        void Publish(T @event);
    }
}
