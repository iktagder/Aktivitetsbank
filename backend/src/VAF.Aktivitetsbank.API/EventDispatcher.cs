using Autofac;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Domain;

namespace VAF.Aktivitetsbank.API
{
    public class EventDispatcher : IEventDispatcher
    {
        private readonly IComponentContext _context;

        public EventDispatcher(IComponentContext context)
        {
            _context = context;
        }

   
        public void Send<TEvent>(TEvent @event) where TEvent : IEvent
        {
            var handler = _context.Resolve<IEventHandler<TEvent>>();
            handler.Handle(@event);
        }

      
    }
}