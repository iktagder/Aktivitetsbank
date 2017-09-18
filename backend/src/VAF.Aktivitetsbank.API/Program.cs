using System.IO;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore;

namespace VAF.Aktivitetsbank.API
{
    public class Program
    {
        public static void Main(string[] args)
        {
            BuildWebHost(args).Run();
        }

        public static IWebHost BuildWebHost(string[] args) =>
            WebHost.CreateDefaultBuilder(args)
                .UseStartup<Startup>()
                .Build();
    }
}

//{
//    public class Program

//    {
//        public static void Main(string[] args)
//        {
//            var host = new WebHostBuilder()
//                .UseKestrel()
//                .UseContentRoot(Directory.GetCurrentDirectory())
//                //.UseSetting("detailedErrors", "true")
//                .UseIISIntegration()
//                .UseStartup<Startup>()
//                //.CaptureStartupErrors(true)
//                .UseUrls("http://localhost:5100")
//                .UseApplicationInsights()
//                .Build();

//            host.Run();
//        }
//    }
//}
