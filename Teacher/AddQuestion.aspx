<%@ Page Language="VB" MasterPageFile="~/MasterPages/Teacher.master" AutoEventWireup="true" CodeFile="AddQuestion.aspx.vb" Inherits="Teacher_AddQuestion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Add Question - ExamForge</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="container">
        <h1 style="color: var(--primary); margin-bottom: 2rem;">Create New Question</h1>

        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-success">
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card">
            <div class="form-group">
                <label class="form-label">Subject</label>
                <asp:DropDownList ID="ddlSubject" runat="server" CssClass="form-control" DataTextField="SubjectName" DataValueField="SubjectID">
                </asp:DropDownList>
            </div>

            <div class="form-group">
                <label class="form-label">Question Statement</label>
                <asp:TextBox ID="txtStatement" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="4" placeholder="Enter the question here..."></asp:TextBox>
            </div>

            <div class="form-group">
                <label class="form-label">Question Type</label>
                <asp:DropDownList ID="ddlType" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlType_SelectedIndexChanged">
                    <asp:ListItem Text="Multiple Choice (MCQ)" Value="MCQ"></asp:ListItem>
                    <asp:ListItem Text="Multiple Select (MultiSelect)" Value="MultiSelect"></asp:ListItem>
                    <asp:ListItem Text="Short/Long Answer (Paragraph)" Value="Paragraph"></asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:Panel ID="pnlOptions" runat="server">
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                    <div class="form-group">
                        <label class="form-label">Option A</label>
                        <asp:TextBox ID="txtOptionA" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Option B</label>
                        <asp:TextBox ID="txtOptionB" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Option C</label>
                        <asp:TextBox ID="txtOptionC" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Option D</label>
                        <asp:TextBox ID="txtOptionD" runat="server" CssClass="form-control"></asp:TextBox>
                    </div>
                </div>

                <div class="form-group" runat="server" id="divCorrectMCQ">
                    <label class="form-label">Correct Option</label>
                    <asp:DropDownList ID="ddlCorrectOption" runat="server" CssClass="form-control">
                        <asp:ListItem Text="Option A" Value="A"></asp:ListItem>
                        <asp:ListItem Text="Option B" Value="B"></asp:ListItem>
                        <asp:ListItem Text="Option C" Value="C"></asp:ListItem>
                        <asp:ListItem Text="Option D" Value="D"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <div class="form-group" runat="server" id="divCorrectMulti" visible="false">
                    <label class="form-label">Correct Options (CSV e.g. A,C)</label>
                    <asp:TextBox ID="txtCorrectMulti" runat="server" CssClass="form-control" placeholder="A,B"></asp:TextBox>
                </div>
            </asp:Panel>

            <div class="form-group" runat="server" id="divCorrectPara" visible="false">
                <label class="form-label">Sample Correct Answer</label>
                <asp:TextBox ID="txtCorrectPara" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3"></asp:TextBox>
            </div>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                <div class="form-group">
                    <label class="form-label">Difficulty</label>
                    <asp:DropDownList ID="ddlDifficulty" runat="server" CssClass="form-control">
                        <asp:ListItem Value="Easy">Easy</asp:ListItem>
                        <asp:ListItem Value="Medium">Medium</asp:ListItem>
                        <asp:ListItem Value="Hard">Hard</asp:ListItem>
                    </asp:DropDownList>
                </div>
                <div class="form-group">
                    <label class="form-label">Marks</label>
                    <asp:TextBox ID="txtMarks" runat="server" CssClass="form-control" TextMode="Number">1</asp:TextBox>
                </div>
            </div>

            <div class="form-group">
                <label class="form-label">Upload Image (Optional)</label>
                <asp:FileUpload ID="fuImage" runat="server" CssClass="form-control" />
            </div>

            <div style="margin-top: 2rem;">
                <asp:Button ID="btnSave" runat="server" Text="Save Question" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                <asp:Button ID="btnCancel" runat="server" Text="Cancel" CssClass="btn btn-secondary" OnClick="btnCancel_Click" CausesValidation="false" />
            </div>
        </div>
    </div>
</asp:Content>
