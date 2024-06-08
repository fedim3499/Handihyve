using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Threading.Channels;
using WebApi.Dto;
using WebApi.Services;
using WebApi.Models;

namespace WebApi.Controllers
{
    [ApiController]
    [Route("api/workrequests")]
    public class WorkRequestsController : ControllerBase
    {
        private readonly IWorkRequestService _workRequestService;

        public WorkRequestsController(IWorkRequestService workRequestService)
        {
            _workRequestService = workRequestService;
        }

        [HttpPost]
        public async Task<IActionResult> CreateWorkRequest(WorkRequestDto request)
        {
            try
            {
                // Validate request data
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                // Process and save work request
                var newWorkRequestId = await _workRequestService.CreateWorkRequestAsync(request);
                var newWorkrequest = await _workRequestService.GetWorkRequestByIdAsync(newWorkRequestId);
                return Ok(newWorkrequest);
            }
            catch (Exception ex)
            {
                // Log the error
                return StatusCode(500, "An error occurred while processing the request.");
            }
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetWorkRequestById(int id)
        {
            try
            {
                var workRequest = await _workRequestService.GetWorkRequestByIdAsync(id);
                if (workRequest == null)
                {
                    return NotFound();
                }

                return Ok(workRequest);
            }
            catch (Exception ex)
            {
                // Log the error
                return StatusCode(500, "An error occurred while processing the request.");
            }
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> UpdateWorkRequest(int id, [FromForm] WorkRequest request)
        {
            try
            {
                // Validate request data
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                // Process and update work request
                await _workRequestService.UpdateWorkRequestAsync(id, request);

                return NoContent();
            }
            catch (Exception ex)
            {
                // Log the error
                return StatusCode(500, "An error occurred while processing the request.");
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteWorkRequest(int id)
        {
            try
            {
                // Process and delete work request
                await _workRequestService.DeleteWorkRequestAsync(id);

                return NoContent();
            }
            catch (Exception ex)
            {
                // Log the error
                return StatusCode(500, "An error occurred while processing the request.");
            }
        }
        [HttpGet("byProfId/{idProf}")]
        public async Task<ActionResult<IEnumerable<WorkRequest>>> GetWorkRequestsByProfId(int idProf)
        {
            try
            {
                var workRequests = await _workRequestService.GetWorkRequestsByProfIdAsync(idProf);
                if (workRequests == null)
                {
                    return NotFound();
                }
                return Ok(workRequests);
            }
            catch (Exception ex)
            {
                // Log the error
                return StatusCode(500, "Internal server error");
            }
        }
        [HttpGet("byProfIdAcc/{idProf}")]
        public async Task<ActionResult<IEnumerable<WorkRequest>>> GetWorkRequestsByProfIdAccepted(int idProf)
        {
            try
            {
                var workRequests = await _workRequestService.GetWorkRequestsByProfIdAsyncaccepted(idProf);
                if (workRequests == null)
                {
                    return NotFound();
                }
                return Ok(workRequests);
            }
            catch (Exception ex)
            {
                // Log the error
                return StatusCode(500, "Internal server error");
            }
        }
        [HttpGet("byClientId/{idclient}")]
        public async Task<ActionResult<IEnumerable<WorkRequest>>> GetWorkRequestsByClientid(int idclient)
        {
            try
            {
                var workRequests = await _workRequestService.GetWorkRequestsByClientIdAsync(idclient);
                if (workRequests == null)
                {
                    return NotFound();
                }
                return Ok(workRequests);
            }
            catch (Exception ex)
            {
                // Log the error
                return StatusCode(500, "Internal server error");
            }
        }
        [HttpPatch("status/{id}/{status}")]
        public async Task<IActionResult> UpdateWorkRequestStatus(int id,  int status)
        {
            var result = await _workRequestService.UpdateWorkRequestStatusAsync(id, status);

            if (!result)
            {
                return NotFound(); // Work request not found
            }

            return Ok(); // Update successful
        }

    }
}
