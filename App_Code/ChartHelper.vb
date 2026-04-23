Imports System.Text
Imports System.Linq
Imports System.Collections.Generic

Public Class ChartHelper
    ' Generate Pie Chart Data for Result Analytics
    Public Shared Function GeneratePieChartData(correct As Integer, incorrect As Integer, unanswered As Integer) As String
        Dim data As New StringBuilder()
        data.Append("{")
        data.AppendFormat("labels: ['Correct', 'Incorrect', 'Unanswered'],")
        data.AppendFormat("datasets: [{{")
        data.AppendFormat("data: [{0}, {1}, {2}],", correct, incorrect, unanswered)
        data.AppendFormat("backgroundColor: ['#10b981', '#ef4444', '#64748b']")
        data.Append("}}]")
        data.Append("}")
        Return data.ToString()
    End Function

    ' Generate Bar Chart for Quiz Performance
    Public Shared Function GenerateBarChartData(labels As List(Of String), values As List(Of Integer)) As String
        Dim data As New StringBuilder()
        data.Append("{")
        data.AppendFormat("labels: [{0}],", String.Join(",", labels.Select(Function(l) "'" & l & "'")))
        data.AppendFormat("datasets: [{{")
        data.AppendFormat("label: 'Marks',")
        data.AppendFormat("data: [{0}],", String.Join(",", values))
        data.AppendFormat("backgroundColor: '#6366f1'")
        data.Append("}}]")
        data.Append("}")
        Return data.ToString()
    End Function
End Class

