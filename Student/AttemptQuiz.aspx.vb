Imports System.Data
Imports System.Data.SqlClient

Partial Class Student_AttemptQuiz
    Inherits System.Web.UI.Page

    Private Property CurrentQuestionIndex As Integer
        Get
            Return If(ViewState("CurrentIndex") IsNot Nothing, Convert.ToInt32(ViewState("CurrentIndex")), 0)
        End Get
        Set(value As Integer)
            ViewState("CurrentIndex") = value
        End Set
    End Property

    Private Property QuestionsTable As DataTable
        Get
            Return CType(ViewState("Questions"), DataTable)
        End Get
        Set(value As DataTable)
            ViewState("Questions") = value
        End Set
    End Property

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        AuthHelper.RequireRole("Student")

        If Not IsPostBack Then
            If Session("ActiveQuizID") Is Nothing Then Response.Redirect("Dashboard.aspx")

            LoadQuizData()
        End If
    End Sub

    Private Sub LoadQuizData()
        Dim quizID As Integer = Convert.ToInt32(Session("ActiveQuizID"))
        
        Try
            ' Get Quiz Info
            Dim dtQuiz As DataTable = DBHelper.ExecuteReader("SELECT QuizTitle, AllowedTime, RandomizeQuestions FROM Quiz WHERE QuizID = @ID", New SqlParameter("@ID", quizID))
            If dtQuiz.Rows.Count > 0 Then
                lblQuizTitle.Text = dtQuiz.Rows(0)("QuizTitle").ToString()
                hfTimerMinutes.Value = dtQuiz.Rows(0)("AllowedTime").ToString()
                
                ' Get Questions
                QuestionsTable = DBHelper.ExecuteStoredProcedure("sp_GetQuizQuestions", 
                    New SqlParameter("@QuizID", quizID), 
                    New SqlParameter("@Randomize", dtQuiz.Rows(0)("RandomizeQuestions")))
                
                lblTotalCount.Text = QuestionsTable.Rows.Count.ToString()
                DisplayQuestion()
            End If
        Catch ex As Exception
            Response.Redirect("Dashboard.aspx")
        End Try
    End Sub

    Private Sub DisplayQuestion()
        If CurrentQuestionIndex >= QuestionsTable.Rows.Count Then
            ShowSubmitButton()
            Return
        End If

        Dim row As DataRow = QuestionsTable.Rows(CurrentQuestionIndex)
        lblCurrentNum.Text = (CurrentQuestionIndex + 1).ToString()
        lblQuestionText.Text = row("QuestionStatement").ToString()
        
        If Not IsDBNull(row("ImagePath")) Then
            imgQuestion.ImageUrl = "~/" & row("ImagePath").ToString()
            imgQuestion.Visible = True
        Else
            imgQuestion.Visible = False
        End If

        Dim type As String = row("QuestionType").ToString()
        pnlMCQ.Visible = (type = "MCQ")
        pnlMulti.Visible = (type = "MultiSelect")
        pnlPara.Visible = (type = "Paragraph")

        If type = "MCQ" Then
            lblA.Text = row("OptionA").ToString()
            lblB.Text = row("OptionB").ToString()
            lblC.Text = row("OptionC").ToString()
            lblD.Text = row("OptionD").ToString()
            rbA.Checked = False : rbB.Checked = False : rbC.Checked = False : rbD.Checked = False
        ElseIf type = "MultiSelect" Then
            lblMA.Text = row("OptionA").ToString()
            lblMB.Text = row("OptionB").ToString()
            lblMC.Text = row("OptionC").ToString()
            lblMD.Text = row("OptionD").ToString()
            cbA.Checked = False : cbB.Checked = False : cbC.Checked = False : cbD.Checked = False
        Else
            txtAnswer.Text = ""
        End If

        If CurrentQuestionIndex = QuestionsTable.Rows.Count - 1 Then
            btnNext.Text = "Review & Submit"
        End If
    End Sub

    Protected Sub btnNext_Click(sender As Object, e As EventArgs)
        SaveCurrentAnswer()
        CurrentQuestionIndex += 1
        
        If CurrentQuestionIndex < QuestionsTable.Rows.Count Then
            DisplayQuestion()
        Else
            ShowSubmitButton()
        End If
    End Sub

    Private Sub SaveCurrentAnswer()
        Dim quizID As Integer = Convert.ToInt32(Session("ActiveQuizID"))
        Dim studentID As Integer = AuthHelper.GetCurrentUserID()
        Dim qRow As DataRow = QuestionsTable.Rows(CurrentQuestionIndex)
        Dim qID As Integer = Convert.ToInt32(qRow("QuestionID"))
        Dim type As String = qRow("QuestionType").ToString()
        
        Dim studentAns As String = ""
        Dim isCorrect As Boolean = False
        Dim marks As Decimal = 0

        If type = "MCQ" Then
            If rbA.Checked Then 
                studentAns = "A"
            ElseIf rbB.Checked Then 
                studentAns = "B"
            ElseIf rbC.Checked Then 
                studentAns = "C"
            ElseIf rbD.Checked Then 
                studentAns = "D"
            End If
            isCorrect = (studentAns = qRow("CorrectOption").ToString())
        ElseIf type = "MultiSelect" Then
            Dim answers As New List(Of String)
            If cbA.Checked Then answers.Add("A")
            If cbB.Checked Then answers.Add("B")
            If cbC.Checked Then answers.Add("C")
            If cbD.Checked Then answers.Add("D")
            studentAns = String.Join(",", answers)
            isCorrect = (studentAns = qRow("CorrectOption").ToString())
        Else
            studentAns = txtAnswer.Text.Trim()
            ' Manual grading or placeholder check for paragraph
            isCorrect = False 
        End If

        If isCorrect Then marks = Convert.ToDecimal(qRow("Marks"))

        ' Insert answer
        Dim cmd As String = "INSERT INTO Answers (StudentID, QuizID, QuestionID, QuestionNumber, CorrectAnswer, StudentAnswer, MarksAwarded, IsCorrect) " &
                           "VALUES (@SID, @QID, @QueID, @Num, @Corr, @Stu, @Marks, @IsCorr)"
        
        Dim params As SqlParameter() = {
            New SqlParameter("@SID", studentID),
            New SqlParameter("@QID", quizID),
            New SqlParameter("@QueID", qID),
            New SqlParameter("@Num", CurrentQuestionIndex + 1),
            New SqlParameter("@Corr", If(type = "Paragraph", qRow("CorrectAnswer"), qRow("CorrectOption"))),
            New SqlParameter("@Stu", studentAns),
            New SqlParameter("@Marks", marks),
            New SqlParameter("@IsCorr", isCorrect)
        }
        
        DBHelper.ExecuteNonQuery(cmd, params)
    End Sub

    Private Sub ShowSubmitButton()
        pnlQuestion.Visible = False
        btnNext.Visible = False
        btnSubmitQuiz.Style("display") = "block"
        lblQuestionText.Text = "You have reached the end of the quiz. Click the button below to finalize your submission."
    End Sub

    Protected Sub btnSubmitQuiz_Click(sender As Object, e As EventArgs)
        Dim studentID As Integer = AuthHelper.GetCurrentUserID()
        Dim quizID As Integer = Convert.ToInt32(Session("ActiveQuizID"))
        
        Try
            DBHelper.ExecuteStoredProcedure("sp_CalculateResult", 
                New SqlParameter("@StudentID", studentID), 
                New SqlParameter("@QuizID", quizID))
            
            Session("LastQuizID") = quizID
            Response.Redirect("MyResults.aspx")
        Catch ex As Exception
        End Try
    End Sub
End Class


