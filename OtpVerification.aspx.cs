using System;
using System.Configuration;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.Security;

namespace EliteTweet
{
    public partial class OtpVerification : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["TwitterDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            // This page only makes sense mid-flow (right after registration or login).
            if (Session["Otp_Email"] == null || Session["Otp_Purpose"] == null)
            {
                Response.Redirect("LoginForm.aspx");
                return;
            }

            if (!IsPostBack)
            {
                lblInfo.Text = "We've sent a 6-digit code to " + MaskEmail(Session["Otp_Email"].ToString());
            }
        }

        protected void btnVerify_Click(object sender, EventArgs e)
        {
            string email = Session["Otp_Email"].ToString();
            string purpose = Session["Otp_Purpose"].ToString();

            OtpService.OtpResult result = OtpService.VerifyOtp(strcon, email, purpose, txtOtp.Text);

            switch (result)
            {
                case OtpService.OtpResult.Success:
                    CompleteFlow(purpose, email);
                    break;
                case OtpService.OtpResult.Expired:
                    lblMessage.Text = "This code has expired. Please request a new one.";
                    break;
                case OtpService.OtpResult.Incorrect:
                    lblMessage.Text = "Incorrect code. Please try again.";
                    break;
                case OtpService.OtpResult.TooManyAttempts:
                    lblMessage.Text = "Too many incorrect attempts. Please request a new code.";
                    break;
                case OtpService.OtpResult.NotFound:
                default:
                    lblMessage.Text = "No active code found. Please request a new one.";
                    break;
            }
        }

        protected void btnResend_Click(object sender, EventArgs e)
        {
            string email = Session["Otp_Email"].ToString();
            string purpose = Session["Otp_Purpose"].ToString();

            int remaining = OtpService.GetResendCooldownRemaining(strcon, email, purpose);
            if (remaining > 0)
            {
                lblMessage.Text = "Please wait " + remaining + " second(s) before requesting another code.";
                return;
            }

            OtpService.CreateAndSendOtp(strcon, email, purpose);
            lblMessage.Text = "A new code has been sent to your email.";
        }

        private void CompleteFlow(string purpose, string email)
        {
            if (purpose == "Register")
            {
                const string query = @"INSERT INTO Users
                        (Name, Email, BirthMonth, BirthDay, BirthYear, Username, Password, IsVerified)
                        VALUES (@Name, @Email, @Month, @Day, @Year, @Username, @Password, 1)";

                using (var con = new SqlConnection(strcon))
                using (var cmd = new SqlCommand(query, con))
                {
                    cmd.Parameters.AddWithValue("@Name", Session["Pending_Name"]);
                    cmd.Parameters.AddWithValue("@Email", Session["Pending_Email"]);
                    cmd.Parameters.AddWithValue("@Month", Session["Pending_BirthMonth"]);
                    cmd.Parameters.AddWithValue("@Day", Session["Pending_BirthDay"]);
                    cmd.Parameters.AddWithValue("@Year", Session["Pending_BirthYear"]);
                    cmd.Parameters.AddWithValue("@Username", Session["Pending_Username"]);
                    cmd.Parameters.AddWithValue("@Password", Session["Pending_PasswordHash"]);

                    con.Open();
                    cmd.ExecuteNonQuery();
                }

                Session["username"] = Session["Pending_Username"];
                Session["Email"] = email;
            }
            else // "Login"
            {
                using (var con = new SqlConnection(strcon))
                using (var cmd = new SqlCommand("SELECT Username FROM Users WHERE Email=@Email", con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    Session["username"] = result != null ? result.ToString() : null;
                }

                Session["Email"] = email;
            }
            FormsAuthentication.SetAuthCookie(email, true); // true = persistent, survives browser close
            ClearPendingSession();
            Response.Redirect("HomePage.aspx");
        }

        private void ClearPendingSession()
        {
            Session.Remove("Pending_Name");
            Session.Remove("Pending_Email");
            Session.Remove("Pending_BirthMonth");
            Session.Remove("Pending_BirthDay");
            Session.Remove("Pending_BirthYear");
            Session.Remove("Pending_Username");
            Session.Remove("Pending_PasswordHash");
            Session.Remove("Otp_Email");
            Session.Remove("Otp_Purpose");
        }

        private string MaskEmail(string email)
        {
            int at = email.IndexOf('@');
            if (at <= 1) return email;
            return email.Substring(0, 2) + new string('*', Math.Max(at - 2, 1)) + email.Substring(at);
        }
    }
}
