Imports System.Data
Imports System.Data.SqlClient

Partial Class Teacher_ViewResults
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        AuthHelper.RequireRole("Teacher")

        If Not IsPostBack Then
            LoadQuizzes()
            LoadResults()
        End If
    End Sub

    Private Sub LoadQuizzes()
        Dim teacherID As Integer = AuthHelper.GetCurrentUserID()
        Try
            Dim dt As DataTable = DBHelper.ExecuteReader("SELECT QuizID, QuizTitle FROM Quiz WHERE CreatedBy = @ID", New SqlParameter("@ID", teacherID))
            ddlQuizFilter.DataSource = dt
            ddlQuizFilter.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Private Sub LoadResults()
        Dim teacherID As Integer = AuthHelper.GetCurrentUserID()
        Dim quizID As Integer = Convert.ToInt32(ddlQuizFilter.SelectedValue)
        
        Dim query As String = "SELECT U.FullName, Q.QuizTitle, R.AttemptDate, R.TotalMarks, R.ObtainedMarks, R.Percentage " &
                              "FROM Results R " &
                              "INNER JOIN Users U ON R.StudentID = U.UserID " &
                              "INNER JOIN Quiz Q ON R.QuizID = Q.QuizID " &
                              "WHERE Q.CreatedBy = @TeacherID"
        
        Dim params As New List(Of SqlParameter)
        params.Add(New SqlParameter("@TeacherID", teacherID))

        If quizID > 0 Then
            query &= " AND R.QuizID = @QID"
            params.Add(New SqlParameter("@QID", quizID))
        End If

        query &= " ORDER BY R.AttemptDate DESC"

        Try
            Dim dt As DataTable = DBHelper.ExecuteReader(query, params.ToArray())
            gvResults.DataSource = dt
            gvResults.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub ddlQuizFilter_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadResults()
    End Sub
End Class


