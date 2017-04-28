using System;
using System.Collections.Generic;
using System.Text;
using VAF.Aktivitetsbank.Domain;

namespace VAF.Aktivitetsbank.Infrastructure
{
    public class Message<T> where T: IEvent
    {
        public Message(T @event)
        {
            Type = typeof(T).Name;
            TimeStamp = DateTime.Now;
            Data = @event;
        }

        public T Data { get; set; }

        public DateTime TimeStamp { get; }

        public string Type { get; }
    }
}
