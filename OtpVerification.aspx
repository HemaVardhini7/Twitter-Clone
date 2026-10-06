<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OtpVerification.aspx.cs" Inherits="EliteTweet.OtpVerification" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Verify your email / EliteTweet</title>
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
            margin-bottom: 8px;
            line-height: 1.2;
        }

        .auth-info {
            display: block;
            font-size: 15px;
            color: #71767b;
            margin-bottom: 28px;
            line-height: 1.5;
        }

        /* ── OTP input ── */
        .otp-field { margin-bottom: 24px; }

        .otp-field-label {
            display: block;
            font-size: 13px;
            color: #71767b;
            margin-bottom: 8px;
            letter-spacing: 0.02em;
        }

        .otp-input {
            display: block;
            width: 100%;
            background: transparent;
            border: 1px solid #333639;
            border-radius: 4px;
            color: #e7e9ea;
            font-size: 30px;
            font-weight: 700;
            letter-spacing: 20px;
            text-align: center;
            padding: 16px 8px;
            outline: none;
            transition: border-color 0.2s;
            font-family: 'Courier New', Courier, monospace;
        }
        .otp-input:focus { border-color: #1d9bf0; }
        .otp-input::placeholder {
            color: #333639;
            letter-spacing: 10px;
            font-size: 22px;
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
            margin-bottom: 12px;
            transition: background 0.2s;
            text-align: center;
        }
        .btn-blue:hover { background: #1a8cd8; }

        .btn-outline {
            display: block;
            width: 100%;
            background: transparent;
            color: #e7e9ea;
            border: 1px solid #536471;
            border-radius: 9999px;
            font-size: 17px;
            font-weight: 700;
            padding: 14px;
            cursor: pointer;
            transition: background 0.2s;
            text-align: center;
        }
        .btn-outline:hover { background: rgba(255,255,255,0.08); }

        /* ── Message ── */
        .msg {
            display: block;
            text-align: center;
            font-size: 14px;
            margin-top: 14px;
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

    <h2 class="auth-title">We sent you a code</h2>
    <asp:Label ID="lblInfo" runat="server" CssClass="auth-info" />

    <!-- OTP input -->
    <div class="otp-field">
        <span class="otp-field-label">6-digit verification code</span>
        <asp:TextBox ID="txtOtp" runat="server"
            CssClass="otp-input"
            MaxLength="6"
            placeholder="000000" />
    </div>

    <!-- Verify -->
    <asp:Button ID="btnVerify" runat="server"
        Text="Verify"
        CssClass="btn-blue"
        OnClick="btnVerify_Click" />

    <!-- Resend -->
    <asp:Button ID="btnResend" runat="server"
        Text="Resend code"
        CssClass="btn-outline"
        OnClick="btnResend_Click" />

    <asp:Label ID="lblMessage" runat="server" CssClass="msg" />

</div>
</form>
</body>
</html>
