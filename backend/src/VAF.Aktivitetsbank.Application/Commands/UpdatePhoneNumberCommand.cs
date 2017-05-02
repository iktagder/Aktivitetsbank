using System.Collections.Generic;
using System.Text;

namespace VAF.Aktivitetsbank.Application.Commands
{
    public class UpdatePhoneNumberCommand : Command
    {
        public string Phone { get; }
        public string InternalNumber { get; }
        public string Mobile { get; }

        public string Id { get; set; }

        public UpdatePhoneNumberCommand(string id, string phone, string internalNumber, string mobile) : base()
        {
            Phone = phone;
            InternalNumber = internalNumber;
            Mobile = mobile;
            Id = id;
        }
    }
}
