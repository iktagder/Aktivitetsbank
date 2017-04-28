using System.IO;
using Microsoft.AspNetCore.Hosting;

namespace VAF.Aktivitetsbank.API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var host = new WebHostBuilder()
                .UseKestrel()
                .UseContentRoot(Directory.GetCurrentDirectory())
                //.UseSetting("detailedErrors", "true")
                .UseIISIntegration()
                .UseStartup<Startup>()
                //.CaptureStartupErrors(true)
                .UseUrls("http://localhost:5100")
                .UseApplicationInsights()
                .Build();

            host.Run();
        }
    }
}
