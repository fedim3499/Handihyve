using Azure.Core;
using WebApi.Dto;
using WebApi.Models;
using WebApi.repositories;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using System;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using WebApi.Entities;
using Microsoft.EntityFrameworkCore;
using WebApi.Helpers;

namespace WebApi.Services
{
    public class WorkRequestService : IWorkRequestService
    {
        private readonly IWorkRequestRepository _repository;
        private readonly DataContext _context;

        public WorkRequestService(IWorkRequestRepository repository, DataContext context)
        {
            _repository = repository;
            _context = context;
        }

        public async Task<int> CreateWorkRequestAsync(WorkRequestDto workRequestDto)


        {

            var workrequest = new WorkRequest
            {
                Description = workRequestDto.Description,
                Date = workRequestDto.Date,
                Time = workRequestDto.Time,
                Photo = workRequestDto.Photo,
                latitude = workRequestDto.latitude,
                longitude = workRequestDto.longitude,
                idclient = workRequestDto.idclient,
                idProf= workRequestDto.idProf,
                Status = WorkRequestStatus.Pending,

        };
            return await _repository.CreateWorkRequestAsync(workrequest);
        }

        public async Task DeleteWorkRequestAsync(int id)
        {
            await _repository.DeleteWorkRequestAsync(id);
        }

        public async Task<IEnumerable<WorkRequest>> GetAllWorkRequestsAsync()
        {
            return await _repository.GetAllWorkRequestsAsync();
        }

        public async Task<WorkRequest> GetWorkRequestByIdAsync(int id)
        {
            return await _repository.GetWorkRequestByIdAsync(id);
        }


        public async Task UpdateWorkRequestAsync(int id, WorkRequest workRequestDto)
        {
            var existingWorkRequest = await _repository.GetWorkRequestByIdAsync(id);
            if (existingWorkRequest != null)
            {
                // Update properties of existingWorkRequest with values from workRequestDto
                existingWorkRequest.Description = workRequestDto.Description;
                existingWorkRequest.Date = workRequestDto.Date;
                existingWorkRequest.Time = workRequestDto.Time;
                existingWorkRequest.Photo = workRequestDto.Photo;
                existingWorkRequest.latitude = workRequestDto.latitude;
                existingWorkRequest.longitude = workRequestDto.longitude;
                existingWorkRequest.idclient = workRequestDto.idclient;
                existingWorkRequest.idProf = workRequestDto.idProf;
                // Update other properties as needed

                await _repository.UpdateWorkRequestAsync(existingWorkRequest);
            }
        }
        public async Task<IEnumerable<WorkRequest>> GetWorkRequestsByProfIdAsync(int idProf)
        {
            return await _repository.GetWorkRequestsByProfIdAsync(idProf);
        }
        public async Task<IEnumerable<WorkRequest>> GetWorkRequestsByProfIdAsyncaccepted(int idProf)
        {
            return await _repository.GetWorkRequestsByProfIdAsyncAccepted(idProf);
        }
        public async Task<IEnumerable<WorkRequest>> GetWorkRequestsByClientIdAsync(int idclient)
        {
            return await _repository.GetWorkRequestsByClientIdAsync(idclient);
        }
        public async Task<bool> UpdateWorkRequestStatusAsync(int workRequestId, int status)
        {
            var workRequest = await _repository.GetWorkRequestByIdAsync(workRequestId);
            if (workRequest == null)
            {
                return false; // Work request not found
            }
            if(status == 1)
            {
                workRequest.Status = WorkRequestStatus.Accepted;
            }else if(status == 2)
            {
                workRequest.Status = WorkRequestStatus.Rejected;

            }


            await _repository.UpdateAsync(workRequest);

            return true; // Update successful
        }

    }

}
