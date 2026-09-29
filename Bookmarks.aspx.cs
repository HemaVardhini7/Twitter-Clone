using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace EliteTweet
{
    public partial class Bookmarks : Page
    {
        string strcon = ConfigurationManager
            .ConnectionStrings["TwitterDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Email"] == null &&
                User.Identity.IsAuthenticated)
            {
                Session["Email"] = User.Identity.Name;
            }

            if (Session["Email"] == null)
            {
                Response.Redirect("LoginForm.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadBookmarks();
            }
        }

        private void LoadBookmarks()
        {
            string email = Session["Email"].ToString();

            string query = @"
                SELECT
                    t.TweetId,
                    t.TweetText,
                    t.ImagePath,
                    t.CreatedAt,
                    u.Name,
                    u.Username,

                    (SELECT COUNT(*)
                     FROM Likes l
                     WHERE l.TweetId = t.TweetId)
                     AS LikeCount,

                    (SELECT COUNT(*)
                     FROM Comments c
                     WHERE c.TweetId = t.TweetId)
                     AS CommentCount

                FROM Bookmarks b

                INNER JOIN Tweets t
                    ON b.TweetId = t.TweetId

                INNER JOIN Users u
                    ON t.Email = u.Email

                WHERE b.Email = @Email

                ORDER BY b.CreatedAt DESC";

            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(query, con))
            {
                cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100)
                    .Value = email;

                DataTable dt = new DataTable();

                using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                {
                    da.Fill(dt);
                }

                rptBookmarks.DataSource = dt;
                rptBookmarks.DataBind();

                pnlEmpty.Visible = dt.Rows.Count == 0;
            }
        }

        protected void rptBookmarks_ItemCommand(
            object source, RepeaterCommandEventArgs e)
        {
            if (e.CommandName != "RemoveBookmark")
                return;

            if (!int.TryParse(
                e.CommandArgument.ToString(), out int tweetId))
                return;

            string email = Session["Email"].ToString();

            using (SqlConnection con = new SqlConnection(strcon))
            using (SqlCommand cmd = new SqlCommand(
                @"DELETE FROM Bookmarks
                  WHERE TweetId = @TweetId
                    AND Email = @Email", con))
            {
                cmd.Parameters.Add("@TweetId", SqlDbType.Int)
                    .Value = tweetId;

                cmd.Parameters.Add("@Email", SqlDbType.VarChar, 100)
                    .Value = email;

                con.Open();
                cmd.ExecuteNonQuery();
            }

            LoadBookmarks();
        }
    }
}