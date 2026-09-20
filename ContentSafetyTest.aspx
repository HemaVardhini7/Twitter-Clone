<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ContentSafetyTest.aspx.cs" Async="true" Inherits="EliteTweet.ContentSafetyTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Content Safety Test</title>
</head>
<body>
    <form id="form1" runat="server">
        <div>
            <h2>Gemini Content Safety Test</h2>

        <asp:TextBox
            ID="txtContent"
            runat="server"
            TextMode="MultiLine"
            Rows="5"
            Columns="60">
        </asp:TextBox>

        <br /><br />

        <asp:Button
            ID="btnCheck"
            runat="server"
            Text="Check Content"
            OnClick="btnCheck_Click" />

        <br /><br />

        <asp:Label
            ID="lblResult"
            runat="server">
        </asp:Label>
        </div>
    </form>
</body>
</html>
