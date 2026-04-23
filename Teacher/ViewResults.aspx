<%@ Page Language="VB" MasterPageFile="~/MasterPages/Teacher.master" AutoEventWireup="true" CodeFile="ViewResults.aspx.vb" Inherits="Teacher_ViewResults" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>View Results - ExamForge</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="container">
        <h1 style="color: var(--primary); margin-bottom: 2rem;">Exam Results</h1>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Student Performance Overview</h2>
            </div>
            
            <div style="margin-bottom: 1.5rem; display: flex; gap: 1rem;">
                <asp:DropDownList ID="ddlQuizFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlQuizFilter_SelectedIndexChanged" DataTextField="QuizTitle" DataValueField="QuizID" AppendDataBoundItems="true">
                    <asp:ListItem Text="All Quizzes" Value="0"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:GridView ID="gvResults" runat="server" CssClass="table" AutoGenerateColumns="False" EmptyDataText="No results found for your quizzes." GridLines="None">
                <Columns>
                    <asp:BoundField DataField="FullName" HeaderText="Student Name" />
                    <asp:BoundField DataField="QuizTitle" HeaderText="Quiz" />
                    <asp:BoundField DataField="AttemptDate" HeaderText="Date" DataFormatString="{0:dd MMM HH:mm}" />
                    <asp:BoundField DataField="TotalMarks" HeaderText="Total" />
                    <asp:BoundField DataField="ObtainedMarks" HeaderText="Obtained" />
                    <asp:TemplateField HeaderText="Percentage">
                        <ItemTemplate>
                            <strong><%# Eval("Percentage") %>%</strong>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Outcome">
                        <ItemTemplate>
                            <%# If(Convert.ToDecimal(Eval("Percentage")) >= 50, "<span class='badge' style='background: var(--success);'>PASS</span>", "<span class='badge' style='background: var(--danger);'>FAIL</span>")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
