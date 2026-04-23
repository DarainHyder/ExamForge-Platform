Imports System.Data
Imports System.Data.SqlClient

Partial Class Teacher_Dashboard
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        AuthHelper.RequireRole("Teacher")

        If Not IsPostBack Then
            LoadDashboardStats()
            LoadRecentQuizzes()
            LoadNotifications()
        End If
    End Sub

    Private Sub LoadDashboardStats()
        Dim teacherID As Integer = AuthHelper.GetCurrentUserID()

        Try
            ' Total Questions
            Dim qCount As Object = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM QuestionsTable WHERE CreatedBy = @TeacherID AND IsActive = 1",
                New SqlParameter("@TeacherID", teacherID))
            lblTotalQuestions.Text = If(qCount IsNot Nothing, qCount.ToString(), "0")

            ' Total Quizzes
            Dim quizCount As Object = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Quiz WHERE CreatedBy = @TeacherID",
                New SqlParameter("@TeacherID", teacherID))
            lblTotalQuizzes.Text = If(quizCount IsNot Nothing, quizCount.ToString(), "0")

            ' Published Quizzes
            Dim pubCount As Object = DBHelper.ExecuteScalar("SELECT COUNT(*) FROM Quiz WHERE CreatedBy = @TeacherID AND IsPublished = 1",
                New SqlParameter("@TeacherID", teacherID))
            lblPublishedQuizzes.Text = If(pubCount IsNot Nothing, pubCount.ToString(), "0")

            ' Total Attempts
            Dim attemptCount As Object = DBHelper.ExecuteScalar(
                "SELECT COUNT(*) FROM Results R INNER JOIN Quiz Q ON R.QuizID = Q.QuizID WHERE Q.CreatedBy = @TeacherID",
                New SqlParameter("@TeacherID", teacherID))
            lblTotalAttempts.Text = If(attemptCount IsNot Nothing, attemptCount.ToString(), "0")
        Catch ex As Exception
            ' Log error or show silent failure for stats
        End Try
    End Sub

    Private Sub LoadRecentQuizzes()
        Dim teacherID As Integer = AuthHelper.GetCurrentUserID()
        Dim query As String = "SELECT TOP 5 Q.QuizTitle, S.SubjectName, Q.TotalQuestions, Q.CreatedAt, Q.IsPublished " &
                              "FROM Quiz Q INNER JOIN Subjects S ON Q.SubjectID = S.SubjectID " &
                              "WHERE Q.CreatedBy = @TeacherID ORDER BY Q.CreatedAt DESC"

        Try
            Dim dt As DataTable = DBHelper.ExecuteReader(query, New SqlParameter("@TeacherID", teacherID))
            gvRecentQuizzes.DataSource = dt
            gvRecentQuizzes.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Private Sub LoadNotifications()
        Dim teacherID As Integer = AuthHelper.GetCurrentUserID()
        Dim query As String = "SELECT TOP 5 Message, CreatedAt FROM Notifications WHERE ToUserID = @TeacherID ORDER BY CreatedAt DESC"

        Try
            Dim dt As DataTable = DBHelper.ExecuteReader(query, New SqlParameter("@TeacherID", teacherID))
            rptNotifications.DataSource = dt
            rptNotifications.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub btnAddQuestion_Click(sender As Object, e As EventArgs)
        Response.Redirect("AddQuestion.aspx")
    End Sub

    Protected Sub btnManageQuestions_Click(sender As Object, e As EventArgs)
        Response.Redirect("ManageQuestions.aspx")
    End Sub

    Protected Sub btnCreateQuiz_Click(sender As Object, e As EventArgs)
        Response.Redirect("CreateQuiz.aspx")
    End Sub

    Protected Sub btnViewResults_Click(sender As Object, e As EventArgs)
        Response.Redirect("ViewResults.aspx")
    End Sub
End Class


