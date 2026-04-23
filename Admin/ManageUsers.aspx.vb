Imports System.Data
Imports System.Data.SqlClient

Partial Class Admin_ManageUsers
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        AuthHelper.RequireRole("Admin")

        If Not IsPostBack Then
            LoadUsers()
        End If
    End Sub

    Private Sub LoadUsers()
        Dim role As String = ddlRoleFilter.SelectedValue
        Dim query As String = "SELECT UserID, Username, FullName, Role, Email, IsActive FROM Users"
        Dim params As New List(Of SqlParameter)

        If Not String.IsNullOrEmpty(role) Then
            query &= " WHERE Role = @Role"
            params.Add(New SqlParameter("@Role", role))
        End If

        Try
            Dim dt As DataTable = DBHelper.ExecuteReader(query, params.ToArray())
            gvUsers.DataSource = dt
            gvUsers.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub ddlRoleFilter_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadUsers()
    End Sub

    Protected Sub gvUsers_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "ToggleStatus" Then
            Dim userID As Integer = Convert.ToInt32(e.CommandArgument)
            Try
                DBHelper.ExecuteNonQuery("UPDATE Users SET IsActive = CASE WHEN IsActive = 1 THEN 0 ELSE 1 END WHERE UserID = @ID", 
                    New SqlParameter("@ID", userID))
                LoadUsers()
            Catch ex As Exception
            End Try
        End If
    End Sub
End Class


