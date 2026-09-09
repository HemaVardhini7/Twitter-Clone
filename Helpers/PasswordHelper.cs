using System;
using System.Security.Cryptography;

namespace EliteTweet
{
    /// <summary>
    /// PBKDF2 (Rfc2898DeriveBytes + SHA-256) password hashing.
    /// No NuGet package required - built into .NET Framework 4.7.2.
    /// Stored format: "{iterations}.{saltBase64}.{hashBase64}"
    /// </summary>
    public static class PasswordHelper
    {
        private const int SaltSize = 16;   // 128-bit salt
        private const int HashSize = 32;   // 256-bit hash
        private const int Iterations = 100000;

        public static string HashPassword(string password)
        {
            if (password == null) throw new ArgumentNullException(nameof(password));

            byte[] salt = new byte[SaltSize];
            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            byte[] hash = Pbkdf2(password, salt, Iterations, HashSize);

            return string.Format(
                "{0}.{1}.{2}",
                Iterations,
                Convert.ToBase64String(salt),
                Convert.ToBase64String(hash));
        }

        public static bool VerifyPassword(string password, string storedValue)
        {
            if (string.IsNullOrEmpty(password) || string.IsNullOrEmpty(storedValue))
                return false;

            string[] parts = storedValue.Split('.');
            if (parts.Length != 3) return false;

            int iterations;
            if (!int.TryParse(parts[0], out iterations)) return false;

            byte[] salt, storedHash;
            try
            {
                salt = Convert.FromBase64String(parts[1]);
                storedHash = Convert.FromBase64String(parts[2]);
            }
            catch (FormatException)
            {
                return false;
            }

            byte[] computedHash = Pbkdf2(password, salt, iterations, storedHash.Length);

            return FixedTimeEquals(computedHash, storedHash);
        }

        private static byte[] Pbkdf2(string password, byte[] salt, int iterations, int outputLength)
        {
            using (var pbkdf2 = new Rfc2898DeriveBytes(password, salt, iterations, HashAlgorithmName.SHA256))
            {
                return pbkdf2.GetBytes(outputLength);
            }
        }

        // Constant-time comparison to avoid timing side-channels.
        private static bool FixedTimeEquals(byte[] a, byte[] b)
        {
            if (a.Length != b.Length) return false;
            int diff = 0;
            for (int i = 0; i < a.Length; i++)
            {
                diff |= a[i] ^ b[i];
            }
            return diff == 0;
        }
    }
}
