using System;
using System.Collections.Generic;
using System.Text;
using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.Application
{
    public interface IAdService
    {
        IList<Employee> GetEmployees();
        IList<EmployeeListItem> GetEmployees(string query);
        Employee GetEmployee(string queryId);
        void UpdateEmployeePhone(string id, Employee employee);
    }
}
