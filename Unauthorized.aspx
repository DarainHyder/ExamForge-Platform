<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/MasterPages/Main.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <title>Unauthorized Access - ExamForge</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container" style="text-align: center; padding: 4rem 1rem;">
        <h1 style="font-size: 6rem; color: var(--danger); margin-bottom: 1rem;">403</h1>
        <h2 style="font-size: 2rem; margin-bottom: 2rem;">Access Denied</h2>
        <p style="color: var(--gray); font-size: 1.2rem; margin-bottom: 3rem;">
            You do not have the required permissions to access this area. 
            If you believe this is an error, please contact your administrator.
        </p>
        <a href="<%= ResolveUrl("~/Login.aspx") %>" class="btn btn-primary">Return to Home</a>
    </div>
</asp:Content>
