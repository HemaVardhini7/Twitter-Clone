<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginForm.aspx.cs" Inherits="EliteTweet.LoginForm" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign in / EliteTweet</title>
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
            max-width: 400px;
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
            margin-bottom: 28px;
            line-height: 1.2;
        }

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

        /* ── Buttons ── */
        .btn-blue {
            display: block;
            width: 100%;
            background: #1d9bf0;
            color: #fff;
            border: none;
            border-radius: 9999px;
            font-size: 17px;
            font-weight: 700;
            padding: 14px;
            cursor: pointer;
            margin-bottom: 14px;
            transition: background 0.2s;
            text-align: center;
        }
        .btn-blue:hover { background: #1a8cd8; }

        /* ── Divider ── */
        .divider {
            display: flex;
            align-items: center;
            gap: 12px;
            margin: 20px 0;
            color: #71767b;
            font-size: 14px;
        }
        .divider::before,
        .divider::after {
            content: '';
            flex: 1;
            border-top: 1px solid #2f3336;
        }

        /* ── Links ── */
        .forgot-link {
            display: block;
            text-align: right;
            color: #1d9bf0;
            font-size: 14px;
            font-weight: 700;
            text-decoration: none;
            margin-bottom: 20px;
        }
        .forgot-link:hover { text-decoration: underline; color: #1d9bf0; }

        .auth-footer {
            margin-top: 24px;
            font-size: 15px;
            color: #71767b;
            text-align: center;
        }

        .auth-link {
            color: #1d9bf0;
            text-decoration: none;
            font-weight: 700;
        }
        .auth-link:hover { text-decoration: underline; color: #1d9bf0; }

        /* ── Message ── */
        .msg {
            display: block;
            text-align: center;
            font-size: 14px;
            color: #f4212e;
            margin-bottom: 12px;
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

    <h2 class="auth-title">Sign in to EliteTweet</h2>

    <!-- Email -->
    <div class="tw-field">
        <asp:TextBox ID="txtUserEmail" runat="server"
            CssClass="tw-input"
            placeholder=" " />
        <label class="tw-label">Email or username</label>
    </div>

    <!-- Password -->
    <div class="tw-field">
        <asp:TextBox ID="txtPassword" runat="server"
            CssClass="tw-input"
            TextMode="Password"
            placeholder=" " />
        <label class="tw-label">Password</label>
    </div>

    <a href="#" class="forgot-link">Forgot password?</a>

    <!-- Error message -->
    <asp:Label ID="lblMessage" runat="server" CssClass="msg" />

    <!-- Sign In button -->
    <asp:Button ID="btn_SignIn" runat="server"
        Text="Sign in"
        CssClass="btn-blue"
        OnClick="Login_btn_Click" />

    <div class="divider">or</div>

    <div class="auth-footer">
        Don't have an account?
        <a href="RegistrationForm.aspx" class="auth-link">Sign up</a>
    </div>

</div>
</form>

<script>
    // Floating label — mark input as filled when it has a value
    document.querySelectorAll('.tw-input').forEach(function (inp) {
        function upd() { inp.classList.toggle('filled', inp.value.length > 0); }
        inp.addEventListener('input', upd);
        upd();
    });
</script>
</body>
</html>
