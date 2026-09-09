using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EliteTweet
{
    public partial class FirstPage : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void CreateAccount_Btn_Click(object sender, EventArgs e)
        {
            Response.Redirect("RegistrationForm.aspx");
        }

        protected void SignIn_btn_click(object sender, EventArgs e)
        {
            Response.Redirect("LoginForm.aspx");
        }
    }
}