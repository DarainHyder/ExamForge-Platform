Imports System.Web
Imports System.Web.Security

Public Class AuthHelper
    ' Check if user is authenticated
    Public Shared Function IsAuthenticated() As Boolean
        Return HttpContext.Current.User.Identity.IsAuthenticated
    End Function

    ' Get current user ID from session
    Public Shared Function GetCurrentUserID() As Integer
        If HttpContext.Current.Session("UserID") IsNot Nothing Then
            Return Convert.ToInt32(HttpContext.Current.Session("UserID"))
        End If
        Return 0
    End Function

    ' Get current user role
    Public Shared Function GetCurrentUserRole() As String
        If HttpContext.Current.Session("Role") IsNot Nothing Then
            Return HttpContext.Current.Session("Role").ToString()
        End If
        Return String.Empty
    End Function

    ' Get current username
    Public Shared Function GetCurrentUsername() As String
        If HttpContext.Current.Session("Username") IsNot Nothing Then
            Return HttpContext.Current.Session("Username").ToString()
        End If
        Return String.Empty
    End Function

    ' Check if user has specific role
    Public Shared Function HasRole(role As String) As Boolean
        Return GetCurrentUserRole().Equals(role, StringComparison.OrdinalIgnoreCase)
    End Function

    ' Require authentication
    Public Shared Sub RequireAuth()
        If Not IsAuthenticated() Then
            FormsAuthentication.RedirectToLoginPage()
        End If
    End Sub

    ' Require specific role
    Public Shared Sub RequireRole(role As String)
        RequireAuth()
        If Not HasRole(role) Then
            HttpContext.Current.Response.Redirect("~/Unauthorized.aspx")
        End If
    End Sub

    ' Login user
    Public Shared Sub LoginUser(userID As Integer, username As String, role As String)
        HttpContext.Current.Session("UserID") = userID
        HttpContext.Current.Session("Username") = username
        HttpContext.Current.Session("Role") = role
        FormsAuthentication.SetAuthCookie(username, False)
    End Sub

    ' Logout user
    Public Shared Sub LogoutUser()
        HttpContext.Current.Session.Clear()
        HttpContext.Current.Session.Abandon()
        FormsAuthentication.SignOut()
    End Sub

    ' Redirect based on role
    Public Shared Sub RedirectByRole()
        Dim role As String = GetCurrentUserRole()
        Select Case role.ToLower()
            Case "admin"
                HttpContext.Current.Response.Redirect("~/Admin/Dashboard.aspx")
            Case "teacher"
                HttpContext.Current.Response.Redirect("~/Teacher/Dashboard.aspx")
            Case "student"
                HttpContext.Current.Response.Redirect("~/Student/Dashboard.aspx")
            Case Else
                HttpContext.Current.Response.Redirect("~/Login.aspx")
        End Select
    End Sub
End Class

