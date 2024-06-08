namespace WebApi.Entities;

using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

[Table("User", Schema = "Security")]

public class User
{
    [Key]
    public int Id { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Email { get; set; }
    public string Username { get; set; }
    public string Country { get; set; }
    public string State { get; set; }
    public string City { get; set; }
    public string PhoneNumber { get; set; }
    public bool IsActive { get; set; } = false; // Set to false by default

    [ForeignKey("Profession")]
    public int? professionId { get; set; }
    [NotMapped]
    public virtual Profession Profession { get; set; }
    [ForeignKey("role")]
    public int? roleId { get; set; }
    [NotMapped]
    public virtual Role role { get; set; }

    [JsonIgnore]
    public string PasswordHash { get; set; }
    [JsonIgnore]
    [NotMapped]
    public List<RefreshToken> RefreshTokens { get; set; }

}