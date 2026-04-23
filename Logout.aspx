<%@ Page Language="VB" AutoEventWireup="false" %>
<script runat="server">
    Protected Sub Page_Load(sender As Object, e As EventArgs)
        AuthHelper.LogoutUser()
        Response.Redirect("~/Login.aspx")
    End Sub
</script>
<!DOCTYPE html>
<html>
<head><title>Logging out...</title></head>
<body></body>
</html>
