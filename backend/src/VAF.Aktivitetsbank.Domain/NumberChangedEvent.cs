using System;
using System.Collections.Generic;
using System.Text;

namespace VAF.Aktivitetsbank.Domain
{
    public class NumberChangedEvent : Event
    {
        public string PhoneNumber { get; }
        public string MobilePhoneNumber { get; }
        public string InternalPhoneNumber { get; }

        public NumberChangedEvent(string phoneNumber, string mobilePhoneNumber, string internalPhoneNumber) : base()
        {
            PhoneNumber = phoneNumber;
            MobilePhoneNumber = mobilePhoneNumber;
            InternalPhoneNumber = internalPhoneNumber;
        }
    }
}
