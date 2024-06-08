using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using WebApi.Dto;
using WebApi.Models;

namespace WebApi.Services
{
    public interface IWorkRequestService
    {
        Task<IEnumerable<WorkRequest>> GetAllWorkRequestsAsync();
        Task<WorkRequest> GetWorkRequestByIdAsync(int id);
        Task<int> CreateWorkRequestAsync(WorkRequestDto workRequestDto);
        Task UpdateWorkRequestAsync(int id, WorkRequest workRequestDto);
        Task DeleteWorkRequestAsync(int id);
        Task<IEnumerable<WorkRequest>> GetWorkRequestsByProfIdAsync(int idProf);
        Task<IEnumerable<WorkRequest>> GetWorkRequestsByClientIdAsync(int idclient);
        Task<bool> UpdateWorkRequestStatusAsync(int workRequestId, int status);
        Task<IEnumerable<WorkRequest>> GetWorkRequestsByProfIdAsyncaccepted(int idProf);
    }
}
