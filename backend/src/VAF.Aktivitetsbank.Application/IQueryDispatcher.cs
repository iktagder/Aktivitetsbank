using System.Threading.Tasks;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.Application
{
    public interface IQueryDispatcher
    {
        TResult Query<TQuery, TResult>(TQuery query) where TQuery : IQuery where TResult : class;
    }
}