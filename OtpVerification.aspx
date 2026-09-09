<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OtpVerification.aspx.cs" Inherits="EliteTweet.OtpVerification" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Verify your email</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: black;
        }
        .card {
            background-color: #141414;
            color: white;
            border-radius: 15px;
        }
        label {
            color: white;
        }
        .otp-input {
            letter-spacing: 8px;
            font-size: 1.4rem;
            text-align: center;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="container d-flex justify-content-center align-items-center vh-100">
            <div class="col-md-4">
                <div class="card p-4 shadow">

                    <h4 class="text-center mb-2">Verify your email</h4>
                    <asp:Label ID="lblInfo" runat="server" CssClass="small d-block text-center mb-3" />

                    <div class="mb-3">
                        <label>6-digit code</label>
                        <asp:TextBox ID="txtOtp" runat="server"
                            CssClass="form-control bg-dark text-white otp-input"
                            MaxLength="6" placeholder="000000" />
                    </div>

                    <asp:Button ID="btnVerify" runat="server"
                        Text="Verify"
                        CssClass="btn btn-primary w-100 mb-2" OnClick="btnVerify_Click" />

                    <asp:Button ID="btnResend" runat="server"
                        Text="Resend code"
                        CssClass="btn btn-outline-light w-100" OnClick="btnResend_Click" />

                    <asp:Label ID="lblMessage" runat="server" CssClass="text-warning mt-3 d-block text-center" />

                </div>
            </div>
        </div>
    </form>
</body>
</html>
