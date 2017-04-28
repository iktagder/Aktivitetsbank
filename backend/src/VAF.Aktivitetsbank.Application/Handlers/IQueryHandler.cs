using System.Threading;
using System.Threading.Tasks;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.Application.Handlers
{
    public interface IQueryHandler<in TQuery, out TResult> where TQuery : IQuery where TResult : class
    {
        TResult Handle(TQuery query);
    }
}
