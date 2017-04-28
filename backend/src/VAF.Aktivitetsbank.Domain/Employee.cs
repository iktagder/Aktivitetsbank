using System;
using System.Collections.Generic;
using System.Threading;

namespace VAF.Aktivitetsbank.Domain
{
    public class Employee
    {
        private readonly IList<NumberChangedEvent> _events = new List<NumberChangedEvent>();

        public string FirstName { get; }
        public string LastName { get; }
        public string PhoneNumber { get; }
        public string MobilePhoneNumber { get; }
        public string InternalPhoneNumber { get; }
        
        public void ChangeNumbers(string phoneNumber, string mobilePhoneNumber, string internalPhoneNumber)
        {
            //Logic!
            _events.Add(new NumberChangedEvent(phoneNumber,mobilePhoneNumber, internalPhoneNumber));   
        }

        public IReadOnlyCollection<NumberChangedEvent> Events => _events as IReadOnlyCollection<NumberChangedEvent>;
    }
}
