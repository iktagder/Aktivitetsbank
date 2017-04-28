using System;
using System.Collections.Generic;
using System.Text;

namespace VAF.Aktivitetsbank.Domain
{
    public class Event : IEvent
    {
        public Guid Id { get;}
        public DateTime Date { get; }

        public Event()
        {
            Id = Guid.NewGuid();
            Date = DateTime.Now;
        }
    }
}
