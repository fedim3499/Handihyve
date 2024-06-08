namespace WebApi.Models.Review;

public class ReviewCustom
{

    public int? Id { get; set; }
    public int? ClientId { get; set; }
    public string ClientName { get; set; }

    public int? ProfessionId { get; set; }
   
    public double? Rating { get; set; }

    public String Comment { get; set; }


}