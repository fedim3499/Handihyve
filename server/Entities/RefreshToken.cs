namespace WebApi.Entities;

using Microsoft.EntityFrameworkCore;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Text.Json.Serialization;

[Table("RefreshToken", Schema = "Security")]

public class RefreshToken
{
    [Key]
    [JsonIgnore]
    public int Id { get; set; }
    //public int UserId { get; set; }
    //public User user { get; set; }
    public string Token { get; set; }
    public DateTime Expires { get; set; }
    public DateTime Created { get; set; }
    public string CreatedByIp { get; set; }
    public DateTime? Revoked { get; set; }
    public string RevokedByIp { get; set; }
    public string ReplacedByToken { get; set; }
    public string ReasonRevoked { get; set; }
    public bool IsExpired => DateTime.UtcNow >= Expires;
    public bool IsRevoked => Revoked != null;
    public bool IsActive => !IsRevoked && !IsExpired;
}