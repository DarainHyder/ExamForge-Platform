Imports System.Data
Imports System.Data.SqlClient

Partial Class Student_Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        AuthHelper.RequireRole("Student")

        If Not IsPostBack Then
            LoadQuizzes()
            LoadNotifications()
        End If
    End Sub

    Private Sub LoadQuizzes()
        Dim studentID As Integer = AuthHelper.GetCurrentUserID()
        Try
            Dim dt As DataTable = DBHelper.ExecuteStoredProcedure("sp_GetAvailableQuizzes", New SqlParameter("@StudentID", studentID))
            gvQuizzes.DataSource = dt
            gvQuizzes.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Private Sub LoadNotifications()
        Dim studentID As Integer = AuthHelper.GetCurrentUserID()
        Try
            Dim query As String = "SELECT Message FROM Notifications WHERE ToUserID = @SID ORDER BY CreatedAt DESC"
            Dim dt As DataTable = DBHelper.ExecuteReader(query, New SqlParameter("@SID", studentID))
            rptNotifications.DataSource = dt
            rptNotifications.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub gvQuizzes_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "StartQuiz" Then
            Dim quizID As Integer = Convert.ToInt32(e.CommandArgument)
            Session("ActiveQuizID") = quizID
            Response.Redirect("AttemptQuiz.aspx")
        End If
    End Sub
End Class


