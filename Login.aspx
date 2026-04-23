<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Login.aspx.vb" Inherits="Login" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8" />
    <title>Login - ExamForge</title>
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" />
    <link rel="stylesheet" href="Styles/site.css" />
    <style>
        .login-page {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            padding: 2rem;
        }
        .login-card {
            width: 100%;
            max-width: 420px;
            animation: fadeIn 0.6s ease-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body class="login-page">
    <form id="form1" runat="server" class="login-card">
        <div class="card">
            <div class="card-header" style="text-align: center;">
                <h1 style="color: var(--primary); font-size: 2.5rem; margin-bottom: 0.5rem;">ExamForge</h1>
                <p style="color: var(--gray);">Sign in to your assessment portal</p>
            </div>

            <asp:Panel ID="pnlError" runat="server" Visible="false" CssClass="alert alert-danger" style="padding: 1rem; margin-bottom: 1rem; border-radius: 8px; background: rgba(239, 68, 68, 0.1); border: 1px solid var(--danger); color: var(--danger);">
                <asp:Label ID="lblError" runat="server"></asp:Label>
            </asp:Panel>

            <div class="form-group">
                <label class="form-label">Username</label>
                <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter your username"></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Password</label>
                <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter password"></asp:TextBox>
            </div>

            <div class="form-group">
                <asp:Button ID="btnLogin" runat="server" Text="Sign In" CssClass="btn btn-primary" Style="width: 100%;" OnClick="btnLogin_Click" />
            </div>

            <div style="margin-top: 2rem; padding-top: 1.5rem; border-top: 1px solid var(--border); font-size: 0.85rem; color: var(--gray);">
                <p style="font-weight: 600; margin-bottom: 0.5rem;">Demo Accounts:</p>
                <ul style="list-style: none; padding: 0;">
                    <li>Admin: <code>admin</code> / <code>Admin@123</code></li>
                    <li>Teacher: <code>t_ali</code> / <code>Teacher@1</code></li>
                    <li>Student: <code>s_usman</code> / <code>Student@1</code></li>
                </ul>
            </div>
        </div>
    </form>
</body>
</html>
