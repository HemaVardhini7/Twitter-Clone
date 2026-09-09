<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="RegistrationForm.aspx.cs" Inherits="EliteTweet.RegistrationForm" 
    UnobtrusiveValidationMode="None"%>

<!DOCTYPE html>
<html>
<head runat="server">
    <title>Sign up for TwitterClone</title>

   
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>
        body {
            background-color: black;
            color: white;
        }
        .card {
            background-color: #141414;
            color: white;
            border-radius: 15px;
        }
        label {
            color: #8899a6;
        }
    </style>
</head>
<body>

<form id="form1" runat="server">

<div class="container d-flex justify-content-center align-items-center vh-100">
    <div class="col-md-4">

        <div class="card p-4 shadow">

            <h4 class="text-center mb-4">Create your account</h4>

            <div class="mb-3">
                <label>Name</label>
                <asp:TextBox ID="txtName" runat="server"
                    CssClass="form-control bg-dark text-white"
                    MaxLength="50" />
                
            </div>

            
            <div class="mb-3">
                <label>Email</label>
                <asp:TextBox ID="txtEmail" runat="server"
                    CssClass="form-control bg-dark text-white" />
               
            </div>

            <label>Date of birth</label>
            <p class="small text-muted">
                This will not be shown publicly.
            </p>

            <div class="row mb-3">
                <div class="col">
                    <asp:DropDownList ID="ddlMonth" runat="server" CssClass="form-select bg-dark text-white">
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
                </div>

                <div class="col">
                    <asp:DropDownList ID="ddlDay" runat="server" CssClass="form-select bg-dark text-white" />
                </div>

                <div class="col">
                    <asp:DropDownList ID="ddlYear" runat="server" CssClass="form-select bg-dark text-white" />
                </div>
            </div>

            <asp:Button ID="btnNext" runat="server"
                Text="Next"
                CssClass="btn btn-secondary w-100" OnClick="Btn_Next_Click" />

            <asp:Label ID="lblMessage" runat="server" CssClass="text-success mt-3 d-block" />

        </div>
    </div>
</div>

</form>

</body>
</html>
