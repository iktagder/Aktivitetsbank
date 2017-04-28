using System;
using System.Collections.Generic;
using System.Text;
using VAF.Aktivitetsbank.Domain;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public interface IEventHandler<in TEvent> where TEvent : IEvent
    {
        void Handle(TEvent @event);
    }
}
