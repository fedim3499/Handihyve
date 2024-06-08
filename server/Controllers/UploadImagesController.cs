using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using System;
using WebApi.Helpers;

namespace WebApi.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UploadImagesController : ControllerBase
    {
        private readonly string _uploadFolder = "Uploads";
        //private readonly List<Film> _films = new List<Film>(); // Simulation des données en mémoire (vous devrez utiliser une base de données réelle)
        private readonly DataContext _db;
        public UploadImagesController(DataContext _db)
        {
            this._db = _db;
        }
        [HttpPost("upload")]

        [RequestSizeLimit(2L * 1024 * 1024 * 1024)]
        public async Task<IActionResult> UploadImage(IFormFile ImageFile)
        {
            try
            {
                if (ImageFile == null || ImageFile.Length == 0)
                {
                    return new BadRequestObjectResult("No video file detected.");
                }

                // Create directory if it doesn't exist
                if (!Directory.Exists(_uploadFolder))
                {
                    Directory.CreateDirectory(_uploadFolder);
                }

                // Generate unique file name to prevent naming conflicts
                var uniqueFileName = ImageFile.FileName;

                // Combine the upload folder path with the unique file name
                var filePath = Path.Combine(_uploadFolder, uniqueFileName);

                // Save the video file to the server
                using (var fileStream = new FileStream(filePath, FileMode.Create))
                {
                    await ImageFile.CopyToAsync(fileStream);

                }

                // You may save the file path to a database or return it as response
                var fileUrl = Path.Combine("~", filePath);



                return Ok(new { filePath = fileUrl });
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Internal server error: {ex.Message}");
            }
        }

        [HttpGet("{fileName}")]
        public IActionResult GetImage(string fileName)
        {
            try
            {
                var filePath = Path.Combine(_uploadFolder, fileName);

                if (!System.IO.File.Exists(filePath))
                {
                    return NotFound(); // Si le fichier image n'existe pas, retourne 404 Not Found
                }

                // Lire l'image en tant que tableau de bytes
                var imageBytes = System.IO.File.ReadAllBytes(filePath);

                // Déterminer le type MIME de l'image
                var contentType = GetContentType(filePath);

                // Retourner le contenu de l'image avec le type de contenu approprié
                return File(imageBytes, contentType);
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Une erreur s'est produite : {ex.Message}");
            }

        }
        // Méthode pour obtenir le type MIME en fonction de l'extension du fichier
        private string GetContentType(string path)
        {
            var types = new Dictionary<string, string>
    {
        {".png", "image/png"},
        {".jpg", "image/jpeg"},
        {".jpeg", "image/jpeg"},
        {".gif", "image/gif"},
        {".bmp", "image/bmp"},
        {".tiff", "image/tiff"}
    };

            var ext = Path.GetExtension(path).ToLowerInvariant();
            return types[ext];
        }



    }
}
