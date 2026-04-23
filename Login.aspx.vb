Imports System.Data
Imports System.Data.SqlClient

Partial Class Login
    Inherits System.Web.UI.Page

    Protected Sub btnLogin_Click(sender As Object, e As EventArgs)
        Dim username As String = txtUsername.Text.Trim()
        Dim password As String = txtPassword.Text.Trim()

        If String.IsNullOrEmpty(username) OrElse String.IsNullOrEmpty(password) Then
            ShowError("Please enter both username and password.")
            Return
        End If

        Try
            Dim hashedPassword As String = DBHelper.HashPassword(password)
            Dim query As String = "SELECT UserID, FullName, Role, IsActive FROM Users WHERE Username = @Username AND PasswordHash = @Password"
            Dim params As SqlParameter() = {
                New SqlParameter("@Username", username),
                New SqlParameter("@Password", hashedPassword)
            }

            Dim dt As DataTable = DBHelper.ExecuteReader(query, params)

            If dt.Rows.Count > 0 Then
                Dim row As DataRow = dt.Rows(0)
                Dim isActive As Boolean = Convert.ToBoolean(row("IsActive"))

                If Not isActive Then
                    ShowError("Your account is deactivated. Contact administrator.")
                    Return
                End If

                Dim userID As Integer = Convert.ToInt32(row("UserID"))
                Dim role As String = row("Role").ToString()

                AuthHelper.LoginUser(userID, username, role)
                AuthHelper.RedirectByRole()
            Else
                ShowError("Invalid username or password!")
            End If
        Catch ex As Exception
            ShowError("An error occurred during login. Please ensure the database is running and the connection string in Web.config is correct.")
        End Try
    End Sub

    Private Sub ShowError(message As String)
        lblError.Text = message
        pnlError.Visible = True
    End Sub
End Class

