using System;
using EliteTweet.AI;

namespace EliteTweet
{
    public partial class ContentSafetyTest : System.Web.UI.Page
    {
        protected async void btnCheck_Click(object sender, EventArgs e)
        {
            string content = txtContent.Text.Trim();

            if (string.IsNullOrEmpty(content))
            {
                lblResult.Text = "Please enter some content.";
                return;
            }

            ContentSafetyService service =
                new ContentSafetyService();

            ModerationResult result =
                await service.CheckContentAsync(content);

            if (!result.Success)
            {
                lblResult.Text =
                    "ERROR<br/>" +
                    "Category: " + result.Category +
                    "<br/>Reason: " + result.Reason;

                return;
            }

            if (result.IsSafe)
            {
                lblResult.Text =
                    "SAFE<br/>" +
                    "Category: " + result.Category +
                    "<br/>Reason: " + result.Reason;
            }
            else
            {
                lblResult.Text =
                    "UNSAFE<br/>" +
                    "Category: " + result.Category +
                    "<br/>Reason: " + result.Reason;
            }
        }
    }
}