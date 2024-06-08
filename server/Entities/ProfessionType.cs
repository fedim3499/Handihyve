using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApi.Entities;

[Table("ProfessionType", Schema = "HR")]

public class ProfessionType
{
    [Key]
    public int Id { get; set; }
    public string ProfessionName { get; set; }
    public string Description { get; set; }
    public string Path { get; set; }

}