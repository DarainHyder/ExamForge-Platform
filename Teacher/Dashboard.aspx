<%@ Page Language="VB" MasterPageFile="~/MasterPages/Teacher.master" AutoEventWireup="true" CodeFile="Dashboard.aspx.vb" Inherits="Teacher_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Teacher Dashboard - ExamForge</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2.5rem;">
            <h1 style="color: var(--primary); font-size: 2.5rem;">Teacher Dashboard</h1>
            <div style="color: var(--gray); font-weight: 500;">
                <%= DateTime.Now.ToString("dddd, dd MMMM yyyy") %>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card">
                <div class="stat-value"><asp:Label ID="lblTotalQuestions" runat="server" Text="0"></asp:Label></div>
                <div class="stat-label">Questions Bank</div>
            </div>
            <div class="stat-card" style="border-top: 4px solid var(--success);">
                <div class="stat-value"><asp:Label ID="lblTotalQuizzes" runat="server" Text="0"></asp:Label></div>
                <div class="stat-label">Total Quizzes</div>
            </div>
            <div class="stat-card" style="border-top: 4px solid var(--warning);">
                <div class="stat-value"><asp:Label ID="lblPublishedQuizzes" runat="server" Text="0"></asp:Label></div>
                <div class="stat-label">Active Tests</div>
            </div>
            <div class="stat-card" style="border-top: 4px solid var(--info);">
                <div class="stat-value"><asp:Label ID="lblTotalAttempts" runat="server" Text="0"></asp:Label></div>
                <div class="stat-label">Student Submissions</div>
            </div>
        </div>

        <!-- Quick Actions -->
        <div class="card" style="background: rgba(99, 102, 241, 0.05); border-color: rgba(99, 102, 241, 0.2);">
            <div class="card-header" style="border: none;">
                <h2 class="card-title" style="display: flex; align-items: center; gap: 0.75rem;">
                    Quick Actions
                </h2>
            </div>
            <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 1rem;">
                <asp:Button ID="btnAddQuestion" runat="server" Text="Create Question" CssClass="btn btn-primary" OnClick="btnAddQuestion_Click" />
                <asp:Button ID="btnManageQuestions" runat="server" Text="Manage Bank" CssClass="btn btn-success" OnClick="btnManageQuestions_Click" />
                <asp:Button ID="btnCreateQuiz" runat="server" Text="Setup Quiz" CssClass="btn btn-warning" OnClick="btnCreateQuiz_Click" />
                <asp:Button ID="btnViewResults" runat="server" Text="Analytics" CssClass="btn btn-info" OnClick="btnViewResults_Click" />
            </div>
        </div>

        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 2rem;">
            <!-- Recent Quizzes -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Recent Quizzes</h2>
                </div>
                <asp:GridView ID="gvRecentQuizzes" runat="server" CssClass="table" AutoGenerateColumns="False" EmptyDataText="No quizzes created yet" GridLines="None">
                    <Columns>
                        <asp:BoundField DataField="QuizTitle" HeaderText="Quiz Title" />
                        <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                        <asp:BoundField DataField="TotalQuestions" HeaderText="Questions" />
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <%# If(Convert.ToBoolean(Eval("IsPublished")), "<span class='user-badge' style='background: var(--success);'>Published</span>", "<span class='user-badge' style='background: var(--gray);'>Draft</span>")%>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>

            <!-- Notifications -->
            <div class="card">
                <div class="card-header">
                    <h2 class="card-title">Alerts</h2>
                </div>
                <asp:Repeater ID="rptNotifications" runat="server">
                    <ItemTemplate>
                        <div style="padding: 1rem; border-left: 3px solid var(--primary); background: var(--darker); border-radius: 4px; margin-bottom: 1rem;">
                            <p style="font-size: 0.9rem; margin-bottom: 0.4rem;"><%# Eval("Message") %></p>
                            <small style="color: var(--gray);"><%# Eval("CreatedAt", "{0:dd MMM HH:mm}") %></small>
                        </div>
                    </ItemTemplate>
                </asp:Repeater>
            </div>
        </div>
    </div>
</asp:Content>
