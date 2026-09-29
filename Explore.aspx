<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Explore.aspx.cs" Inherits="EliteTweet.Explore" %>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Explore / EliteTweet</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />

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

        .search-box {
            display: flex;
            gap: 10px;
            padding: 20px;
            border-bottom: 1px solid #2f3336;
        }

        .search-input {
            flex: 1;
            min-width: 0;
            background: #202327;
            color: white;
            border: 1px solid transparent;
            border-radius: 30px;
            padding: 13px 20px;
            outline: none;
        }

        .search-input:focus { border-color: #1d9bf0; }

        .search-btn {
            background: #1d9bf0;
            border: none;
            border-radius: 30px;
            color: white;
            padding: 10px 22px;
            font-weight: bold;
            cursor: pointer;
        }

        .user-card {
            display: flex;
            align-items: center;
            gap: 15px;
            padding: 20px;
            border-bottom: 1px solid #2f3336;
        }

        .avatar {
            width: 50px;
            height: 50px;
            border-radius: 50%;
            background: #536471;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 23px;
            flex-shrink: 0;
        }

        .user-info { flex: 1; min-width: 0; }

        .name { font-weight: bold; }

        .username {
            color: #71767b;
            margin-top: 5px;
        }

        .profile-btn {
            background: white;
            color: black;
            padding: 9px 16px;
            border-radius: 25px;
            text-decoration: none;
            font-size: 13px;
            font-weight: bold;
            white-space: nowrap;
        }

        .empty {
            text-align: center;
            padding: 50px 20px;
            color: #71767b;
        }

        @media (max-width: 650px) {
            .sidebar { width: 65px; padding: 15px 5px; }
            .logo, .nav-text { display: none; }
            .nav-item { text-align: center; }
            .nav-item i { margin: 0; }
            .search-box { padding: 12px; }
            .user-card { padding: 12px; }
        }

        .follow-btn {
            background: #1d9bf0;
            color: white;
            border: none;
            border-radius: 25px;
            padding: 9px 18px;
            font-size: 13px;
            font-weight: bold;
            text-decoration: none;
            white-space: nowrap;
        }

        .follow-btn:hover {
            background: #1a8cd8;
            color: white;
        }

        .follow-btn.pending {
            background: transparent;
            border: 1px solid #536471;
        }

        .follow-btn.following {
            background: white;
            color: black;
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

            <a href="Explore.aspx" class="nav-item active">
                <i class="bi bi-search"></i>
                <span class="nav-text">Explore</span>
            </a>

            <a class="nav-item" href="Notifications.aspx">
                <i class="bi bi-bell"></i> Notifications
            </a>

            <a href="ProfilePage.aspx" class="nav-item">
                <i class="bi bi-person"></i>
                <span class="nav-text">Profile</span>
            </a>
        </aside>

        <main class="main">
            <div class="header">Explore</div>

            <div class="search-box">
                <asp:TextBox ID="txtSearch" runat="server"
                    CssClass="search-input"
                    placeholder="Search by name, username or user ID" />

                <asp:Button ID="btnSearch" runat="server"
                    Text="Search"
                    CssClass="search-btn"
                    OnClick="btnSearch_Click" />
            </div>

           <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand" OnItemDataBound="rptUsers_ItemDataBound">
                <ItemTemplate>
                    <div class="user-card">
                        <div class="avatar">
                            <i class="bi bi-person-fill"></i>
                        </div>

                        <div class="user-info">
                            <div class="name"><%#: Eval("Name") %></div>
                            <div class="username">@<%#: Eval("Username") %></div>
                        </div>

                        <a class="profile-btn"
                            href='<%# "ProfilePage.aspx?username=" + Server.UrlEncode(Eval("Username").ToString()) %>'>
                            View Profile
                        </a>
                        <asp:LinkButton ID="btnFollow" runat="server"
                            CssClass="follow-btn"
                            CommandName="ToggleFollow"
                            CommandArgument='<%# Eval("UserId") %>'>
                            Follow
                        </asp:LinkButton>
                    </div>
                </ItemTemplate>
            </asp:Repeater>

            <asp:Panel ID="pnlEmpty" runat="server" CssClass="empty" Visible="false">
                No users found.
            </asp:Panel>
        </main>
    </div>
</form>
</body>
</html>