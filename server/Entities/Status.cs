using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApi.Entities;

[Table("Status", Schema = "Common")]

public class Status
{
    [Key]
    public int Id { get; set; }
    public string StatusName { get; set; }
    public string StatusGroupName { get; set; }
    public string Description { get; set; }
}