<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="LoginForm.aspx.cs" Inherits="EliteTweet.LoginForm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Sign in to TwitterClone</title>
    
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous" />

    <style>
      
        body {
            background-color: black;
        }


        .signin-card {
            background-color: #141414;
            color: #fff;
            border-radius: 15px;
        }

        .signin-card label,
        .signin-card .form-label {
            color: #8899a6;
        }

        .signin-card .btn-google,
        .signin-card .btn-apple {
            text-align: left;
        }

        
        .divider-text {
            color: #8899a6;
            font-size: 0.9rem;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        
        <div class="container d-flex justify-content-center align-items-center min-vh-100">
            <div class="card signin-card p-4 shadow" style="max-width: 380px; width: 100%;">

         
                <h4 class="text-center mb-4">Sign in to X</h4>

                <%--<div class="mb-3">
                    <button type="button" class="btn btn-light btn-google w-100 mb-2 d-flex align-items-center justify-content-center">
                    
                        <span class="me-2">
                            <img src="google-logo.png" alt="Google" width="20" height="20" class="object-fit-fill" />
                        </span>
                        Sign in with Google
                    </button>
                </div>

               
                <div class="mb-3">
                    <button type="button" class="btn btn-light btn-apple w-100 d-flex align-items-center justify-content-center">
                        <span class="me-2">
                            <img src="apple-logo.png" alt="Apple" width="20" height="20" />
                        </span>
                        Sign in with Apple
                    </button>
                </div>--%>

            

                <div class="mb-3">
                    <label>Email</label>
                    <asp:TextBox ID="txtUserEmail" runat="server"
                        CssClass="form-control"
                        placeholder="Phone, email, or username" />
                </div>

                <div class="mb-4">
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


                <div class="d-grid mb-2">
                    <asp:Button ID="btn_SignIn" runat="server"
                        Text="Sign In"
                        CssClass="btn btn-primary" OnClick="Login_btn_Click" />
                </div>

                <asp:Label ID="lblMessage" runat="server" CssClass="text-warning d-block text-center mb-2" />

            
                <div class="text-center">
                    <a href="#" class="text-white small">Forgot password?</a>
                </div>

                <div class="text-center mt-3 small">
                    Don’t have an account? <a href="RegistrationForm.aspx" class="text-white">Sign up</a>
                </div>

            </div>
        </div>
    </form>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
            crossorigin="anonymous"></script>

</body>
</html>
