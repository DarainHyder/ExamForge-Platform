Imports System.Data
Imports System.Data.SqlClient

Partial Class Admin_Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        AuthHelper.RequireRole("Admin")

        If Not IsPostBack Then
            LoadStats()
            LoadLogs()
        End If
    End Sub

    Private Sub LoadStats()
        Try
            lblTotalUsers.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Users WHERE IsActive = 1").ToString()
            lblTotalSubjects.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Subjects WHERE IsActive = 1").ToString()
            lblTotalResults.Text = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Results").ToString()
        Catch ex As Exception
        End Try
    End Sub

    Private Sub LoadLogs()
        ' For demo, we just show recently created users as logs
        Try
            Dim query As String = "SELECT TOP 10 Username, Role, CreatedAt FROM Users ORDER BY CreatedAt DESC"
            Dim dt As DataTable = DBHelper.ExecuteReader(query)
            gvSystemLogs.DataSource = dt
            gvSystemLogs.DataBind()
        Catch ex As Exception
        End Try
    End Sub
End Class


