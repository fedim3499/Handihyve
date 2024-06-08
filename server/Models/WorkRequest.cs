using System;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace WebApi.Models
{
    public class WorkRequest
    {

        [DatabaseGenerated(DatabaseGeneratedOption.Identity)]
        [Key]
        public int Id { get; set; }
        public string Description { get; set; }
        public DateTime Date { get; set; }
        public string Time { get; set; }
        public string? Photo { get; set; }
        public double latitude { get; set; }
        public double longitude { get; set; }
        public int? idclient { get; set; }
        public int? idProf { get; set; }
        public WorkRequestStatus Status { get; set; }

    }
}
