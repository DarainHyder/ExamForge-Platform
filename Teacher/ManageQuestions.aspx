<%@ Page Language="VB" MasterPageFile="~/MasterPages/Teacher.master" AutoEventWireup="true" CodeFile="ManageQuestions.aspx.vb" Inherits="Teacher_ManageQuestions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Manage Questions - ExamForge</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
            <h1 style="color: var(--primary);">Question Bank</h1>
            <asp:Button ID="btnAddNew" runat="server" Text="Create New" CssClass="btn btn-primary" OnClick="btnAddNew_Click" />
        </div>

        <div class="card">
            <div style="display: flex; gap: 1rem; margin-bottom: 1.5rem;">
                <asp:DropDownList ID="ddlFilterSubject" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed" DataTextField="SubjectName" DataValueField="SubjectID" AppendDataBoundItems="true">
                    <asp:ListItem Text="All Subjects" Value="0"></asp:ListItem>
                </asp:DropDownList>
                <asp:DropDownList ID="ddlFilterType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="Filter_Changed">
                    <asp:ListItem Text="All Types" Value=""></asp:ListItem>
                    <asp:ListItem Value="MCQ">MCQ</asp:ListItem>
                    <asp:ListItem Value="MultiSelect">Multi-Select</asp:ListItem>
                    <asp:ListItem Value="Paragraph">Paragraph</asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:GridView ID="gvQuestions" runat="server" CssClass="table" AutoGenerateColumns="False" EmptyDataText="No questions found matching criteria." GridLines="None" OnRowCommand="gvQuestions_RowCommand">
                <Columns>
                    <asp:BoundField DataField="QuestionID" HeaderText="ID" />
                    <asp:TemplateField HeaderText="Question">
                        <ItemTemplate>
                            <div style="max-width: 400px; white-space: normal;">
                                <strong><%# Eval("QuestionStatement") %></strong>
                                <br />
                                <small style="color: var(--gray);"><%# Eval("SubjectName") %> | <%# Eval("QuestionType") %></small>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="DifficultyLevel" HeaderText="Difficulty" />
                    <asp:BoundField DataField="Marks" HeaderText="Marks" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteQuestion" CommandArgument='<%# Eval("QuestionID") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Delete this question?');">Delete</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
