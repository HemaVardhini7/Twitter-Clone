using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace EliteTweet
{
    public static class OtpService
    {
        public enum OtpResult
        {
            Success,
            Expired,
            Incorrect,
            TooManyAttempts,
            NotFound
        }

        private static int ExpiryMinutes { get { return GetIntSetting("Otp:ExpiryMinutes", 5); } }
        private static int MaxAttempts { get { return GetIntSetting("Otp:MaxAttempts", 5); } }
        private static int ResendCooldownSeconds { get { return GetIntSetting("Otp:ResendCooldownSeconds", 30); } }

        private static int GetIntSetting(string key, int fallback)
        {
            int value;
            string raw = ConfigurationManager.AppSettings[key];
            return int.TryParse(raw, out value) ? value : fallback;
        }

        public static string GenerateOtpCode()
        {
            using (var rng = RandomNumberGenerator.Create())
            {
                byte[] bytes = new byte[4];
                rng.GetBytes(bytes);
                uint value = BitConverter.ToUInt32(bytes, 0) % 1000000;
                return value.ToString("D6");
            }
        }

        private static string HashCode(string code)
        {
            using (var sha = SHA256.Create())
            {
                byte[] bytes = sha.ComputeHash(Encoding.UTF8.GetBytes(code));
                var sb = new StringBuilder();
                foreach (byte b in bytes) sb.Append(b.ToString("x2"));
                return sb.ToString();
            }
        }

        /// <summary>
        /// Invalidates previous unused OTPs for this email+purpose, creates a fresh one,
        /// and emails it. Used both for the first send and for "resend".
        /// </summary>
        public static void CreateAndSendOtp(string connectionString, string email, string purpose)
        {
            string code = GenerateOtpCode();
            string hash = HashCode(code);
            DateTime expiry = DateTime.Now.AddMinutes(ExpiryMinutes);

            using (var con = new SqlConnection(connectionString))
            {
                con.Open();

                using (var invalidate = new SqlCommand(
                    "UPDATE OtpVerification SET IsUsed = 1 WHERE Email=@Email AND Purpose=@Purpose AND IsUsed=0", con))
                {
                    invalidate.Parameters.AddWithValue("@Email", email);
                    invalidate.Parameters.AddWithValue("@Purpose", purpose);
                    invalidate.ExecuteNonQuery();
                }

                using (var insert = new SqlCommand(
                    @"INSERT INTO OtpVerification (Email, OtpHash, Purpose, ExpiryTime, Attempts, IsUsed, CreatedAt, LastSentAt)
                      VALUES (@Email, @OtpHash, @Purpose, @ExpiryTime, 0, 0, GETDATE(), GETDATE())", con))
                {
                    insert.Parameters.AddWithValue("@Email", email);
                    insert.Parameters.AddWithValue("@OtpHash", hash);
                    insert.Parameters.AddWithValue("@Purpose", purpose);
                    insert.Parameters.AddWithValue("@ExpiryTime", expiry);
                    insert.ExecuteNonQuery();
                }
            }

            EmailService.SendOtpEmail(email, code);
        }

        /// <summary>
        /// Returns how many seconds remain before another OTP can be requested (0 = allowed now).
        /// </summary>
        public static int GetResendCooldownRemaining(string connectionString, string email, string purpose)
        {
            using (var con = new SqlConnection(connectionString))
            {
                con.Open();
                using (var cmd = new SqlCommand(
                    @"SELECT TOP 1 LastSentAt FROM OtpVerification
                      WHERE Email=@Email AND Purpose=@Purpose
                      ORDER BY OtpId DESC", con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    cmd.Parameters.AddWithValue("@Purpose", purpose);

                    object result = cmd.ExecuteScalar();
                    if (result == null || result == DBNull.Value) return 0;

                    DateTime lastSent = Convert.ToDateTime(result);
                    double elapsed = (DateTime.Now - lastSent).TotalSeconds;
                    int remaining = ResendCooldownSeconds - (int)elapsed;
                    return remaining > 0 ? remaining : 0;
                }
            }
        }

        public static OtpResult VerifyOtp(string connectionString, string email, string purpose, string enteredCode)
        {
            string enteredHash = HashCode((enteredCode ?? "").Trim());

            using (var con = new SqlConnection(connectionString))
            {
                con.Open();

                int otpId;
                string storedHash;
                DateTime expiry;
                int attempts;

                using (var select = new SqlCommand(
                    @"SELECT TOP 1 OtpId, OtpHash, ExpiryTime, Attempts
                      FROM OtpVerification
                      WHERE Email=@Email AND Purpose=@Purpose AND IsUsed=0
                      ORDER BY OtpId DESC", con))
                {
                    select.Parameters.AddWithValue("@Email", email);
                    select.Parameters.AddWithValue("@Purpose", purpose);

                    using (SqlDataReader reader = select.ExecuteReader())
                    {
                        if (!reader.Read())
                        {
                            return OtpResult.NotFound;
                        }
                        otpId = reader.GetInt32(0);
                        storedHash = reader.GetString(1);
                        expiry = reader.GetDateTime(2);
                        attempts = reader.GetInt32(3);
                    }
                }

                if (attempts >= MaxAttempts)
                {
                    return OtpResult.TooManyAttempts;
                }

                if (DateTime.Now > expiry)
                {
                    return OtpResult.Expired;
                }

                if (!string.Equals(storedHash, enteredHash, StringComparison.OrdinalIgnoreCase))
                {
                    using (var update = new SqlCommand(
                        "UPDATE OtpVerification SET Attempts = Attempts + 1 WHERE OtpId=@OtpId", con))
                    {
                        update.Parameters.AddWithValue("@OtpId", otpId);
                        update.ExecuteNonQuery();
                    }
                    return OtpResult.Incorrect;
                }

                using (var markUsed = new SqlCommand(
                    "UPDATE OtpVerification SET IsUsed = 1 WHERE OtpId=@OtpId", con))
                {
                    markUsed.Parameters.AddWithValue("@OtpId", otpId);
                    markUsed.ExecuteNonQuery();
                }

                return OtpResult.Success;
            }
        }
    }
}
