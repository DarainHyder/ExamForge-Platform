Imports System.Data
Imports System.Data.SqlClient
Imports System.Configuration

Public Class DBHelper
    Private Shared ReadOnly ConnectionString As String = ConfigurationManager.ConnectionStrings("ExamForgeDB").ConnectionString

    ' Execute Non-Query (INSERT, UPDATE, DELETE)
    Public Shared Function ExecuteNonQuery(query As String, ParamArray parameters As SqlParameter()) As Integer
        Using conn As New SqlConnection(ConnectionString)
            Using cmd As New SqlCommand(query, conn)
                If parameters IsNot Nothing Then
                    cmd.Parameters.AddRange(parameters)
                End If
                conn.Open()
                Return cmd.ExecuteNonQuery()
            End Using
        End Using
    End Function

    ' Execute Scalar (Single Value)
    Public Shared Function ExecuteScalar(query As String, ParamArray parameters As SqlParameter()) As Object
        Using conn As New SqlConnection(ConnectionString)
            Using cmd As New SqlCommand(query, conn)
                If parameters IsNot Nothing Then
                    cmd.Parameters.AddRange(parameters)
                End If
                conn.Open()
                Return cmd.ExecuteScalar()
            End Using
        End Using
    End Function

    ' Execute Reader (SELECT)
    Public Shared Function ExecuteReader(query As String, ParamArray parameters As SqlParameter()) As DataTable
        Dim dt As New DataTable()
        Using conn As New SqlConnection(ConnectionString)
            Using cmd As New SqlCommand(query, conn)
                If parameters IsNot Nothing Then
                    cmd.Parameters.AddRange(parameters)
                End If
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    dt.Load(reader)
                End Using
            End Using
        End Using
        Return dt
    End Function

    ' Execute Stored Procedure
    Public Shared Function ExecuteStoredProcedure(procedureName As String, ParamArray parameters As SqlParameter()) As DataTable
        Dim dt As New DataTable()
        Using conn As New SqlConnection(ConnectionString)
            Using cmd As New SqlCommand(procedureName, conn)
                cmd.CommandType = CommandType.StoredProcedure
                If parameters IsNot Nothing Then
                    cmd.Parameters.AddRange(parameters)
                End If
                conn.Open()
                Using reader As SqlDataReader = cmd.ExecuteReader()
                    dt.Load(reader)
                End Using
            End Using
        End Using
        Return dt
    End Function

    ' Hash Password (SHA256)
    Public Shared Function HashPassword(password As String) As String
        Using sha256 As System.Security.Cryptography.SHA256 = System.Security.Cryptography.SHA256.Create()
            Dim bytes As Byte() = System.Text.Encoding.UTF8.GetBytes(password)
            Dim hash As Byte() = sha256.ComputeHash(bytes)
            Return BitConverter.ToString(hash).Replace("-", "")
        End Using
    End Function
End Class

