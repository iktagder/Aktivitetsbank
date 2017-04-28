
using VAF.Aktivitetsbank.Application.Commands;
using VAF.Aktivitetsbank.Domain;

namespace VAF.Aktivitetsbank.Application
{
    public interface IEventDispatcher
    {
        void Send<TEvent>(TEvent @event) where TEvent : IEvent;
    }
}