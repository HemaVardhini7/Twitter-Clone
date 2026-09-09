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
    public partial class UsernameForm1 : System.Web.UI.Page
    {

        string strcon = ConfigurationManager.ConnectionStrings["TwitterDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // RegistrationForm.aspx already collected the email into Session.
                if (Session["Email"] != null)
                {
                    txtEmail.Text = Session["Email"].ToString();
                }
            }
        }

        protected void Username_btn_click(object sender, EventArgs e)
        {


        }


        protected void SignUp_btn_click(object sender, EventArgs e)
        {
            lblMessage.Text = "";

            if (Session["Name"] == null || Session["Email"] == null)
            {
                // Session expired or user landed here directly - restart the flow.
                Response.Redirect("RegistrationForm.aspx");
                return;
            }

            if (string.IsNullOrWhiteSpace(txtUsername.Text) || string.IsNullOrWhiteSpace(txtPassword.Text))
            {
                lblMessage.Text = "Please enter a username and password.";
                return;
            }

            if (txtPassword.Text.Length < 8)
            {
                lblMessage.Text = "Password must be at least 8 characters.";
                return;
            }

            string name = Session["Name"].ToString();
            string email = Session["Email"].ToString();
            string month = Session["BirthMonth"].ToString();
            string day = Session["BirthDay"].ToString();
            string year = Session["BirthYear"].ToString();
            string username = txtUsername.Text.Trim();

            // Make sure this email hasn't already completed registration.
            using (SqlConnection con = new SqlConnection(strcon))
            {
                con.Open();
                using (SqlCommand checkCmd = new SqlCommand("SELECT COUNT(*) FROM Users WHERE Email=@Email", con))
                {
                    checkCmd.Parameters.AddWithValue("@Email", email);
                    int count = (int)checkCmd.ExecuteScalar();
                    if (count > 0)
                    {
                        lblMessage.Text = "An account with this email already exists. Try signing in instead.";
                        return;
                    }
                }
            }

            // Don't insert into Users yet - only after the OTP is verified.
            // Stash everything needed to finish the insert on OtpVerification.aspx.
            Session["Pending_Name"] = name;
            Session["Pending_Email"] = email;
            Session["Pending_BirthMonth"] = month;
            Session["Pending_BirthDay"] = day;
            Session["Pending_BirthYear"] = year;
            Session["Pending_Username"] = username;
            Session["Pending_PasswordHash"] = PasswordHelper.HashPassword(txtPassword.Text);

            OtpService.CreateAndSendOtp(strcon, email, "Register");

            Session["Otp_Email"] = email;
            Session["Otp_Purpose"] = "Register";

            Response.Redirect("OtpVerification.aspx");
        }
    }
}
