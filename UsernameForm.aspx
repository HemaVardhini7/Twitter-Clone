<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="UsernameForm.aspx.cs" Inherits="EliteTweet.UsernameForm1" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Username Form</title>

    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

   
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet" />

    <style>

        body {
            background-color: black;
            min-height: 100vh;
        }

        .card-dark {
            background-color: #141414;
            color: #fff;
            border-radius: 16px;
            width: 420px;
        }

        .form-control {
            background-color: #000;
            border: 1px solid #333;
            color: #fff;
        }
        
        .btn-next {
            background-color: #fff;
            color: #000;
            font-weight: 600;
            border-radius: 25px;
        }

    </style>

</head>
<body>
    <form id="form1" runat="server">
        
        <div class="d-flex justify-content-center align-items-center vh-100">
            <div class="card card-dark p-4">

                <div class="text-center mb-3">
                    <i class="bi bi-x-lg fs-3"></i>
                </div>

                <h4 class="fw-bold mb-1">What should we call you?</h4>
                <p class="text-secondary small">
                    Your @username is unique. You can always change it later.
                </p>

              
                <div class="mb-4">
                    <label>Username</label>
                    <div class="input-group">
                        <%--<span class="input-group-text bg-black text-secondary border-secondary">@</span>--%>
                       
                        <asp:TextBox 
                            ID="txtUsername" 
                            runat="server" 
                            CssClass="form-control"
                            Placeholder="username">
                        </asp:TextBox>
                    </div>
                </div>

                <div class="mb-4">
                    <h4 class="fw-bold">You'll need a password</h4>
                    <p class="text-secondary">Make sure it's 8 characters or more.</p>
                    <label>Password</label>
                    <div class="input-group">
                        <%--<span class="input-group-text bg-black text-secondary border-secondary">@</span>--%>
                       
                        <asp:TextBox 
                            ID="txtPassword" 
                            runat="server" 
                            CssClass="form-control"
                            Placeholder="Password">
                        </asp:TextBox>
                    </div>
                </div>

                <div class="mb-3">
                    <label>Email</label>
                    <asp:TextBox ID="txtEmail" runat="server"
                        CssClass="form-control" Placeholder="Email" />
                    
                </div>



                <asp:Button 
                    ID="btn_SignUp" 
                    runat="server" 
                    Text="Sign Up" 
                    CssClass="btn w-100 py-2"
                    style="background-color:#fff;color:#000;border:none;box-shadow:none;" OnClick="SignUp_btn_click"/>

                <asp:Label ID="lblMessage" runat="server" CssClass="text-warning mt-3 d-block text-center" />
            </div>
        </div>

    </form>
</body>
</html>
