namespace WebApi.Helpers;

using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using WebApi.Entities;
using WebApi.Models;

public class DataContext : DbContext
{
    protected readonly IConfiguration Configuration;
    internal object reviews;

    public DataContext(IConfiguration configuration)
    {
        Configuration = configuration;
    }

    protected override void OnConfiguring(DbContextOptionsBuilder options)
    {
        // in memory database used for simplicity, change to a real db for production applications
        options.UseSqlServer(Configuration.GetConnectionString("WebApiDatabase"));
    }

    public DbSet<User> Users { get; set; }
    public DbSet<Role> Roles { get; set; }
    public DbSet<ProfessionType> ProfessionTypes { get; set; }
    public DbSet<Profession> Professions { get; set; }
    public DbSet<Status> Status { get; set; }
    public DbSet<Review> Reviews { get; internal set; }
    public DbSet<WorkRequest> WorkRequests { get; set; }
}