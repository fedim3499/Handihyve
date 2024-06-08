using System.Text.Json.Serialization;
using WebApi.Authorization;
using WebApi.Helpers;
using WebApi.repositories;
using WebApi.Services;



var builder = WebApplication.CreateBuilder(args);

// add services to DI container
{
    var services = builder.Services;
    var env = builder.Environment;

    services.AddDbContext<DataContext>();
    services.AddCors();
    services.AddControllers().AddJsonOptions(x =>
    {
        // serialize enums as strings in api responses (e.g. Role)
        x.JsonSerializerOptions.Converters.Add(new JsonStringEnumConverter());

        // ignore omitted parameters on models to enable optional params (e.g. User update)
        x.JsonSerializerOptions.DefaultIgnoreCondition = JsonIgnoreCondition.WhenWritingNull;
    });
    services.AddAutoMapper(AppDomain.CurrentDomain.GetAssemblies());
    services.Configure<AppSettings>(builder.Configuration.GetSection("AppSettings"));

    // configure DI for application services
    services.AddScoped<IUserService, UserService>();
    services.AddScoped<IRoleService, RoleService>();
    services.AddScoped<IProfessionTypeService, ProfessionTypeService>();
    services.AddScoped<IJwtUtils, JwtUtils>();
    services.AddScoped<IReviewService, ReviewService>();
    services.AddScoped<IProfessionService, ProfessionService>();
    services.AddScoped<IWorkRequestService, WorkRequestService>();
    services.AddScoped<IWorkRequestRepository, WorkRequestRepository>();



}


var app = builder.Build();
//using (var scope = app.Services.CreateScope())
//{
//var context = scope.ServiceProvider.GetRequiredService<DataContext>();
////var testuser = new User
//{
//FirstName = "wala",
//LastName = "sedghiani",
//Username = "test",
//PasswordHash = BCrypt.Net.BCrypt.HashPassword("test")
//};
//context.Users.Add(testuser);
//    var test1user = new User
//    {
//        FirstName = "thabet",
//        LastName = "sedghiani",
//        Username = "test",
//        PasswordHash = BCrypt.Net.BCrypt.HashPassword("test")
//    };
//    context.Users.Add(test1user);
//    context.SaveChanges();
//}
// configure HTTP request pipeline
{
    // global cors policy
    app.UseCors(x => x
        .AllowAnyOrigin()
        .AllowAnyMethod()
        .AllowAnyHeader());

    // global error handler
    app.UseMiddleware<ErrorHandlerMiddleware>();

    app.MapControllers();
}

app.Run("http://192.168.1.12:4000");