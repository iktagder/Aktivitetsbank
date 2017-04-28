
using VAF.Aktivitetsbank.Application.Commands;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public interface ICommandHandler<in TCommand> where TCommand : ICommand 
    {
        void Execute(TCommand command);
    }
}
