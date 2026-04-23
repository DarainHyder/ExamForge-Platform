Partial Class MasterPages_Main
    Inherits System.Web.UI.MasterPage

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        If AuthHelper.IsAuthenticated() Then
            divUser.Visible = True
            lblUsername.Text = AuthHelper.GetCurrentUsername()
            lblRole.Text = AuthHelper.GetCurrentUserRole()
        Else
            divUser.Visible = False
        End If
    End Sub

    Protected Sub btnLogout_Click(sender As Object, e As EventArgs)
        AuthHelper.LogoutUser()
        Response.Redirect("~/Login.aspx")
    End Sub
End Class


