using System.Collections.Generic;
using System.Linq;
using System.Web.UI.WebControls;
using System;
using System.Web.UI;

namespace EliteTweet
{
    public partial class AdminLogin : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            // If already logged in as admin, go straight to dashboard
            if (Session["IsAdmin"] != null && Session["IsAdmin"].ToString() == "true")
            {
                Response.Redirect("AdminDashboard.aspx");
            }
        }

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            string adminUsername = "admin";
            string adminPassword = "admin123";

            if (txtUsername.Text.Trim() == adminUsername && txtPassword.Text.Trim() == adminPassword)
            {
                Session["IsAdmin"] = "true";
                Response.Redirect("AdminDashboard.aspx");
            }
            else
            {
                lblError.Text = "Invalid username or password.";
                lblError.Visible = true;
            }
        }
    }
}
