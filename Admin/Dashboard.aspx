<%@ Page Language="VB" MasterPageFile="~/MasterPages/Admin.master" AutoEventWireup="true" CodeFile="Dashboard.aspx.vb" Inherits="Admin_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Admin Dashboard - ExamForge</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="container">
        <h1 style="color: var(--primary); margin-bottom: 2rem;">System Overview</h1>

        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblTotalUsers" runat="server">0</asp:Label></div>
                <div class="stat-label">Registered Users</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblTotalSubjects" runat="server">0</asp:Label></div>
                <div class="stat-label">Active Subjects</div>
            </div>
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblTotalResults" runat="server">0</asp:Label></div>
                <div class="stat-label">Exams Completed</div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Recent System Activities</h2>
            </div>
            <asp:GridView ID="gvSystemLogs" runat="server" CssClass="table" AutoGenerateColumns="False" EmptyDataText="No recent logs." GridLines="None">
                <Columns>
                    <asp:BoundField DataField="CreatedAt" HeaderText="Timestamp" DataFormatString="{0:dd MMM HH:mm}" />
                    <asp:BoundField DataField="Role" HeaderText="User Role" />
                    <asp:BoundField DataField="Username" HeaderText="User" />
                    <asp:TemplateField HeaderText="Action">
                        <ItemTemplate>
                            <span class="user-badge" style="background: var(--darker); border: 1px solid var(--border); color: var(--light);">
                                Modified User Data
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
