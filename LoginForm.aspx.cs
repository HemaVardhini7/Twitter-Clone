using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SqlClient;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EliteTweet
{
    public partial class LoginForm : System.Web.UI.Page
    {

        string strcon = ConfigurationManager.ConnectionStrings["TwitterDB"].ConnectionString;
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack && User.Identity.IsAuthenticated)
            {
                Response.Redirect("HomePage.aspx");
            }
        }

        protected void Login_btn_Click(object sender, EventArgs e)
        {
            lblMessage.Text = "";

            string email = txtUserEmail.Text.Trim();
            string password = txtPassword.Text;

            if (string.IsNullOrWhiteSpace(email) || string.IsNullOrWhiteSpace(password))
            {
                lblMessage.Text = "Please enter your email and password.";
                return;
            }

            string storedHash = null;
            bool isVerified = false;

            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                using (SqlCommand cmd = new SqlCommand(
                    "SELECT Password, IsVerified FROM Users WHERE Email=@Email", con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            storedHash = reader["Password"].ToString();
                            isVerified = Convert.ToBoolean(reader["IsVerified"]);
                        }
                    }
                }
            }

            if (storedHash == null || !PasswordHelper.VerifyPassword(password, storedHash))
            {
                lblMessage.Text = "Incorrect email or password. Try again!";
                return;
            }

            if (!isVerified)
            {
                lblMessage.Text = "This account hasn't completed email verification. Please register again.";
                return;
            }

            // Password is correct - now require a fresh OTP before logging in.
            OtpService.CreateAndSendOtp(strcon, email, "Login");

            Session["Otp_Email"] = email;
            Session["Otp_Purpose"] = "Login";

            Response.Redirect("OtpVerification.aspx");
        }
    }
}
