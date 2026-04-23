<%@ Page Language="VB" MasterPageFile="~/MasterPages/Student.master" AutoEventWireup="true" CodeFile="Dashboard.aspx.vb" Inherits="Student_Dashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Student Dashboard - ExamForge</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="container">
        <h1 style="color: var(--primary); margin-bottom: 2rem;">Student Dashboard</h1>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Available Quizzes</h2>
            </div>
            
            <asp:GridView ID="gvQuizzes" runat="server" CssClass="table" AutoGenerateColumns="False" EmptyDataText="No active quizzes available for your subjects at this time." GridLines="None" OnRowCommand="gvQuizzes_RowCommand">
                <Columns>
                    <asp:BoundField DataField="QuizTitle" HeaderText="Quiz Title" />
                    <asp:BoundField DataField="SubjectName" HeaderText="Subject" />
                    <asp:BoundField DataField="TotalQuestions" HeaderText="Questions" />
                    <asp:BoundField DataField="AllowedTime" HeaderText="Time (Mins)" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <%# If(Convert.ToBoolean(Eval("IsAttempted")), "<span class='user-badge' style='background: var(--success);'>Completed</span>", "<span class='user-badge' style='background: var(--primary);'>Pending</span>")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:Button ID="btnStart" runat="server" Text="Start Exam" CssClass="btn btn-primary btn-sm" CommandName="StartQuiz" CommandArgument='<%# Eval("QuizID") %>' Visible='<%# Not Convert.ToBoolean(Eval("IsAttempted")) %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Recent Notifications</h2>
            </div>
            <asp:Repeater ID="rptNotifications" runat="server">
                <ItemTemplate>
                    <div style="padding: 1rem; border-left: 3px solid var(--primary); background: var(--darker); border-radius: 4px; margin-bottom: 1rem;">
                        <%# Eval("Message") %>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
