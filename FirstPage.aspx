<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="FirstPage.aspx.cs" Inherits="EliteTweet.FirstPage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>X - First Page</title>


<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />

<style>
    body {
        background-color: black;
        color: white;
    }

    .x-logo {
        font-size: 200px;
        font-weight: bold;
        color: white;
    }

    .btn-simple {
        border-radius: 30px;
        font-weight: 600;
    }
</style>
</head>
<body>
    <form id="form1" runat="server">
      
        <div class="container-fluid vh-100">
            <div class="row h-100 align-items-center">

        
                <div class="col-md-6 text-center">
                    <div class="x-logo">X</div>
                </div>

           
                <div class="col-md-6">
                    <h1 class="fw-bold">Happening now</h1>
                    <h4 class="mb-4">Join today.</h4>

                    <div class="d-grid gap-3 col-8">

                        <asp:Button 
                            ID="btnGoogle" 
                            runat="server" 
                            Text="Sign up with Google" 
                            CssClass="btn btn-light btn-simple" />

                        <asp:Button 
                            ID="btnApple" 
                            runat="server" 
                            Text="Sign up with Apple" 
                            CssClass="btn btn-light btn-simple" />

                        <hr class="text-secondary" />

                        <asp:Button 
                            ID="btnCreate" 
                            runat="server" 
                            Text="Create account" 
                            CssClass="btn btn-light btn-simple" OnClick="CreateAccount_Btn_Click" />

                        <p class="mt-4">Already have an account?</p>

                        <asp:Button 
                            ID="btnSignIn" 
                            runat="server" 
                            Text="Sign in" 
                            CssClass="btn btn-outline-light btn-simple" OnClick="SignIn_btn_click" />
                    </div>
                </div>

            </div>
        </div>

    </form>
</body>
</html>
