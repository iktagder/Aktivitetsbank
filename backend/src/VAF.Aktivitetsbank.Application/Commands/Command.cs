using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;

namespace VAF.Aktivitetsbank.Application.Commands
{
    public class Command : ICommand
    {
        public Guid Id { get; }

        public Command()
        {
            Id = Guid.NewGuid();
        }
    }
}
