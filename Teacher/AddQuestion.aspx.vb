Imports System.Data
Imports System.Data.SqlClient
Imports System.IO

Partial Class Teacher_AddQuestion
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        AuthHelper.RequireRole("Teacher")

        If Not IsPostBack Then
            LoadSubjects()
        End If
    End Sub

    Private Sub LoadSubjects()
        Try
            Dim dt As DataTable = DBHelper.ExecuteReader("SELECT SubjectID, SubjectName FROM Subjects WHERE IsActive = 1")
            ddlSubject.DataSource = dt
            ddlSubject.DataBind()
        Catch ex As Exception
        End Try
    End Sub

    Protected Sub ddlType_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim type As String = ddlType.SelectedValue
        pnlOptions.Visible = (type <> "Paragraph")
        divCorrectMCQ.Visible = (type = "MCQ")
        divCorrectMulti.Visible = (type = "MultiSelect")
        divCorrectPara.Visible = (type = "Paragraph")
    End Sub

    Protected Sub btnSave_Click(sender As Object, e As EventArgs)
        Dim teacherID As Integer = AuthHelper.GetCurrentUserID()
        Dim subjectID As Integer = Convert.ToInt32(ddlSubject.SelectedValue)
        Dim statement As String = txtStatement.Text.Trim()
        Dim type As String = ddlType.SelectedValue
        Dim difficulty As String = ddlDifficulty.SelectedValue
        Dim marks As Decimal = Convert.ToDecimal(txtMarks.Text)

        Dim optionA As String = txtOptionA.Text.Trim()
        Dim optionB As String = txtOptionB.Text.Trim()
        Dim optionC As String = txtOptionC.Text.Trim()
        Dim optionD As String = txtOptionD.Text.Trim()

        Dim correctOption As String = ""
        Dim correctAnswer As String = ""

        Select Case type
            Case "MCQ"
                correctOption = ddlCorrectOption.SelectedValue
            Case "MultiSelect"
                correctOption = txtCorrectMulti.Text.Trim()
            Case "Paragraph"
                correctAnswer = txtCorrectPara.Text.Trim()
        End Select

        Dim imagePath As String = ""
        If fuImage.HasFile Then
            Try
                Dim fileName As String = Guid.NewGuid().ToString() & Path.GetExtension(fuImage.FileName)
                Dim folderPath As String = Server.MapPath("~/Images/questions/")
                If Not Directory.Exists(folderPath) Then Directory.CreateDirectory(folderPath)
                fuImage.SaveAs(folderPath & fileName)
                imagePath = "Images/questions/" & fileName
            Catch ex As Exception
            End Try
        End If

        Dim query As String = "INSERT INTO QuestionsTable (SubjectID, QuestionStatement, QuestionType, OptionA, OptionB, OptionC, OptionD, CorrectOption, CorrectAnswer, DifficultyLevel, Marks, ImagePath, CreatedBy) " &
                              "VALUES (@SubjectID, @Statement, @Type, @A, @B, @C, @D, @CorrectOpt, @CorrectAns, @Difficulty, @Marks, @Img, @TeacherID)"

        Dim params As SqlParameter() = {
            New SqlParameter("@SubjectID", subjectID),
            New SqlParameter("@Statement", statement),
            New SqlParameter("@Type", type),
            New SqlParameter("@A", If(type = "Paragraph", DBNull.Value, optionA)),
            New SqlParameter("@B", If(type = "Paragraph", DBNull.Value, optionB)),
            New SqlParameter("@C", If(type = "Paragraph", DBNull.Value, optionC)),
            New SqlParameter("@D", If(type = "Paragraph", DBNull.Value, optionD)),
            New SqlParameter("@CorrectOpt", If(type = "Paragraph", DBNull.Value, correctOption)),
            New SqlParameter("@CorrectAns", If(type = "Paragraph", correctAnswer, DBNull.Value)),
            New SqlParameter("@Difficulty", difficulty),
            New SqlParameter("@Marks", marks),
            New SqlParameter("@Img", If(String.IsNullOrEmpty(imagePath), DBNull.Value, imagePath)),
            New SqlParameter("@TeacherID", teacherID)
        }

        Try
            DBHelper.ExecuteNonQuery(query, params)
            lblMessage.Text = "Question saved successfully!"
            pnlMessage.Visible = True
            ClearForm()
        Catch ex As Exception
            lblMessage.Text = "Error: " & ex.Message
            pnlMessage.CssClass = "alert alert-danger"
            pnlMessage.Visible = True
        End Try
    End Sub

    Private Sub ClearForm()
        txtStatement.Text = ""
        txtOptionA.Text = ""
        txtOptionB.Text = ""
        txtOptionC.Text = ""
        txtOptionD.Text = ""
        txtCorrectMulti.Text = ""
        txtCorrectPara.Text = ""
    End Sub

    Protected Sub btnCancel_Click(sender As Object, e As EventArgs)
        Response.Redirect("Dashboard.aspx")
    End Sub
End Class


