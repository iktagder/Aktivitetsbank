using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Text;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Handlers;

namespace VAF.Aktivitetsbank.Infrastructure
{
    public class AdService : IAdService
    {
        private readonly IAdClient _adClient;

        public AdService(IAdClient adClient)
        {
            _adClient = adClient;
        }
        public IList<Employee> GetEmployees()
        {
            //return (IList<Employee>) _employees.Select(x => new Employee() {x.FirstName, x.LastName, x.AgressoResourceId});
            return _employees;
        }

        public IList<EmployeeListItem> GetEmployees(string query)
        {
            //var adClient = new AdClient();
            var result = _adClient.SearchUsers(query);
            return result;
            
            //var queryResult =
            //    _employees.Where(x => (x.FirstName + x.LastName).ToLowerInvariant().Contains(query));
            //return queryResult.ToList();
        }

        public Employee GetEmployee(string queryId)
        {
            //return _employees.FirstOrDefault(x => x.Id == queryId);
            //var adClient = new AdClient();
            var employee = _adClient.GetUser(queryId);
            return employee;
        }

        public void UpdateEmployeePhone(string id, Employee employee)
        {
            //var adClient = new AdClient();
            var result = _adClient.UpdatePhone(id, employee);
        }


        private readonly IList<Employee> _employees = 
            new List<Employee>
            {
                    new Employee()
                    {
                        Id = "1",
                        FirstName = "Ola",
                        LastName = "Normann",
                        AgressoResourceId = "80800",
                        Leder = "Knut Fredvik",
                        Tittel = "Konsulent",
                        Arbeidssted = "Kristiansand"
                    }
                ,
                {
                    new Employee()
                    {
                        Id ="2",
                        FirstName = "Kari",
                        LastName = "Normann",
                        AgressoResourceId = "80432",
                        Leder = "Knut Fredvik",
                        Tittel = "Systemansvarlig",
                        Arbeidssted = "Kristiansand"
                    }
                },
                {
                    new Employee()
                    {
                        Id ="3",
                        FirstName = "Petter",
                        LastName = "Normann",
                        AgressoResourceId = "80300",
                        Leder = "Knut Fredvik",
                        Tittel = "Avdelingsleder",
                        Arbeidssted = "Kristiansand"
                    }
                }
            };


    }
}
