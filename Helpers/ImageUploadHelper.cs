using System;
using System.IO;
using System.Web;

namespace EliteTweet
{
    /// <summary>
    /// Validates and saves an uploaded tweet image securely:
    /// - Whitelisted extensions only
    /// - Size limit
    /// - Verifies actual file bytes match a real image format (not just the extension)
    /// - Always generates a new random filename, so the original filename/path is never trusted
    /// </summary>
    public static class ImageUploadHelper
    {
        private const long MaxFileSizeBytes = 5 * 1024 * 1024; // 5 MB

        public class ImageValidationException : Exception
        {
            public ImageValidationException(string message) : base(message) { }
        }

        public static string SaveTweetImage(HttpPostedFile postedFile, string physicalUploadFolder, string relativeUploadFolder)
        {
            if (postedFile == null || postedFile.ContentLength <= 0)
                throw new ImageValidationException("No file was received.");

            if (postedFile.ContentLength > MaxFileSizeBytes)
                throw new ImageValidationException("Image must be smaller than 5 MB.");

            string extension = GetSafeExtension(postedFile);

            byte[] header = new byte[12];
            int bytesRead = postedFile.InputStream.Read(header, 0, header.Length);
            postedFile.InputStream.Position = 0; // rewind - do NOT close/dispose this stream, SaveAs() needs it

            if (bytesRead < 4 || !LooksLikeImage(header, extension))
                throw new ImageValidationException("That file doesn't look like a valid image.");

            if (!Directory.Exists(physicalUploadFolder))
            {
                Directory.CreateDirectory(physicalUploadFolder);
            }

            string fileName = Guid.NewGuid().ToString("N") + extension;
            string physicalPath = Path.Combine(physicalUploadFolder, fileName);

            postedFile.SaveAs(physicalPath);

            return relativeUploadFolder.TrimEnd('/') + "/" + fileName;
        }

        private static string GetSafeExtension(HttpPostedFile postedFile)
        {
            string ext = Path.GetExtension(postedFile.FileName);
            if (ext == null) ext = "";
            ext = ext.ToLowerInvariant();

            switch (ext)
            {
                case ".jpg":
                case ".jpeg":
                case ".png":
                case ".gif":
                case ".webp":
                    return ext == ".jpeg" ? ".jpg" : ext;
                default:
                    throw new ImageValidationException("Only JPG, PNG, GIF, or WEBP images are allowed.");
            }
        }

        private static bool LooksLikeImage(byte[] header, string extension)
        {
            if (header.Length < 4) return false;

            bool isJpeg = header[0] == 0xFF && header[1] == 0xD8 && header[2] == 0xFF;
            bool isPng = header.Length >= 8 &&
                         header[0] == 0x89 && header[1] == 0x50 && header[2] == 0x4E && header[3] == 0x47 &&
                         header[4] == 0x0D && header[5] == 0x0A && header[6] == 0x1A && header[7] == 0x0A;
            bool isGif = header[0] == 0x47 && header[1] == 0x49 && header[2] == 0x46 && header[3] == 0x38;
            bool isWebp = header.Length >= 12 &&
                          header[0] == 0x52 && header[1] == 0x49 && header[2] == 0x46 && header[3] == 0x46 &&
                          header[8] == 0x57 && header[9] == 0x45 && header[10] == 0x42 && header[11] == 0x50;

            switch (extension)
            {
                case ".jpg": return isJpeg;
                case ".png": return isPng;
                case ".gif": return isGif;
                case ".webp": return isWebp;
                default: return false;
            }
        }
    }
}