using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApi.Entities;

[Table("Review", Schema = "HR")]

public class Review
{
    [Key]
    public int Id { get; set; }
    [ForeignKey("Profession")]
    public int? ProfessionId { get; set; }
    [NotMapped]
    public virtual Profession Profession { get; set; }
    [ForeignKey("Client")]
    public int? ClientId { get; set; }
    [NotMapped]
    public virtual User Client { get; set; }
    public double? Rating{ get; set; }

    public String Comment { get; set; }
   

}