using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApi.Entities;

[Table("Role", Schema = "Security")]

public class Role
{
    [Key]
    public int Id { get; set; }
    public string RoleName { get; set; }
    public string Description { get; set; }
   

}