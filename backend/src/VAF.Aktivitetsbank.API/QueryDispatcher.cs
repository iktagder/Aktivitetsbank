using System.Threading;
using System.Threading.Tasks;
using Autofac;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.API
{
    public class QueryDispatcher : IQueryDispatcher
    {
        private readonly IComponentContext _context;

        public QueryDispatcher(IComponentContext context)
        {
            _context = context;
        }

        public TResult Query<TQuery, TResult>(TQuery query) where TQuery : IQuery where TResult : class
        {
            var handler = _context.Resolve<IQueryHandler<TQuery,TResult>>();
            return handler.Handle(query);
        }
    }
}