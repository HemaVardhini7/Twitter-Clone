using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Web.Security;
using System.Web.UI;
using System.Web.Security;

namespace EliteTweet
{
    public partial class HomePage : Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["TwitterDB"].ConnectionString;
     

   
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Email"] == null && User.Identity.IsAuthenticated)
            {
                string email = User.Identity.Name;
                Session["Email"] = email;

                using (var con = new SqlConnection(strcon))
                using (var cmd = new SqlCommand("SELECT Username FROM Users WHERE Email=@Email", con))
                {
                    cmd.Parameters.AddWithValue("@Email", email);
                    con.Open();
                    object result = cmd.ExecuteScalar();
                    Session["username"] = result != null ? result.ToString() : null;
                }
            }
            // Redirect to login if not logged in
            if (Session["Email"] == null)
            {
                Response.Redirect("LoginForm.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserInfo();
                LoadTweets();
            }
        }

        protected void lnkLogout_ServerClick(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Clear();
            Response.Redirect("LoginForm.aspx");
        }

        private void LoadUserInfo()
        {
            string email = Session["Email"].ToString();

            SqlConnection con = new SqlConnection(strcon);
            string query = "SELECT Name, Username FROM Users WHERE Email = @Email";
                SqlCommand cmd = new SqlCommand(query, con);
                cmd.Parameters.AddWithValue("@Email", email);

                con.Open();
                SqlDataReader dr = cmd.ExecuteReader();

                if (dr.Read())
                {
                    lblName.Text = dr["Name"].ToString();
                    lblUsername.Text = "@" + dr["Username"].ToString();
                }
                con.Close();
            
        }

        private void LoadTweets()
        {
            SqlConnection con = new SqlConnection(strcon);

            string query = @"
                    SELECT 
                        t.TweetId,
                        t.TweetText,
                        t.ImagePath,
                        t.CreatedAt,
                        u.Name,
                        u.Username,
                        ISNULL(u.IsVerified, 0) AS IsVerified,
                        (SELECT COUNT(*) FROM Likes    l WHERE l.TweetId = t.TweetId)    AS LikeCount,
                        (SELECT COUNT(*) FROM Comments c WHERE c.TweetId = t.TweetId)    AS CommentCount,
                        (SELECT COUNT(*) FROM Retweets r WHERE r.TweetId = t.TweetId)    AS RetweetCount
                    FROM Tweets t
                    INNER JOIN Users u ON t.Email = u.Email
                    ORDER BY t.CreatedAt DESC";

                SqlCommand cmd = new SqlCommand(query, con);
                con.Open();

                SqlDataAdapter da = new SqlDataAdapter(cmd);
                DataTable dt = new DataTable();
                da.Fill(dt);

                rptTweets.DataSource = dt;
                rptTweets.DataBind();

                pnlEmptyFeed.Visible = (dt.Rows.Count == 0);
                con.Close();

        }



        protected void btnPost_Click(object sender, EventArgs e)
        {

            string tweetText = txtTweet.Text.Trim();
            if (string.IsNullOrEmpty(tweetText))
                tweetText = txtModalTweet.Text.Trim();

            if (string.IsNullOrEmpty(tweetText))
            {
                ShowMessage("Please write something before posting.", "danger");
                return;
            }

            if (tweetText.Length > 280)
            {
                ShowMessage("Tweet cannot exceed 280 characters.", "danger");
                return;
            }

            string imagePath = null;

            if (fileUpload.HasFile)
            {
                try
                {
                    imagePath = ImageUploadHelper.SaveTweetImage(
                        fileUpload.PostedFile,
                        Server.MapPath("~/UploadedImages/Tweets/"),
                        "UploadedImages/Tweets");
                }
                catch (ImageUploadHelper.ImageValidationException ex)
                {
                    ShowMessage(ex.Message, "danger");
                    return;
                }
            }

            string email = Session["Email"].ToString();

            SqlConnection con = new SqlConnection(strcon);
            string query = "INSERT INTO Tweets (Email, TweetText, ImagePath, CreatedAt) VALUES (@Email, @TweetText, @ImagePath, GETDATE())";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", email);
            cmd.Parameters.AddWithValue("@TweetText", tweetText);
            cmd.Parameters.AddWithValue("@ImagePath", (object)imagePath ?? DBNull.Value);

            con.Open();
            cmd.ExecuteNonQuery();
            txtTweet.Text = "";
            txtModalTweet.Text = "";
            ShowMessage("Your post was sent!", "success");

            LoadTweets();
            con.Close();
        }

        protected string RenderTweetImage(object imagePathObj)
        {
            string imagePath = imagePathObj as string;
            if (string.IsNullOrWhiteSpace(imagePath)) return string.Empty;

            string url = ResolveUrl("~/" + imagePath.TrimStart('/'));
            return "<div class=\"tweet-image-wrap\"><img src=\"" + url + "\" class=\"tweet-image\" alt=\"Tweet image\" loading=\"lazy\" /></div>";
        }


