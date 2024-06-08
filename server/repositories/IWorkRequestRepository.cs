using WebApi.Dto;
using WebApi.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace WebApi.repositories
{
    public interface IWorkRequestRepository
    {
        Task<IEnumerable<WorkRequest>> GetAllWorkRequestsAsync();
        Task<WorkRequest> GetWorkRequestByIdAsync(int id);
        Task<int> CreateWorkRequestAsync(WorkRequest workRequest);
        Task UpdateWorkRequestAsync(WorkRequest workRequest);
        Task DeleteWorkRequestAsync(int id);
        Task<IEnumerable<WorkRequest>> GetWorkRequestsByProfIdAsync(int idProf);
        Task<IEnumerable<WorkRequest>> GetWorkRequestsByClientIdAsync(int idclient);
        Task UpdateAsync(WorkRequest workRequest);
         Task<IEnumerable<WorkRequest>> GetWorkRequestsByProfIdAsyncAccepted(int idProf);
    }
}
