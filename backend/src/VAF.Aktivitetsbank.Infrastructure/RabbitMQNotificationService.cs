using System;
using System.Collections.Specialized;
using System.Text;
using Newtonsoft.Json;
using RabbitMQ.Client;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Domain;

namespace VAF.Aktivitetsbank.Infrastructure
{
    public class RabbitMqNotificationService : INotificationService<NumberChangedEvent>
    {
        public void Publish(NumberChangedEvent @event)
        {
            //var factory = new ConnectionFactory() { HostName = "localhost" };
            //using (var connection = factory.CreateConnection())
            //using (var channel = connection.CreateModel())
            //{
            //    channel.QueueDeclare(queue: "vaf",
            //                         durable: true,
            //                         exclusive: false,
            //                         autoDelete: false,
            //                         arguments: null);

            //    var message = new Message<NumberChangedEvent>(@event);
            //    var body = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(message));

            //    channel.BasicPublish(exchange: "",
            //                         routingKey: "vaf",
            //                         basicProperties: null,
            //                         body: body);
            //}
        }
    }   
}