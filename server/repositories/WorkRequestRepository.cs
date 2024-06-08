using WebApi.Dto;
using WebApi.Models;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System;
using WebApi.Helpers;


namespace WebApi.repositories
{
    public class WorkRequestRepository : IWorkRequestRepository
    {
        private readonly DataContext _context;
        public WorkRequestRepository(DataContext context)
        {
            _context = context;
        }

        public async Task<int> CreateWorkRequestAsync(WorkRequest workRequest)
        {
            _context.WorkRequests.Add(workRequest);
            await _context.SaveChangesAsync();

            return workRequest.Id;
        }

        public async Task DeleteWorkRequestAsync(int id)
        {
            var workRequestToDelete = await _context.WorkRequests.FindAsync(id);
            if (workRequestToDelete != null)
            {
                _context.WorkRequests.Remove(workRequestToDelete);
                await _context.SaveChangesAsync();
            }
        }

        public async Task<IEnumerable<WorkRequest>> GetAllWorkRequestsAsync()
        {
            return await _context.WorkRequests.ToListAsync();
        }

        public async Task<WorkRequest> GetWorkRequestByIdAsync(int id)
        {
            return await _context.WorkRequests.FindAsync(id);
        }

        public async Task UpdateWorkRequestAsync(WorkRequest workRequest)
        {
            _context.WorkRequests.Update(workRequest);
            await _context.SaveChangesAsync();
        }
        public async Task<IEnumerable<WorkRequest>> GetWorkRequestsByProfIdAsync(int idProf)
        {
           
            return await _context.WorkRequests.Where(w => w.idProf == idProf && w.Status == WorkRequestStatus.Pending).ToListAsync();
        }
        public async Task<IEnumerable<WorkRequest>> GetWorkRequestsByProfIdAsyncAccepted(int idProf)
        {

            return await _context.WorkRequests.Where(w => w.idProf == idProf && w.Status == WorkRequestStatus.Accepted).ToListAsync();
        }
        public async Task<IEnumerable<WorkRequest>> GetWorkRequestsByIdAsync(int idProf)
        {

            return await _context.WorkRequests.Where(w => w.idProf == idProf).ToListAsync();
        }
        public async Task<IEnumerable<WorkRequest>> GetWorkRequestsByClientIdAsync(int idclient)
        {

            return await _context.WorkRequests.Where(w => w.idclient == idclient).ToListAsync();
        }
        public async Task UpdateAsync(WorkRequest workRequest)
        {
            _context.WorkRequests.Update(workRequest);
            await _context.SaveChangesAsync();
        }
    }
}
