using System;
using System.Collections.Generic;
using System.Text;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public class Employee
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string Id { get; set; }

        public string AgressoResourceId { get; set; }
        public string PhoneNumber { get; set; }
        public string MobilePhoneNumber { get; set; }
        public string InternalPhoneNumber { get; set; }

        public string Leder { get; set; }
        public string Arbeidssted { get; set; }
        public string Tittel { get; set; }

    }
}
