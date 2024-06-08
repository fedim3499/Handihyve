using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace WebApi.Entities;

[Table("Profession", Schema = "HR")]

public class Profession
{
    [Key]
    public int Id { get; set; }
    public string TaxRegistrationNumber { get; set; }
    public string Adress { get; set; }

    [ForeignKey("Status")]
    public int? StatusId { get; set; }
    public virtual Status Status { get; set; }
    [ForeignKey("ProfessionType")]
    public int? ProfessionTypeId { get; set; }
    public virtual ProfessionType ProfessionType { get; set; }
    public string Description { get; set; }
}