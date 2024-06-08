namespace WebApi.Controllers;

using AutoMapper;
using Microsoft.AspNetCore.Mvc;
using WebApi.Models.Review;
using WebApi.Services;

[ApiController]
[Route("[controller]")]
public class ReviewController : ControllerBase
{
    private IReviewService reviewService;
    private IMapper _mapper;

    public ReviewController(
        IReviewService _reviewService,
        IMapper mapper)
    {
        reviewService = _reviewService;
        _mapper = mapper;
    }
    [HttpGet]

    public IActionResult GetAll()
    {
        var reviews = reviewService.GetAll();
        return Ok(reviews);
    }

    [HttpGet("{id}")]
    public IActionResult GetById(int id)
    {
        var review = reviewService.GetById(id);
        return Ok(review);
    }
    [HttpPost("createReview")]
    public IActionResult Create(ReviewCustom model)
    {
        reviewService.Create(model);
        return Ok(new { message = "review created" });
    }

    [HttpPost("updateReview")]
    public IActionResult Update( ReviewCustom model)
    {
        reviewService.Update(model.Id.Value, model);
        return Ok(new { message = "Review updated" });
    }

    [HttpDelete("{id}")]
    public IActionResult Delete(int id)
    {
        reviewService.Delete(id);
        return Ok(new { message = "User deleted" });
    }
    [HttpGet("GetReviewByprofessionId/{professionId}")]
    public IActionResult GetReviewByprofessionId(int? professionId)
    {
        var reviewList = reviewService.GetReviewByprofessionId(professionId);
        return Ok(reviewList);
    }
}