        protected string GetTimeAgo(DateTime createdAt)
        {
            TimeSpan diff = DateTime.Now - createdAt;

            if (diff.TotalMinutes < 1) return "just now";
            if (diff.TotalMinutes < 60) return (int)diff.TotalMinutes + "m";
            if (diff.TotalHours < 24) return (int)diff.TotalHours + "h";
            if (diff.TotalDays < 7) return (int)diff.TotalDays + "d";

            return createdAt.ToString("MMM d");
        }

        private void ShowMessage(string text, string type)
        {
            lblMessage.Text = text;
            lblMessage.CssClass = $"alert-tweet d-block alert alert-{type}";
            lblMessage.Visible = true;
        }

        protected void btnSubmitReport_Click(object sender, EventArgs e)
        {
            string reporterEmail = Session["Email"].ToString();
            int tweetId = Convert.ToInt32(hdnReportTweetId.Value);
            string reason = hdnReportReason.Value;

            SqlConnection con = new SqlConnection(strcon);
            string query = "INSERT INTO Reports (ReporterEmail, ReportedTweetId, Reason) " +
                           "VALUES (@ReporterEmail, @TweetId, @Reason)";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@ReporterEmail", reporterEmail);
            cmd.Parameters.AddWithValue("@TweetId", tweetId);
            cmd.Parameters.AddWithValue("@Reason", reason);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            ShowMessage("Report submitted successfully.", "success");
            LoadTweets();
        }

        protected void btnSubmitComment_Click(object sender, EventArgs e)
        {
            string email = Session["Email"].ToString();
            int tweetId = Convert.ToInt32(hdnCommentTweetId.Value);
            string commentText = txtComment.Text.Trim();

            if (string.IsNullOrEmpty(commentText)) return;

            SqlConnection con = new SqlConnection(strcon);
            string query = "INSERT INTO Comments (TweetId, Email, CommentText, CreatedAt) " +
                           "VALUES (@TweetId, @Email, @CommentText, GETDATE())";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@TweetId", tweetId);
            cmd.Parameters.AddWithValue("@Email", email);
            cmd.Parameters.AddWithValue("@CommentText", commentText);
            con.Open();
            cmd.ExecuteNonQuery();
            con.Close();

            txtComment.Text = "";
            LoadTweets();
        }

        protected void btnSubmitLike_Click(object sender, EventArgs e)
        {
            string email = Session["Email"].ToString();
            int tweetId = Convert.ToInt32(hdnLikeTweetId.Value);

            SqlConnection con = new SqlConnection(strcon);
            // Check if already liked
            SqlCommand check = new SqlCommand("SELECT COUNT(*) FROM Likes WHERE TweetId=@TweetId AND Email=@Email", con);
            check.Parameters.AddWithValue("@TweetId", tweetId);
            check.Parameters.AddWithValue("@Email", email);
            con.Open();
            int exists = (int)check.ExecuteScalar();

            if (exists == 0)
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO Likes (TweetId, Email) VALUES (@TweetId, @Email)", con);
                cmd.Parameters.AddWithValue("@TweetId", tweetId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.ExecuteNonQuery();
            }
            else
            {
                // Unlike if already liked
                SqlCommand cmd = new SqlCommand("DELETE FROM Likes WHERE TweetId=@TweetId AND Email=@Email", con);
                cmd.Parameters.AddWithValue("@TweetId", tweetId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.ExecuteNonQuery();
            }
            con.Close();
            LoadTweets();
        }

        protected void btnSubmitRepost_Click(object sender, EventArgs e)
        {
            string email = Session["Email"].ToString();
            int tweetId = Convert.ToInt32(hdnRepostTweetId.Value);

            SqlConnection con = new SqlConnection(strcon);
            SqlCommand check = new SqlCommand("SELECT COUNT(*) FROM Retweets WHERE TweetId=@TweetId AND Email=@Email", con);
            check.Parameters.AddWithValue("@TweetId", tweetId);
            check.Parameters.AddWithValue("@Email", email);
            con.Open();
            int exists = (int)check.ExecuteScalar();

            if (exists == 0)
            {
                SqlCommand cmd = new SqlCommand("INSERT INTO Retweets (TweetId, Email, RetweetedAt) VALUES (@TweetId, @Email, GETDATE())", con);
                cmd.Parameters.AddWithValue("@TweetId", tweetId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.ExecuteNonQuery();
            }
            else
            {
                SqlCommand cmd = new SqlCommand("DELETE FROM Retweets WHERE TweetId=@TweetId AND Email=@Email", con);
                cmd.Parameters.AddWithValue("@TweetId", tweetId);
                cmd.Parameters.AddWithValue("@Email", email);
                cmd.ExecuteNonQuery();
            }
            con.Close();
            LoadTweets();
        }
    }
}
