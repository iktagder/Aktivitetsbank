
using VAF.Aktivitetsbank.Application.Commands;

namespace VAF.Aktivitetsbank.Application
{
    public interface ICommandDispatcher
    {
        void Execute<TCommand>(TCommand command) where TCommand : ICommand;

    }
}