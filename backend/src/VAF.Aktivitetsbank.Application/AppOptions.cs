namespace VAF.Aktivitetsbank.Application
{
    public class AppOptions
    {
        public AppOptions()
        {
            // Set default values.
            AdApi = "http://localhost:5000/dummy";
            AdApiPath = "api/dummy";
        }
        public string AdApi { get; set; }
        public string AdApiPath { get; set; }
    }
}
