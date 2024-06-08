namespace WebApi.Services;

using AutoMapper;
using BCrypt.Net;
using Microsoft.Extensions.Options;
using WebApi.Authorization;
using WebApi.Entities;
using WebApi.Helpers;
using WebApi.Models.Profession;
using WebApi.Models.Review;
using WebApi.Models.Role;

public interface IReviewService
{
    IEnumerable<Review> GetAll();
    Role GetById(int id);
    void Create(ReviewCustom model);
    void Update(int id, ReviewCustom model);
    void Delete(int id);
 IEnumerable<ReviewCustom> GetReviewByprofessionId(int? professionId);
}
public class ReviewService : IReviewService
{
    private DataContext _context;
    private readonly IMapper mapper;
    private readonly AppSettings appSettings;

    public ReviewService(
        DataContext context,
        IMapper _mapper,
        IOptions<AppSettings> _appSettings
         )
    {
        _context = context;
        mapper = _mapper;
        appSettings = _appSettings.Value;

    }

    public IEnumerable<Review> GetAll()
    {
        return _context.Reviews;
    }
    public IEnumerable<ReviewCustom> GetReviewByprofessionId(int? professionId)
    {
        var query = from review in _context.Reviews.Where(x => x.ProfessionId == professionId)
                    from user in _context.Users.Where(x => x.Id == review.ClientId && x.IsActive == true)
                    select new ReviewCustom
                    {
                        Id = review.Id,
                       ClientName=user.LastName+" "+user.FirstName, 
                        ClientId = user.Id,
                        Rating = review.Rating,
                        Comment =review.Comment,
                    };
        return query.ToList();
    }


    public Review GetById(int id)
    {
        return GetReview(id);
    }

    public void Create(ReviewCustom model)
    {

        var review = new Review();
        review.ClientId = model.ClientId;
        review.ProfessionId = model.ProfessionId;
        review.Rating = model.Rating;
        review.Comment = model.Comment;

        _context.Reviews.Add(review);
        _context.SaveChanges();
    }

    public void Update(int id, ReviewCustom model)
    {
        var review = GetReview(id);
        review.Rating = model.Rating;
        review.Comment = model.Comment;

        _context.Reviews.Update(review);
        _context.SaveChanges();
    }

    public void Delete(int id)
    {
        var review = GetReview(id);
        _context.Reviews.Add(review);
        _context.SaveChanges();
    }

    // helper methods

    private Review GetReview(int id)
    {
        var review = _context.Reviews.Find(id);
        if (review == null) throw new KeyNotFoundException("review not found");
        return review;
    }

    Role IReviewService.GetById(int id)
    {
        throw new NotImplementedException();
    }
}
