<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UsernameForm.aspx.cs" Inherits="EliteTweet.UsernameForm1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Set up your account / EliteTweet</title>
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

        .auth-title {
            font-size: 28px;
            font-weight: 800;
            margin-bottom: 4px;
            line-height: 1.2;
        }

        .auth-subtitle {
            font-size: 15px;
            color: #71767b;
            margin-bottom: 28px;
        }

        /* ── Section heading ── */
        .section-title { font-size: 20px; font-weight: 700; margin: 24px 0 4px; }
        .section-note  { font-size: 14px; color: #71767b; margin-bottom: 16px; }

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

        .divider {
            border: none;
            border-top: 1px solid #2f3336;
            margin: 20px 0;
        }

        /* ── Button ── */
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
            margin-top: 8px;
        }
        .btn-white:hover { background: #e7e9ea; }

        /* ── Message ── */
        .msg {
            display: block;
            text-align: center;
            font-size: 14px;
            margin-top: 12px;
            min-height: 1.2em;
        }
    </style>
</head>
<body>
<form id="form1" runat="server">
<div class="auth-box">

    <!-- Logo -->
    <div class="auth-logo">
        <i class="bi bi-twitter-x"></i>
    </div>

    <h2 class="auth-title">What should we call you?</h2>
    <p class="auth-subtitle">Your @username is unique. You can always change it later.</p>

    <!-- Username -->
    <div class="tw-field">
        <asp:TextBox ID="txtUsername" runat="server"
            CssClass="tw-input"
            placeholder=" " />
        <label class="tw-label">Username</label>
    </div>

    <hr class="divider" />

    <h3 class="section-title">You'll need a password</h3>
    <p class="section-note">Make sure it's 8 characters or more.</p>

    <!-- Password -->
    <div class="tw-field">
        <asp:TextBox ID="txtPassword" runat="server"
            CssClass="tw-input"
            TextMode="Password"
            placeholder=" " />
        <label class="tw-label">Password</label>
    </div>

    <!-- Email (hidden — carried from session, shown read-only) -->
    <div class="tw-field">
        <asp:TextBox ID="txtEmail" runat="server"
            CssClass="tw-input"
            placeholder=" " />
        <label class="tw-label">Email</label>
    </div>

    <!-- Sign Up button -->
    <asp:Button ID="btn_SignUp" runat="server"
        Text="Sign Up"
        CssClass="btn-white"
        OnClick="SignUp_btn_click" />

    <asp:Label ID="lblMessage" runat="server" CssClass="msg" />

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
