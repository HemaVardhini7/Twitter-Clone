<%@ Page Language="C#" AutoEventWireup="true"
    CodeBehind="Notifications.aspx.cs"
    Inherits="EliteTweet.Notifications" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Notifications / EliteTweet</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            background: #000;
            color: white;
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
            padding: 25px 15px;
            border-right: 1px solid #2f3336;
        }

        .logo {
            font-size: 25px;
            font-weight: bold;
            margin-bottom: 30px;
        }

        .nav-item {
            display: block;
            padding: 15px;
            color: white;
            text-decoration: none;
            border-radius: 30px;
            font-size: 18px;
        }

        .nav-item:hover, .nav-item.active {
            background: #202327;
        }

        .nav-item i { margin-right: 15px; }

        .main {
            flex: 1;
            min-width: 0;
            border-right: 1px solid #2f3336;
        }

        .header {
            padding: 20px;
            font-size: 22px;
            font-weight: bold;
            border-bottom: 1px solid #2f3336;
        }

        .section-title {
            padding: 18px 20px;
            font-size: 17px;
            font-weight: bold;
            border-bottom: 1px solid #2f3336;
        }

        .notification {
            display: flex;
            align-items: flex-start;
            gap: 15px;
            padding: 18px 20px;
            border-bottom: 1px solid #2f3336;
        }

        .notification-icon {
            font-size: 25px;
            flex-shrink: 0;
        }

        .heart { color: #f91880; }
        .comment { color: #1d9bf0; }
        .follow { color: #00ba7c; }

        .notification-content {
            flex: 1;
            min-width: 0;
        }

        .username, .time {
            color: #71767b;
            font-size: 13px;
            margin-top: 5px;
        }

        .preview {
            color: #aab8c2;
            font-size: 14px;
            margin-top: 8px;
            overflow-wrap: anywhere;
        }

        .actions {
            display: flex;
            gap: 10px;
            margin-top: 14px;
        }

        .action-btn {
            padding: 9px 18px;
            border-radius: 25px;
            font-weight: bold;
            font-size: 13px;
            text-decoration: none;
        }

        .accept {
            background: #1d9bf0;
            color: white;
        }

        .reject {
            border: 1px solid #536471;
            color: white;
        }

        .empty {
            padding: 25px 20px;
            color: #71767b;
        }

        @media (max-width: 650px) {
            .sidebar { width: 65px; padding: 15px 5px; }
            .logo, .nav-text { display: none; }
            .nav-item { text-align: center; }
            .nav-item i { margin: 0; }
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

            <a href="Explore.aspx" class="nav-item">
                <i class="bi bi-search"></i>
                <span class="nav-text">Explore</span>
            </a>

            <a href="Notifications.aspx" class="nav-item active">
                <i class="bi bi-bell"></i>
                <span class="nav-text">Notifications</span>
            </a>

            <a href="Bookmarks.aspx" class="nav-item">
                <i class="bi bi-bookmark"></i>
                <span class="nav-text">Bookmarks</span>
            </a>

            <a href="ProfilePage.aspx" class="nav-item">
                <i class="bi bi-person"></i>
                <span class="nav-text">Profile</span>
            </a>
        </aside>

        <main class="main">
            <div class="header">Notifications</div>

            <!-- FOLLOW REQUESTS -->
            <div class="section-title">Follow Requests</div>

            <asp:Repeater ID="rptRequests" runat="server"
                OnItemCommand="rptRequests_ItemCommand">
                <ItemTemplate>
                    <div class="notification">
                        <i class="bi bi-person-plus-fill notification-icon follow"></i>

                        <div class="notification-content">
                            <strong><%#: Eval("Name") %></strong>
                            wants to follow you

                            <div class="username">
                                @<%#: Eval("Username") %>
                            </div>

                            <div class="actions">
                                <asp:LinkButton ID="btnAccept" runat="server"
                                    CssClass="action-btn accept"
                                    CommandName="AcceptRequest"
                                    CommandArgument='<%# Eval("FollowerId") %>'>
                                    Accept
                                </asp:LinkButton>

                                <asp:LinkButton ID="btnReject" runat="server"
                                    CssClass="action-btn reject"
                                    CommandName="RejectRequest"
                                    CommandArgument='<%# Eval("FollowerId") %>'>
                                    Reject
                                </asp:LinkButton>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoRequests" runat="server"
                CssClass="empty" Visible="false">
                No pending follow requests.
            </asp:Panel>

            <!-- LIKES AND COMMENTS -->
            <div class="section-title">Activity</div>

            <asp:Repeater ID="rptActivity" runat="server">
                <ItemTemplate>
                    <div class="notification">

                        <i class='<%# Eval("Type").ToString() == "Like"
                            ? "bi bi-heart-fill notification-icon heart"
                            : "bi bi-chat-fill notification-icon comment" %>'>
                        </i>

                        <div class="notification-content">
                            <strong><%#: Eval("Name") %></strong>

                            <%# Eval("Type").ToString() == "Like"
                                ? "liked your tweet"
                                : "commented on your tweet" %>

                            <div class="username">
                                @<%#: Eval("Username") %>
                            </div>

                            <div class="preview">
                                <%#: Eval("Preview") %>
                            </div>

                            <div class="time">
                                <%# GetTimeAgo(Convert.ToDateTime(Eval("CreatedAt"))) %>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlNoActivity" runat="server"
                CssClass="empty" Visible="false">
                No likes or comments yet.
            </asp:Panel>
        </main>
    </div>
</form>
</body>
</html>