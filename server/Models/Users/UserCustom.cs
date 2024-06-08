using System.ComponentModel.DataAnnotations.Schema;

namespace WebApi.Models.Users;
 
public class UserCustom
{
    public int Id { get; set; }
    public string FirstName { get; set; }
    public string LastName { get; set; }
    public string Email { get; set; }
    public string Password { get; set; }
    public string Country { get; set; }
    public string State { get; set; }
    public string City { get; set; }
    public string PhoneNumber { get; set; }
    public int? ProfessionId { get; set; }
    public string TaxRegistrationNumber { get; set; }
    public string Adress { get; set; }
    public int? ProfessionTypeId { get; set; }

}