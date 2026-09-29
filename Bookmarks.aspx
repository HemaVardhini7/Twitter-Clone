<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Bookmarks.aspx.cs"
    Inherits="EliteTweet.Bookmarks" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Bookmarks / EliteTweet</title>

    <meta name="viewport"
        content="width=device-width, initial-scale=1" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css"
        rel="stylesheet" />

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            background: #000;
            color: #fff;
            font-family: Arial, sans-serif;
        }

        .layout {
            display: flex;
            max-width: 1100px;
            min-height: 100vh;
            margin: auto;
        }

        .sidebar {
            width: 260px;
            padding: 30px 20px;
            border-right: 1px solid #2f3336;
        }

        .logo {
            color: #fff;
            font-size: 26px;
            font-weight: bold;
            margin-bottom: 35px;
        }

        .nav-item {
            display: block;
            padding: 15px;
            margin-bottom: 10px;
            color: #fff;
            text-decoration: none;
            font-size: 19px;
            border-radius: 30px;
        }

        .nav-item:hover,
        .nav-item.active {
            background: #202327;
        }

        .nav-item i {
            margin-right: 15px;
        }

        .main {
            flex: 1;
            min-width: 0;
            border-right: 1px solid #2f3336;
        }

        .header {
            padding: 20px;
            border-bottom: 1px solid #2f3336;
            font-size: 23px;
            font-weight: bold;
        }

        .tweet {
            padding: 20px;
            border-bottom: 1px solid #2f3336;
        }

        .tweet-name {
            font-weight: bold;
        }

        .username, .date {
            color: #71767b;
            font-size: 14px;
        }

        .tweet-text {
            margin: 15px 0;
            line-height: 1.5;
            white-space: pre-wrap;
            overflow-wrap: anywhere;
        }

        .tweet-image {
            width: 100%;
            max-height: 400px;
            object-fit: contain;
            border-radius: 15px;
            margin-bottom: 15px;
        }

        .actions {
            display: flex;
            align-items: center;
            justify-content: space-between;
            color: #71767b;
        }

        .remove-btn {
            background: none;
            border: none;
            color: #1d9bf0;
            cursor: pointer;
            font-size: 18px;
        }

        .remove-btn:hover {
            color: #f4212e;
        }

        .empty {
            text-align: center;
            padding: 80px 20px;
            color: #71767b;
        }

        .empty i {
            font-size: 48px;
        }

        @media (max-width: 650px) {
            .sidebar {
                width: 65px;
                padding: 20px 8px;
            }

            .sidebar .nav-text, .logo {
                display: none;
            }

            .nav-item {
                text-align: center;
                padding: 12px;
            }

            .nav-item i {
                margin: 0;
            }
        }
    </style>
</head>

<body>
<form id="form1" runat="server">
    <div class="layout">

        <aside class="sidebar">
            <div class="logo">EliteTweet</div>

            <a href="HomePage.aspx" class="nav-item">
                <i class="bi bi-house"></i>
                <span class="nav-text">Home</span>
            </a>

            <a href="Bookmarks.aspx" class="nav-item active">
                <i class="bi bi-bookmark-fill"></i>
                <span class="nav-text">Bookmarks</span>
            </a>

            <a href="ProfilePage.aspx" class="nav-item">
                <i class="bi bi-person"></i>
                <span class="nav-text">Profile</span>
            </a>
        </aside>

        <main class="main">
            <div class="header">
                <i class="bi bi-arrow-left"
                    onclick="history.back()"
                    style="cursor:pointer;margin-right:20px;"></i>
                Bookmarks
            </div>

            <asp:Repeater ID="rptBookmarks" runat="server"
                OnItemCommand="rptBookmarks_ItemCommand">
                <ItemTemplate>
                    <div class="tweet">

                        <div>
                            <span class="tweet-name">
                                <%#: Eval("Name") %>
                            </span>

                            <span class="username">
                                @<%#: Eval("Username") %>
                            </span>

                            <span class="date">
                                · <%# Eval("CreatedAt", "{0:dd MMM yyyy}") %>
                            </span>
                        </div>

                        <div class="tweet-text"><%#: Eval("TweetText") %></div>

                        <asp:Image runat="server"
                            CssClass="tweet-image"
                            ImageUrl='<%# Eval("ImagePath") %>'
                            Visible='<%# Eval("ImagePath") != DBNull.Value
                                && !string.IsNullOrWhiteSpace(Eval("ImagePath").ToString()) %>' />

                        <div class="actions">
                            <span>
                                <i class="bi bi-heart"></i>
                                <%# Eval("LikeCount") %>
                            </span>

                            <span>
                                <i class="bi bi-chat"></i>
                                <%# Eval("CommentCount") %>
                            </span>

                            <asp:LinkButton ID="btnRemove"
                                runat="server"
                                CssClass="remove-btn"
                                CommandName="RemoveBookmark"
                                CommandArgument='<%# Eval("TweetId") %>'
                                ToolTip="Remove bookmark">
                                <i class="bi bi-bookmark-fill"></i>
                            </asp:LinkButton>
                        </div>

                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlEmpty" runat="server"
                CssClass="empty" Visible="false">
                <i class="bi bi-bookmark"></i>
                <h2>No bookmarks yet</h2>
                <p>Save tweets to see them here.</p>
            </asp:Panel>

        </main>
    </div>
</form>
</body>
</html>