Imports System.Data
Imports System.Data.SqlClient

Partial Class Admin_ManageSubjects
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        AuthHelper.RequireRole("Admin")

        If Not IsPostBack Then
            LoadSubjects()
        End If
    End Sub

    Private Sub LoadSubjects()
        Try
            Dim dt As DataTable = DBHelper.ExecuteReader("SELECT SubjectID, SubjectName, Description FROM Subjects WHERE IsActive = 1")
            gvSubjects.DataSource = dt
            gvSubjects.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub btnAdd_Click(sender As Object, e As EventArgs)
        Dim name As String = txtSubjectName.Text.Trim()
        Dim desc As String = txtDescription.Text.Trim()

        If String.IsNullOrEmpty(name) Then
            ShowError("Subject name is required.")
            Return
        End If

        Try
            DBHelper.ExecuteNonQuery("INSERT INTO Subjects (SubjectName, Description) VALUES (@Name, @Desc)",
                New SqlParameter("@Name", name),
                New SqlParameter("@Desc", desc))
            
            lblMessage.Text = "Subject added successfully!"
            pnlMessage.Visible = True
            txtSubjectName.Text = ""
            txtDescription.Text = ""
            LoadSubjects()
        Catch ex As Exception
            ShowError("Error: " & ex.Message)
        End Try
    End Sub

    Protected Sub gvSubjects_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "DeleteSubject" Then
            Dim id As Integer = Convert.ToInt32(e.CommandArgument)
            Try
                DBHelper.ExecuteNonQuery("UPDATE Subjects SET IsActive = 0 WHERE SubjectID = @ID", New SqlParameter("@ID", id))
                LoadSubjects()
            Catch ex As Exception
            End Try
        End If
    End Sub

    Private Sub ShowError(msg As String)
        lblMessage.Text = msg
        pnlMessage.CssClass = "alert alert-danger"
        pnlMessage.Visible = True
    End Sub
End Class


