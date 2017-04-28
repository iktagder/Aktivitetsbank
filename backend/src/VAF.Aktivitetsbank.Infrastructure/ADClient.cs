using System;
using System.Collections.Generic;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Runtime.CompilerServices;
using System.Text;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Newtonsoft.Json;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Handlers;

namespace VAF.Aktivitetsbank.Infrastructure
{
    public class AdClient : IAdClient
    {
        private readonly ILogger<AdClient> _logger;
        private readonly AppOptions _options;

        public AdClient(IOptions<AppOptions> options, ILogger<AdClient> logger)
        {
            _logger = logger;
            _options = options.Value;
            _logger.LogInformation("Inside AdClient: Current ad api:{0}", _options.AdApi);
            _logger.LogInformation("Inside AdClient: Current ad api path:{0}", _options.AdApiPath);
        }
        public bool UpdatePhone(string id, Employee employee)
        {
            using (var client = new HttpClient())
            {
                var baseUrl = _options.AdApi; 
                var basePath = _options.AdApiPath; 
                client.BaseAddress = new Uri(baseUrl);
                string stringData = JsonConvert.SerializeObject(employee);
                var contentData = new StringContent (stringData, System.Text.Encoding.UTF8, "application/json");
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                // List all Names.  
                using (HttpResponseMessage response = client.PostAsync(basePath + "employees/" + id + "/changephone", contentData).Result)
                {
                    if (response.IsSuccessStatusCode)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                }
            }
        }

        public Employee GetUser(string userName)
        {
            using (var client = new HttpClient())
            {
                var baseUrl = _options.AdApi; 
                var basePath = _options.AdApiPath; 
                client.BaseAddress = new Uri(baseUrl);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                // List all Names.  
                using (HttpResponseMessage response = client.GetAsync(basePath + "employees/" + userName).Result)
                //using (HttpResponseMessage response = client.GetAsync("http://vaf-root-apit/ad-api/api/employees/" + userName).Result)
                {
                    if (response.IsSuccessStatusCode)
                    {
                        string resultString = response.Content.ReadAsStringAsync().Result;
                        var employee = JsonConvert.DeserializeObject<Employee>(resultString);
                        return employee;
                    }
                    else
                    {
                        //Console.WriteLine("{0} ({1})", (int)response.StatusCode, response.ReasonPhrase);
                        //return String.Format("{0} ({1})", (int) response.StatusCode, response.ReasonPhrase);
                        return null;
                    }
                }
            }
        }

        public List<EmployeeListItem> SearchUsers(string userName)
        {
            using (var client = new HttpClient())
            {
                var baseUrl = _options.AdApi; 
                var basePath = _options.AdApiPath; 
                client.BaseAddress = new Uri(baseUrl);
                client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
                // List all Names.  
                using (HttpResponseMessage response = client.GetAsync(basePath + "searchemployees/" + userName).Result)
                {
                    if (response.IsSuccessStatusCode)
                    {
                        string resultString = response.Content.ReadAsStringAsync().Result;
                        var employees = JsonConvert.DeserializeObject<List<EmployeeListItem>>(resultString);
                        return employees;
                    }
                    else
                    {
                        //Console.WriteLine("{0} ({1})", (int)response.StatusCode, response.ReasonPhrase);
                        //return String.Format("{0} ({1})", (int) response.StatusCode, response.ReasonPhrase);
                        return null;
                    }
                }
            }
        }
    }
}
