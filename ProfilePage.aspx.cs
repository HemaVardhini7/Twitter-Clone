using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;

namespace EliteTweet
{
    public partial class ProfilePage : Page
    {
        string strcon = ConfigurationManager.ConnectionStrings["TwitterDB"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["Email"] == null)
            {
                Response.Redirect("LoginForm.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadProfile();
                LoadPosts();
                LoadLikedTweets();
                LoadReplies();
            }
        }

        private void LoadProfile()
        {
            string email = Session["Email"].ToString();

            SqlConnection con = new SqlConnection(strcon);
            string query = "SELECT Name, Username, ISNULL(IsVerified, 0) AS IsVerified FROM Users WHERE Email = @Email";
            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", email);

            con.Open();
            SqlDataReader dr = cmd.ExecuteReader();

            if (dr.Read())
            {
                string name = dr["Name"].ToString();
                string username = "@" + dr["Username"].ToString();
                bool isVerified = (bool)dr["IsVerified"];

                lblSidebarName.Text = name;
                lblSidebarUsername.Text = username;
                lblTopName.Text = name;
                lblName.Text = name;
                lblUsername.Text = username;
                lblJoined.Text = "Joined March 2026";

                if (isVerified)
                    lblTopVerified.Text = " <i class=\"bi bi-patch-check-fill\" style=\"color:#1d9bf0;\"></i>";

                pnlNotVerified.Visible = !isVerified;
                pnlVerified.Visible = isVerified;
            }
            con.Close();

            
            SqlConnection con2 = new SqlConnection(strcon);
            SqlCommand cmd2 = new SqlCommand("SELECT COUNT(*) FROM Tweets WHERE Email = @Email", con2);
            cmd2.Parameters.AddWithValue("@Email", email);
            con2.Open();
            int postCount = (int)cmd2.ExecuteScalar();
            con2.Close();
            lblTopPostCount.Text = postCount + " posts";

            SqlConnection con3 = new SqlConnection(strcon);
            SqlCommand cmd3 = new SqlCommand("SELECT COUNT(*) FROM Followers WHERE FollowerEmail = @Email", con3);
            cmd3.Parameters.AddWithValue("@Email", email);
            con3.Open();
            int following = (int)cmd3.ExecuteScalar();
            con3.Close();
            lblFollowingCount.Text = following.ToString();

            SqlConnection con4 = new SqlConnection(strcon);
            SqlCommand cmd4 = new SqlCommand("SELECT COUNT(*) FROM Followers WHERE FollowingEmail = @Email", con4);
            cmd4.Parameters.AddWithValue("@Email", email);
            con4.Open();
            int followers = (int)cmd4.ExecuteScalar();
            con4.Close();
            lblFollowerCount.Text = followers.ToString();
        }

        private void LoadPosts()
        {
            string email = Session["Email"].ToString();

            SqlConnection con = new SqlConnection(strcon);
            string query = "SELECT t.TweetId, t.TweetText, t.CreatedAt, u.Name, u.Username, " +
                           "ISNULL(u.IsVerified, 0) AS IsVerified, " +
                           "(SELECT COUNT(*) FROM Likes    l WHERE l.TweetId = t.TweetId) AS LikeCount, " +
                           "(SELECT COUNT(*) FROM Comments c WHERE c.TweetId = t.TweetId) AS CommentCount, " +
                           "(SELECT COUNT(*) FROM Retweets r WHERE r.TweetId = t.TweetId) AS RetweetCount " +
                           "FROM Tweets t " +
                           "INNER JOIN Users u ON t.Email = u.Email " +
                           "WHERE t.Email = @Email " +
                           "ORDER BY t.CreatedAt DESC";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", email);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Open();
            da.Fill(dt);
            con.Close();

            rptPosts.DataSource = dt;
            rptPosts.DataBind();

            pnlNoPosts.Visible = (dt.Rows.Count == 0);
        }

        private void LoadLikedTweets()
        {
            string email = Session["Email"].ToString();

            SqlConnection con = new SqlConnection(strcon);
            string query = "SELECT t.TweetId, t.TweetText, t.CreatedAt, u.Name, u.Username, " +
                           "ISNULL(u.IsVerified, 0) AS IsVerified, " +
                           "(SELECT COUNT(*) FROM Likes    l WHERE l.TweetId = t.TweetId) AS LikeCount, " +
                           "(SELECT COUNT(*) FROM Comments c WHERE c.TweetId = t.TweetId) AS CommentCount, " +
                           "(SELECT COUNT(*) FROM Retweets r WHERE r.TweetId = t.TweetId) AS RetweetCount " +
                           "FROM Tweets t " +
                           "INNER JOIN Users u ON t.Email = u.Email " +
                           "INNER JOIN Likes lk ON lk.TweetId = t.TweetId " +
                           "WHERE lk.Email = @Email " +
                           "ORDER BY t.CreatedAt DESC";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", email);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Open();
            da.Fill(dt);
            con.Close();

            rptLikes.DataSource = dt;
            rptLikes.DataBind();

            pnlNoLikes.Visible = (dt.Rows.Count == 0);
        }
        private void LoadReplies()
        {
            string email = Session["Email"].ToString();

            SqlConnection con = new SqlConnection(strcon);
            string query = "SELECT c.CommentText, c.CreatedAt, u.Name, u.Username, " +
               "ISNULL(u.IsVerified, 0) AS IsVerified, " +
               "tu.Username AS TweetAuthor , t.TweetText " +
               "FROM Comments c " +
               "INNER JOIN Users u  ON c.Email   = u.Email " +
               "INNER JOIN Tweets t ON c.TweetId = t.TweetId " +
               "INNER JOIN Users tu ON t.Email   = tu.Email " +
               "WHERE t.Email = @Email " +
               "ORDER BY c.CreatedAt DESC";

            SqlCommand cmd = new SqlCommand(query, con);
            cmd.Parameters.AddWithValue("@Email", email);

            SqlDataAdapter da = new SqlDataAdapter(cmd);
            DataTable dt = new DataTable();
            con.Open();
            da.Fill(dt);
            con.Close();

            rptReplies.DataSource = dt;
            rptReplies.DataBind();

            pnlNoReplies.Visible = (dt.Rows.Count == 0);
        }
    }
}
