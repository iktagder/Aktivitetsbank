using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using VAF.Aktivitetsbank.Application;
using VAF.Aktivitetsbank.Application.Commands;
using VAF.Aktivitetsbank.Application.Handlers;
using VAF.Aktivitetsbank.Application.Handlers.Dtos;
using VAF.Aktivitetsbank.Application.Queries;

namespace VAF.Aktivitetsbank.API.Controllers
{
    [Route("[controller]")]
    public class AktivitetsbankMetadataController : Controller
    {
        private readonly IQueryDispatcher _queryDispatcher;
        private readonly ICommandDispatcher _commandDispatcher;
        private readonly ILogger<AktivitetsbankMetadataController> _logger;

        public AktivitetsbankMetadataController(IQueryDispatcher queryDispatcher, ICommandDispatcher commandDispatcher, ILogger<AktivitetsbankMetadataController> logger)
        {
            _queryDispatcher = queryDispatcher;
            _commandDispatcher = commandDispatcher;
            _logger = logger;
        }


        [HttpGet]
        public AktivitetsbankMetadata Get()
        {
            return _queryDispatcher.Query<AktivitetsbankMetadataQuery, AktivitetsbankMetadata>(new AktivitetsbankMetadataQuery());
        }
        //[HttpGet] public IEnumerable<Employee> Get()
        //{
        //    return _queryDispatcher.Query<AktivitetsbankMetadataQuery, IList<Employee>>(new AktivitetsbankMetadataQuery()).ToList();
        //}

        //[HttpGet("{id}")]
        //public IActionResult Get(string id)
        //{
        //    _logger.LogDebug("Test log - henter bruker");
        //    var result = _queryDispatcher.Query<EmployeeQuery, Employee>(new EmployeeQuery() {Id = id});
        //    if (result != null)
        //    {
        //        return new ObjectResult(result);
        //    }
        //    else
        //    {
        //        return NotFound();
        //    }
        //}

        //[AllowAnonymous]
        //[HttpOptions("{id}/changephone")]
        //public IActionResult GetOptions()
        //{
        //    Response.Headers.Add("Allow", "GET, OPTIONS, POST");
        //    return Ok();
        //}

        //[HttpPost("{id}/changephone")]
        //public IActionResult Post(string id, [FromBody] Employee employee)
        //{
        //    if (employee == null || employee.Id != id)
        //    {
        //        return BadRequest();
        //    }
        //    try
        //    {
        //        _commandDispatcher.Execute(new UpdatePhoneNumberCommand(employee.Id, employee.PhoneNumber, string.Empty, string.Empty));
        //        return new NoContentResult();

        //    }
        //    catch (Exception e)
        //    {
        //        Console.WriteLine(e);
        //        return new StatusCodeResult(500);
        //    }
        //}


    }
}
