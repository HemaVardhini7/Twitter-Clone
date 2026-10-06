<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegistrationForm.aspx.cs" Inherits="EliteTweet.RegistrationForm"
    UnobtrusiveValidationMode="None" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create account / EliteTweet</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }

        body {
            background: #000;
            color: #e7e9ea;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .auth-box {
            width: 100%;
            max-width: 440px;
        }

        /* Logo */
        .auth-logo {
            text-align: center;
            font-size: 32px;
            margin-bottom: 32px;
            color: #fff;
        }

        .auth-title    { font-size: 28px; font-weight: 800; margin-bottom: 6px; line-height: 1.2; }
        .auth-subtitle { font-size: 14px; color: #71767b; margin-bottom: 28px; }

        /* ── Floating-label input ── */
        .tw-field {
            position: relative;
            margin-bottom: 20px;
        }

        .tw-input {
            display: block;
            width: 100%;
            background: transparent;
            border: 1px solid #333639;
            border-radius: 4px;
            color: #e7e9ea;
            font-size: 17px;
            padding: 22px 12px 8px;
            outline: none;
            transition: border-color 0.2s;
        }
        .tw-input:focus { border-color: #1d9bf0; }
        .tw-input::placeholder { color: transparent; }

        .tw-label {
            position: absolute;
            top: 16px;
            left: 12px;
            color: #71767b;
            font-size: 17px;
            transition: 0.15s ease all;
            pointer-events: none;
        }
        .tw-input:focus ~ .tw-label,
        .tw-input.filled ~ .tw-label {
            top: 6px;
            font-size: 11px;
            color: #1d9bf0;
        }

        /* ── Date of birth ── */
        .dob-title {
            font-size: 15px;
            font-weight: 700;
            color: #e7e9ea;
            margin-bottom: 4px;
            display: block;
        }

        .dob-note {
            font-size: 13px;
            color: #71767b;
            margin-bottom: 14px;
            line-height: 1.5;
        }

        .dob-row {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            gap: 12px;
            margin-bottom: 24px;
        }

        .tw-select {
            width: 100%;
            background: transparent;
            border: 1px solid #333639;
            border-radius: 4px;
            color: #e7e9ea;
            font-size: 15px;
            padding: 13px 12px;
            outline: none;
            cursor: pointer;
            transition: border-color 0.2s;
            -webkit-appearance: none;
            appearance: none;
        }
        .tw-select:focus { border-color: #1d9bf0; }
        .tw-select option { background: #1a1a1a; color: #e7e9ea; }

        /* ── Buttons ── */
        .btn-white {
            display: block;
            width: 100%;
            background: #fff;
            color: #000;
            border: none;
            border-radius: 9999px;
            font-size: 17px;
            font-weight: 700;
            padding: 14px;
            cursor: pointer;
            transition: background 0.2s;
            text-align: center;
            margin-bottom: 14px;
        }
        .btn-white:hover { background: #e7e9ea; }

        /* ── Message ── */
        .msg {
            display: block;
            text-align: center;
            font-size: 14px;
            margin-top: 8px;
            min-height: 1.2em;
        }

        .auth-footer {
            margin-top: 24px;
            font-size: 15px;
            color: #71767b;
            text-align: center;
        }

        .auth-link { color: #1d9bf0; text-decoration: none; font-weight: 700; }
        .auth-link:hover { text-decoration: underline; color: #1d9bf0; }
    </style>
</head>
<body>
<form id="form1" runat="server">
<div class="auth-box">

    <!-- Logo -->
    <div class="auth-logo">
        <i class="bi bi-twitter-x"></i>
    </div>

    <h2 class="auth-title">Create your account</h2>
    <p class="auth-subtitle">Fill in the details below to get started.</p>

    <!-- Name -->
    <div class="tw-field">
        <asp:TextBox ID="txtName" runat="server"
            CssClass="tw-input"
            MaxLength="50"
            placeholder=" " />
        <label class="tw-label">Name</label>
    </div>

    <!-- Email -->
    <div class="tw-field">
        <asp:TextBox ID="txtEmail" runat="server"
            CssClass="tw-input"
            placeholder=" " />
        <label class="tw-label">Email</label>
    </div>

    <!-- Date of birth -->
    <span class="dob-title">Date of birth</span>
    <p class="dob-note">
        This will not be shown publicly. Confirm your own age, even if this account is for a business, a pet, or something else.
    </p>

    <div class="dob-row">
        <asp:DropDownList ID="ddlMonth" runat="server" CssClass="tw-select">
            <asp:ListItem Text="Month" Value="" />
            <asp:ListItem>January</asp:ListItem>
            <asp:ListItem>February</asp:ListItem>
            <asp:ListItem>March</asp:ListItem>
            <asp:ListItem>April</asp:ListItem>
            <asp:ListItem>May</asp:ListItem>
            <asp:ListItem>June</asp:ListItem>
            <asp:ListItem>July</asp:ListItem>
            <asp:ListItem>August</asp:ListItem>
            <asp:ListItem>September</asp:ListItem>
            <asp:ListItem>October</asp:ListItem>
            <asp:ListItem>November</asp:ListItem>
            <asp:ListItem>December</asp:ListItem>
        </asp:DropDownList>

        <asp:DropDownList ID="ddlDay" runat="server" CssClass="tw-select" />

        <asp:DropDownList ID="ddlYear" runat="server" CssClass="tw-select" />
    </div>

    <!-- Next button -->
    <asp:Button ID="btnNext" runat="server"
        Text="Next"
        CssClass="btn-white"
        OnClick="Btn_Next_Click" />

    <asp:Label ID="lblMessage" runat="server" CssClass="msg" />

    <div class="auth-footer">
        Already have an account?
        <a href="LoginForm.aspx" class="auth-link">Sign in</a>
    </div>

</div>
</form>

<script>
    document.querySelectorAll('.tw-input').forEach(function (inp) {
        function upd() { inp.classList.toggle('filled', inp.value.length > 0); }
        inp.addEventListener('input', upd);
        upd();
    });
</script>
</body>
</html>
