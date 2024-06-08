using Microsoft.AspNetCore.Http;
using System;
using System.Data;

namespace WebApi.Dto
{
    public class WorkRequestDto
    {
        public string Description { get; set; }
        public DateTime Date { get; set; }
        public String Time { get; set; }
        public string Photo { get; set; }
        public double latitude { get; set; }
        public double longitude { get; set; }
        public int? idclient { get; set; }
        public int? idProf { get; set; }
    }
}
