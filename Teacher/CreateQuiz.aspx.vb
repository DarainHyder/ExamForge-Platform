Imports System.Data
Imports System.Data.SqlClient

Partial Class Teacher_CreateQuiz
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        AuthHelper.RequireRole("Teacher")

        If Not IsPostBack Then
            LoadSubjects()
            ' Default times
            txtStart.Text = DateTime.Now.ToString("yyyy-MM-ddTHH:mm")
            txtEnd.Text = DateTime.Now.AddHours(24).ToString("yyyy-MM-ddTHH:mm")
        End If
    End Sub

    Private Sub LoadSubjects()
        Try
            Dim dt As DataTable = DBHelper.ExecuteReader("SELECT SubjectID, SubjectName FROM Subjects WHERE IsActive = 1")
            ddlSubject.DataSource = dt
            ddlSubject.DataBind()
            LoadSubjectQuestions()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub ddlSubject_SelectedIndexChanged(sender As Object, e As EventArgs)
        LoadSubjectQuestions()
    End Sub

    Private Sub LoadSubjectQuestions()
        Dim subjectID As Integer = Convert.ToInt32(ddlSubject.SelectedValue)
        Dim teacherID As Integer = AuthHelper.GetCurrentUserID()
        
        Dim query As String = "SELECT QuestionID, QuestionStatement, DifficultyLevel, Marks FROM QuestionsTable " &
                              "WHERE SubjectID = @SubID AND CreatedBy = @TeacherID AND IsActive = 1"
        
        Try
            Dim dt As DataTable = DBHelper.ExecuteReader(query, New SqlParameter("@SubID", subjectID), New SqlParameter("@TeacherID", teacherID))
            gvQuestions.DataSource = dt
            gvQuestions.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub btnCreate_Click(sender As Object, e As EventArgs)
        SaveQuiz(True)
    End Sub

    Protected Sub btnPreview_Click(sender As Object, e As EventArgs)
        SaveQuiz(False) ' Create in test mode
    End Sub

    Private Sub SaveQuiz(publish As Boolean)
        Dim teacherID As Integer = AuthHelper.GetCurrentUserID()
        Dim title As String = txtTitle.Text.Trim()
        Dim subjectID As Integer = Convert.ToInt32(ddlSubject.SelectedValue)
        Dim duration As Integer = Convert.ToInt32(txtDuration.Text)
        Dim startTime As DateTime = DateTime.Parse(txtStart.Text)
        Dim endTime As DateTime = DateTime.Parse(txtEnd.Text)
        
        Dim selectedQuestions As New List(Of Integer)
        Dim totalMarks As Decimal = 0

        For Each row As GridViewRow In gvQuestions.Rows
            Dim chk As CheckBox = CType(row.FindControl("chkSelect"), CheckBox)
            If chk.Checked Then
                Dim qID As Integer = Convert.ToInt32(CType(row.FindControl("hfID"), HiddenField).Value)
                selectedQuestions.Add(qID)
                totalMarks += Convert.ToDecimal(row.Cells(3).Text)
            End If
        Next

        If selectedQuestions.Count = 0 Then
            ShowError("Please select at least one question.")
            Return
        End If

        ' Insert Quiz
        Dim query As String = "INSERT INTO Quiz (QuizTitle, SubjectID, StartTime, EndTime, AllowedTime, TotalQuestions, TotalMarks, RandomizeQuestions, ShuffleOptions, NegativeMarking, NegativeMarks, IsPublished, IsTestMode, CreatedBy) " &
                              "OUTPUT INSERTED.QuizID " &
                              "VALUES (@Title, @SubID, @Start, @End, @Duration, @Count, @Total, @Rand, @Shuf, @Neg, @NegMarks, @Pub, @Test, @TeacherID)"
        
        Dim params As SqlParameter() = {
            New SqlParameter("@Title", title),
            New SqlParameter("@SubID", subjectID),
            New SqlParameter("@Start", startTime),
            New SqlParameter("@End", endTime),
            New SqlParameter("@Duration", duration),
            New SqlParameter("@Count", selectedQuestions.Count),
            New SqlParameter("@Total", totalMarks),
            New SqlParameter("@Rand", chkRandomize.Checked),
            New SqlParameter("@Shuf", chkShuffle.Checked),
            New SqlParameter("@Neg", chkNegative.Checked),
            New SqlParameter("@NegMarks", If(chkNegative.Checked, Convert.ToDecimal(txtNegative.Text), 0)),
            New SqlParameter("@Pub", publish),
            New SqlParameter("@Test", Not publish),
            New SqlParameter("@TeacherID", teacherID)
        }

        Try
            Dim quizID As Integer = Convert.ToInt32(DBHelper.ExecuteScalar(query, params))

            ' Insert QuizQuestions Mapping
            For i As Integer = 0 To selectedQuestions.Count - 1
                DBHelper.ExecuteNonQuery("INSERT INTO QuizQuestions (QuizID, QuestionID, DisplayOrder) VALUES (@QID, @QueID, @Order)",
                    New SqlParameter("@QID", quizID),
                    New SqlParameter("@QueID", selectedQuestions(i)),
                    New SqlParameter("@Order", i + 1))
            Next

            lblMessage.Text = If(publish, "Quiz published successfully!", "Quiz created in test mode!")
            pnlMessage.Visible = True
        Catch ex As Exception
            ShowError("Error: " & ex.Message)
        End Try
    End Sub

    Private Sub ShowError(msg As String)
        lblMessage.Text = msg
        pnlMessage.CssClass = "alert alert-danger"
        pnlMessage.Visible = True
    End Sub
End Class


