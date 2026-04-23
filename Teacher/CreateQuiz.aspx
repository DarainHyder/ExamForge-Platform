<%@ Page Language="VB" MasterPageFile="~/MasterPages/Teacher.master" AutoEventWireup="true" CodeFile="CreateQuiz.aspx.vb" Inherits="Teacher_CreateQuiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Create Quiz - ExamForge</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="container">
        <h1 style="color: var(--primary); margin-bottom: 2rem;">Setup New Quiz</h1>

        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-success">
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">1. Basic Information</h2>
            </div>
            
            <div class="form-group">
                <label class="form-label">Quiz Title</label>
                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" placeholder="e.g. Midterm Programming Exam"></asp:TextBox>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Subject</label>
                    <asp:DropDownList ID="ddlSubject" runat="server" CssClass="form-control" DataTextField="SubjectName" DataValueField="SubjectID" AutoPostBack="true" OnSelectedIndexChanged="ddlSubject_SelectedIndexChanged">
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label class="form-label">Duration (Minutes)</label>
                    <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" TextMode="Number">30</asp:TextBox>
                </div>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Start Time</label>
                    <asp:TextBox ID="txtStart" runat="server" CssClass="form-control" TextMode="DateTimeLocal"></asp:TextBox>
                </div>
                <div class="form-group">
                    <label class="form-label">End Time</label>
                    <asp:TextBox ID="txtEnd" runat="server" CssClass="form-control" TextMode="DateTimeLocal"></asp:TextBox>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">2. Select Questions</h2>
            </div>
            <p style="color: var(--gray); font-size: 0.9rem; margin-bottom: 1rem;">Choose questions from your bank for this subject.</p>
            
            <asp:GridView ID="gvQuestions" runat="server" CssClass="table" AutoGenerateColumns="False" GridLines="None">
                <Columns>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:CheckBox ID="chkSelect" runat="server" />
                            <asp:HiddenField ID="hfID" runat="server" Value='<%# Eval("QuestionID") %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="QuestionStatement" HeaderText="Question" />
                    <asp:BoundField DataField="DifficultyLevel" HeaderText="Difficulty" />
                    <asp:BoundField DataField="Marks" HeaderText="Marks" />
                </Columns>
            </asp:GridView>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">3. Quiz Settings</h2>
            </div>
            
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
                <div>
                    <asp:CheckBox ID="chkRandomize" runat="server" Text=" Randomize Questions" />
                    <br />
                    <asp:CheckBox ID="chkShuffle" runat="server" Text=" Shuffle Options" />
                </div>
                <div>
                    <asp:CheckBox ID="chkNegative" runat="server" Text=" Enable Negative Marking" />
                    <asp:TextBox ID="txtNegative" runat="server" CssClass="form-control" placeholder="Marks per wrong answer" style="margin-top: 0.5rem;"></asp:TextBox>
                </div>
            </div>

            <div style="margin-top: 2rem;">
                <asp:Button ID="btnCreate" runat="server" Text="Create & Publish" CssClass="btn btn-primary" OnClick="btnCreate_Click" />
                <asp:Button ID="btnPreview" runat="server" Text="Preview" CssClass="btn btn-warning" OnClick="btnPreview_Click" />
            </div>
        </div>
    </div>
</asp:Content>
