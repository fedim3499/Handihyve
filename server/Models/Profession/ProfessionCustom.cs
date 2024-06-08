namespace WebApi.Models.Profession;


public class ProfessionCustom
{
    public int? Id { get; set; }
    public string ProfessionName { get; set; }

    public string UserName { get; set; }
    public string FirstName { get; set; }

    public string TaxRegistrationNumber { get; set; }
    public bool IsActive { get; set; }

}

