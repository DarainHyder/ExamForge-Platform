Imports System.Data
Imports System.Data.SqlClient

Partial Class Student_MyResults
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) 
        AuthHelper.RequireRole("Student")

        If Not IsPostBack Then
            LoadResults()
        End If
    End Sub

    Private Sub LoadResults()
        Dim studentID As Integer = AuthHelper.GetCurrentUserID()
        Dim lastQuizID As Object = Session("LastQuizID")

        Try
            ' Load History
            Dim query As String = "SELECT R.ResultID, Q.QuizTitle, R.AttemptDate, R.TotalMarks, R.ObtainedMarks, R.Percentage " &
                                  "FROM Results R INNER JOIN Quiz Q ON R.QuizID = Q.QuizID " &
                                  "WHERE R.StudentID = @SID ORDER BY R.AttemptDate DESC"
            
            Dim dtResults As DataTable = DBHelper.ExecuteReader(query, New SqlParameter("@SID", studentID))
            gvResults.DataSource = dtResults
            gvResults.DataBind()

            ' Load Latest if applicable
            If lastQuizID IsNot Nothing Then
                Dim latestQuery As String = "SELECT TOP 1 R.TotalMarks, R.ObtainedMarks, R.Percentage, R.TotalCorrect, R.TotalIncorrect, R.TotalUnanswered, Q.QuizTitle " &
                                           "FROM Results R INNER JOIN Quiz Q ON R.QuizID = Q.QuizID " &
                                           "WHERE R.StudentID = @SID AND R.QuizID = @QID ORDER BY R.ResultID DESC"
                
                Dim dtLatest As DataTable = DBHelper.ExecuteReader(latestQuery, 
                    New SqlParameter("@SID", studentID), 
                    New SqlParameter("@QID", Convert.ToInt32(lastQuizID)))
                
                If dtLatest.Rows.Count > 0 Then
                    Dim row As DataRow = dtLatest.Rows(0)
                    pnlLatest.Visible = True
                    lblLatestTitle.Text = row("QuizTitle").ToString()
                    lblLatestScore.Text = row("Percentage").ToString()
                    lblLatestMarks.Text = row("ObtainedMarks").ToString()
                    lblLatestTotal.Text = row("TotalMarks").ToString()

                    ' Prepare Chart Data
                    hfChartData.Value = ChartHelper.GeneratePieChartData(
                        Convert.ToInt32(row("TotalCorrect")),
                        Convert.ToInt32(row("TotalIncorrect")),
                        Convert.ToInt32(row("TotalUnanswered")))
                    
                    Session("LastQuizID") = Nothing ' Clear once shown
                End If
            End If
        Catch ex As Exception
        End Try
    End Sub
End Class


