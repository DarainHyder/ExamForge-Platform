Imports System.Data
Imports System.Data.SqlClient

Partial Class Teacher_ManageQuestions
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        AuthHelper.RequireRole("Teacher")

        If Not IsPostBack Then
            LoadFilters()
            LoadQuestions()
        End If
    End Sub

    Private Sub LoadFilters()
        Try
            Dim dt As DataTable = DBHelper.ExecuteReader("SELECT SubjectID, SubjectName FROM Subjects WHERE IsActive = 1")
            ddlFilterSubject.DataSource = dt
            ddlFilterSubject.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Private Sub LoadQuestions()
        Dim teacherID As Integer = AuthHelper.GetCurrentUserID()
        Dim subjectID As Integer = Convert.ToInt32(ddlFilterSubject.SelectedValue)
        Dim type As String = ddlFilterType.SelectedValue

        Dim query As String = "SELECT Q.QuestionID, Q.QuestionStatement, Q.QuestionType, Q.DifficultyLevel, Q.Marks, S.SubjectName " &
                              "FROM QuestionsTable Q INNER JOIN Subjects S ON Q.SubjectID = S.SubjectID " &
                              "WHERE Q.CreatedBy = @TeacherID AND Q.IsActive = 1"
        
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("@TeacherID", teacherID))

        If subjectID > 0 Then
            query &= " AND Q.SubjectID = @SubID"
            params.Add(New SqlParameter("@SubID", subjectID))
        End If

        If Not String.IsNullOrEmpty(type) Then
            query &= " AND Q.QuestionType = @Type"
            params.Add(New SqlParameter("@Type", type))
        End If

        query &= " ORDER BY Q.CreatedAt DESC"

        Try
            Dim dt As DataTable = DBHelper.ExecuteReader(query, params.ToArray())
            gvQuestions.DataSource = dt
            gvQuestions.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub Filter_Changed(sender As Object, e As EventArgs)
        LoadQuestions()
    End Sub

    Protected Sub btnAddNew_Click(sender As Object, e As EventArgs)
        Response.Redirect("AddQuestion.aspx")
    End Sub

    Protected Sub gvQuestions_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "DeleteQuestion" Then
            Dim qID As Integer = Convert.ToInt32(e.CommandArgument)
            Try
                DBHelper.ExecuteNonQuery("UPDATE QuestionsTable SET IsActive = 0 WHERE QuestionID = @ID", New SqlParameter("@ID", qID))
                LoadQuestions()
            Catch ex As Exception
            End Try
        End If
    End Sub
End Class


