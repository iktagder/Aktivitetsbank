using System.Collections.Generic;
using VAF.Aktivitetsbank.Application.Handlers;

namespace VAF.Aktivitetsbank.Infrastructure
{
    public interface IAdClient
    {
        Employee GetUser(string userName);
        List<EmployeeListItem> SearchUsers(string userName);
        bool UpdatePhone(string id, Employee employee);
    }
}