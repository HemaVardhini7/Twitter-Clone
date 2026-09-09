<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="EliteTweet.AdminDashboard" %>
<!DOCTYPE html>
<html lang="en">
<head runat="server">
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>Admin Dashboard – EliteTweet</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background-color: #000;
            color: #e7e9ea;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, sans-serif;
            min-height: 100vh;
        }

        /* ── TOP NAV ── */
        .topbar {
            position: sticky;
            top: 0;
            z-index: 100;
            background: rgba(0,0,0,0.85);
            backdrop-filter: blur(12px);
            border-bottom: 1px solid #2f3336;
            padding: 0 24px;
            height: 56px;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }
        .topbar-left { display: flex; align-items: center; gap: 12px; }
        .topbar-left i { font-size: 22px; color: #1d9bf0; }
        .topbar-left span { font-size: 18px; font-weight: 700; }
        .topbar-right { display: flex; align-items: center; gap: 16px; }
        .btn-logout {
            background: transparent;
            border: 1px solid #2f3336;
            color: #e7e9ea;
            padding: 6px 16px;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            transition: background 0.2s;
        }
        .btn-logout:hover { background: #1a1a1a; }

        /* ── LAYOUT ── */
        .container { max-width: 900px; margin: 0 auto; padding: 24px 16px; }

        /* ── STATS CARDS ── */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 12px;
            margin-bottom: 28px;
        }
        .stat-card {
            background: #16181c;
            border: 1px solid #2f3336;
            border-radius: 16px;
            padding: 20px;
            text-align: center;
        }
        .stat-card .stat-num {
            font-size: 28px;
            font-weight: 800;
            color: #1d9bf0;
        }
        .stat-card .stat-label {
            font-size: 13px;
            color: #71767b;
            margin-top: 4px;
        }

        /* ── TABS ── */
        .tabs {
            display: flex;
            border-bottom: 1px solid #2f3336;
            margin-bottom: 20px;
        }
        .tab-btn {
            flex: 1;
            background: transparent;
            border: none;
            color: #71767b;
            font-size: 15px;
            font-weight: 600;
            padding: 16px 0;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            transition: color 0.2s;
        }
        .tab-btn:hover { color: #e7e9ea; background: #0d0d0d; }
        .tab-btn.active { color: #e7e9ea; border-bottom: 2px solid #1d9bf0; }

        /* ── TAB PANELS ── */
        .tab-panel { display: none; }
        .tab-panel.active { display: block; }

        /* ── TABLE ── */
        .admin-table {
            width: 100%;
            border-collapse: collapse;
            font-size: 14px;
        }
        .admin-table th {
            text-align: left;
            padding: 10px 12px;
            color: #71767b;
            font-weight: 600;
            border-bottom: 1px solid #2f3336;
            font-size: 13px;
        }
        .admin-table td {
            padding: 12px;
            border-bottom: 1px solid #1a1a1a;
            vertical-align: middle;
        }
        .admin-table tr:hover td { background: #0d0d0d; }

        .badge-verified {
            background: #1d9bf0;
            color: #fff;
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 10px;
            font-weight: 600;
        }
        .badge-unverified {
            background: #2f3336;
            color: #71767b;
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 10px;
        }
        .badge-pending {
            background: #ffa500;
            color: #000;
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 10px;
            font-weight: 600;
        }
        .badge-resolved {
            background: #00ba7c;
            color: #000;
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 10px;
            font-weight: 600;
        }

        /* ── ACTION BUTTONS ── */
        .btn-action {
            border: none;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            margin-right: 4px;
            transition: opacity 0.2s;
        }
        .btn-action:hover { opacity: 0.8; }
        .btn-verify   { background: #1d9bf0; color: #fff; }
        .btn-unverify { background: #2f3336; color: #e7e9ea; }
        .btn-delete   { background: #f4212e; color: #fff; }
        .btn-resolve  { background: #00ba7c; color: #000; }

        /* ── TWEET TEXT TRUNCATE ── */
        .tweet-truncate {
            max-width: 320px;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
            color: #e7e9ea;
        }

        /* ── EMPTY STATE ── */
        .empty-state {
            text-align: center;
            color: #71767b;
            padding: 48px 0;
            font-size: 15px;
        }
        .empty-state i { font-size: 36px; display: block; margin-bottom: 10px; }

        /* ── SECTION HEADER ── */
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }
        .section-header h2 { font-size: 16px; font-weight: 700; }
    </style>
</head>
<body>
<form id="form1" runat="server">

    <!-- TOP NAV -->
    <div class="topbar">
        <div class="topbar-left">
            <i class="bi bi-shield-fill-check"></i>
            <span>Admin Dashboard</span>
        </div>
        <div class="topbar-right">
            <span style="color:#71767b; font-size:14px;">Welcome, <strong style="color:#e7e9ea;">Admin</strong></span>
            <asp:Button ID="btnLogout" runat="server" Text="Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
        </div>
    </div>

    <div class="container">

        <!-- STATS ROW -->
        <div class="stats-row">
            <div class="stat-card">
                <div class="stat-num"><asp:Label ID="lblTotalUsers" runat="server" Text="0" /></div>
                <div class="stat-label"><i class="bi bi-people"></i> Total Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-num"><asp:Label ID="lblTotalTweets" runat="server" Text="0" /></div>
                <div class="stat-label"><i class="bi bi-chat-left-text"></i> Total Tweets</div>
            </div>
            <div class="stat-card">
                <div class="stat-num"><asp:Label ID="lblVerifiedUsers" runat="server" Text="0" /></div>
                <div class="stat-label"><i class="bi bi-patch-check"></i> Verified Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-num"><asp:Label ID="lblPendingReports" runat="server" Text="0" /></div>
                <div class="stat-label"><i class="bi bi-flag"></i> Pending Reports</div>
            </div>
        </div>

        <!-- TABS -->
        <div class="tabs">
            <button type="button" class="tab-btn active" onclick="switchTab('users', this)">
                <i class="bi bi-people"></i> Users
            </button>
            <button type="button" class="tab-btn" onclick="switchTab('tweets', this)">
                <i class="bi bi-chat-left-text"></i> Tweets
            </button>
            <button type="button" class="tab-btn" onclick="switchTab('reports', this)">
                <i class="bi bi-flag"></i> Reports
            </button>
        </div>

        <!-- ══ USERS TAB ══ -->
        <div id="tab-users" class="tab-panel active">
            <div class="section-header">
                <h2>All Users</h2>
            </div>

            <asp:Panel ID="pnlNoUsers" runat="server" Visible="false">
                <div class="empty-state"><i class="bi bi-people"></i>No users found.</div>
            </asp:Panel>

            <asp:Repeater ID="rptUsers" runat="server" OnItemCommand="rptUsers_ItemCommand">
                <HeaderTemplate>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Name</th>
                                <th>Username</th>
                                <th>Email</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td style="color:#71767b;"><%# Eval("UserId") %></td>
                        <td><strong><%# Eval("Name") %></strong></td>
                        <td style="color:#71767b;">@<%# Eval("Username") %></td>
                        <td style="color:#71767b;"><%# Eval("Email") %></td>
                        <td>
                            <%# Convert.ToBoolean(Eval("IsVerified"))
                                ? "<span class='badge-verified'>✓ Verified</span>"
                                : "<span class='badge-unverified'>Unverified</span>" %>
                        </td>
                        <td>
                            <%# Convert.ToBoolean(Eval("IsVerified"))
                                ? "<asp:Button runat='server' />"
                                : "" %>
                            <asp:LinkButton runat="server"
                                CommandName='<%# Convert.ToBoolean(Eval("IsVerified")) ? "Unverify" : "Verify" %>'
                                CommandArgument='<%# Eval("Email") %>'
                                CssClass='<%# "btn-action " + (Convert.ToBoolean(Eval("IsVerified")) ? "btn-unverify" : "btn-verify") %>'
                                Text='<%# Convert.ToBoolean(Eval("IsVerified")) ? "Unverify" : "Verify" %>'
                                OnClientClick="return confirm('Are you sure?');" />
                            <asp:LinkButton runat="server"
                                CommandName="DeleteUser"
                                CommandArgument='<%# Eval("Email") %>'
                                CssClass="btn-action btn-delete"
                                Text="Delete"
                                OnClientClick="return confirm('Delete this user permanently?');" />
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <!-- ══ TWEETS TAB ══ -->
        <div id="tab-tweets" class="tab-panel">
            <div class="section-header">
                <h2>All Tweets</h2>
            </div>

            <asp:Panel ID="pnlNoTweets" runat="server" Visible="false">
                <div class="empty-state"><i class="bi bi-chat-left-text"></i>No tweets found.</div>
            </asp:Panel>

            <asp:Repeater ID="rptTweets" runat="server" OnItemCommand="rptTweets_ItemCommand">
                <HeaderTemplate>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>User</th>
                                <th>Tweet</th>
                                <th>Posted</th>
                                <th>Likes</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td style="color:#71767b;"><%# Eval("TweetId") %></td>
                        <td>
                            <strong><%# Eval("Name") %></strong><br />
                            <span style="color:#71767b; font-size:12px;">@<%# Eval("Username") %></span>
                        </td>
                        <td><div class="tweet-truncate"><%# Eval("TweetText") %></div></td>
                        <td style="color:#71767b; font-size:12px;"><%# GetTimeAgo((DateTime)Eval("CreatedAt")) %></td>
                        <td style="color:#f91880;"><%# Eval("LikeCount") %> <i class="bi bi-heart-fill" style="font-size:11px;"></i></td>
                        <td>
                            <asp:LinkButton runat="server"
                                CommandName="DeleteTweet"
                                CommandArgument='<%# Eval("TweetId") %>'
                                CssClass="btn-action btn-delete"
                                Text="Delete"
                                OnClientClick="return confirm('Delete this tweet?');" />
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>

        <!-- ══ REPORTS TAB ══ -->
        <div id="tab-reports" class="tab-panel">
            <div class="section-header">
                <h2>Reports &amp; Complaints</h2>
            </div>

            <asp:Panel ID="pnlNoReports" runat="server" Visible="false">
                <div class="empty-state"><i class="bi bi-flag"></i>No reports yet.</div>
            </asp:Panel>

            <asp:Repeater ID="rptReports" runat="server" OnItemCommand="rptReports_ItemCommand">
                <HeaderTemplate>
                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Reported By</th>
                                <th>Reason</th>
                                <th>Tweet / User</th>
                                <th>Date</th>
                                <th>Status</th>
                                <th>Action</th>
                            </tr>
                        </thead>
                        <tbody>
                </HeaderTemplate>
                <ItemTemplate>
                    <tr>
                        <td style="color:#71767b;"><%# Eval("ReportId") %></td>
                        <td style="color:#71767b;"><%# Eval("ReporterEmail") %></td>
                        <td><%# Eval("Reason") %></td>
                        <td style="color:#71767b; font-size:12px;">
                            <%# Eval("ReportedTweetId") != DBNull.Value ? "Tweet #" + Eval("ReportedTweetId") : "" %>
                            <%# Eval("ReportedEmail") != DBNull.Value && Eval("ReportedEmail").ToString() != "" ? "@" + Eval("ReportedEmail") : "" %>
                        </td>
                        <td style="color:#71767b; font-size:12px;"><%# GetTimeAgo((DateTime)Eval("CreatedAt")) %></td>
                        <td>
                            <%# Eval("Status").ToString() == "Pending"
                                ? "<span class='badge-pending'>Pending</span>"
                                : "<span class='badge-resolved'>Resolved</span>" %>
                        </td>
                        <td>
                            
                            <asp:LinkButton runat="server"
                                CommandName="Resolve"
                                CommandArgument='<%# Eval("ReportId") %>'
                                CssClass="btn-action btn-resolve"
                                Text="Resolve"
                                Visible='<%# Eval("Status").ToString() == "Pending" %>' />
                            <asp:LinkButton runat="server"
                                CommandName="DeleteReport"
                                CommandArgument='<%# Eval("ReportId") %>'
                                CssClass="btn-action btn-delete"
                                Text="Delete"
                                OnClientClick="return confirm('Delete this report?');" />
                        </td>
                    </tr>
                </ItemTemplate>
                <FooterTemplate>
                        </tbody>
                    </table>
                </FooterTemplate>
            </asp:Repeater>
        </div>

    </div><!-- /container -->

</form>

<script>
    function switchTab(tabName, btn) {
        // hide all panels
        document.querySelectorAll('.tab-panel').forEach(p => p.classList.remove('active'));
        document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
        // show selected
        document.getElementById('tab-' + tabName).classList.add('active');
        btn.classList.add('active');
    }
</script>
</body>
</html>
