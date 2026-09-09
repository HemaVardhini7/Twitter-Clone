using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Configuration;

namespace EliteTweet
{
    public partial class RegistrationForm : System.Web.UI.Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["TwitterDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                for (int i = 1; i <= 31; i++)
                {
                    ddlDay.Items.Add(i.ToString());
                }

                for (int y = DateTime.Now.Year; y >= 1950; y--)
                {
                    ddlYear.Items.Add(y.ToString());
                }
            }

        }

        



        protected void Btn_Next_Click(object sender, EventArgs e)
        {
            if (txtEmail.Text!="")
            {
                Session["Name"] = txtName.Text;
                Session["Email"] = txtEmail.Text;
                Session["BirthMonth"] = ddlMonth.SelectedValue;
                Session["BirthDay"] = ddlDay.SelectedValue;
                Session["BirthYear"] = ddlYear.SelectedValue;
                Response.Redirect("UsernameForm.aspx");
            }
            
            
        }
    }
}