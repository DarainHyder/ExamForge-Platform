<%@ Page Language="VB" MasterPageFile="~/MasterPages/Student.master" AutoEventWireup="true" CodeFile="AttemptQuiz.aspx.vb" Inherits="Student_AttemptQuiz" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Quiz in Progress - ExamForge</title>
    <script src="<%= ResolveUrl("~/Scripts/timer.js") %>"></script>
    <style>
        .option-item {
            display: block;
            padding: 1.25rem;
            background: var(--darker);
            border: 1px solid var(--border);
            border-radius: 12px;
            margin-bottom: 1rem;
            cursor: pointer;
            transition: all 0.3s;
        }
        .option-item:hover {
            border-color: var(--primary);
            background: rgba(99, 102, 241, 0.05);
        }
        .option-item input {
            margin-right: 1rem;
            transform: scale(1.2);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div id="timer" class="timer">Time Remaining: 00:00</div>

    <div class="container">
        <div class="card">
            <div class="card-header" style="display: flex; justify-content: space-between; align-items: center;">
                <h2 class="card-title"><asp:Label ID="lblQuizTitle" runat="server"></asp:Label></h2>
                <div style="color: var(--gray); font-weight: 500;">
                    Question <asp:Label ID="lblCurrentNum" runat="server">1</asp:Label> of <asp:Label ID="lblTotalCount" runat="server"></asp:Label>
                </div>
            </div>

            <asp:Panel ID="pnlQuestion" runat="server">
                <div style="font-size: 1.4rem; font-weight: 600; margin-bottom: 2rem; color: var(--light);">
                    <asp:Label ID="lblQuestionText" runat="server"></asp:Label>
                </div>

                <asp:Image ID="imgQuestion" runat="server" Visible="false" Style="max-width: 100%; border-radius: 12px; margin-bottom: 2rem; border: 1px solid var(--border);" />

                <!-- MCQ Options -->
                <asp:Panel ID="pnlMCQ" runat="server">
                    <div class="option-item">
                        <asp:RadioButton ID="rbA" runat="server" GroupName="Options" Text="" />
                        <asp:Label ID="lblA" runat="server"></asp:Label>
                    </div>
                    <div class="option-item">
                        <asp:RadioButton ID="rbB" runat="server" GroupName="Options" Text="" />
                        <asp:Label ID="lblB" runat="server"></asp:Label>
                    </div>
                    <div class="option-item">
                        <asp:RadioButton ID="rbC" runat="server" GroupName="Options" Text="" />
                        <asp:Label ID="lblC" runat="server"></asp:Label>
                    </div>
                    <div class="option-item">
                        <asp:RadioButton ID="rbD" runat="server" GroupName="Options" Text="" />
                        <asp:Label ID="lblD" runat="server"></asp:Label>
                    </div>
                </asp:Panel>

                <!-- MultiSelect Options -->
                <asp:Panel ID="pnlMulti" runat="server" Visible="false">
                    <div class="option-item">
                        <asp:CheckBox ID="cbA" runat="server" />
                        <asp:Label ID="lblMA" runat="server"></asp:Label>
                    </div>
                    <div class="option-item">
                        <asp:CheckBox ID="cbB" runat="server" />
                        <asp:Label ID="lblMB" runat="server"></asp:Label>
                    </div>
                    <div class="option-item">
                        <asp:CheckBox ID="cbC" runat="server" />
                        <asp:Label ID="lblMC" runat="server"></asp:Label>
                    </div>
                    <div class="option-item">
                        <asp:CheckBox ID="cbD" runat="server" />
                        <asp:Label ID="lblMD" runat="server"></asp:Label>
                    </div>
                </asp:Panel>

                <!-- Paragraph Answer -->
                <asp:Panel ID="pnlPara" runat="server" Visible="false">
                    <asp:TextBox ID="txtAnswer" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="6" placeholder="Type your answer here..."></asp:TextBox>
                </asp:Panel>
            </asp:Panel>

            <div style="margin-top: 3rem; display: flex; justify-content: space-between;">
                <asp:Button ID="btnNext" runat="server" Text="Save & Next" CssClass="btn btn-primary" OnClick="btnNext_Click" />
                <asp:Button ID="btnSubmitQuiz" runat="server" ClientIDMode="Static" Text="Final Submit" CssClass="btn btn-success" OnClick="btnSubmitQuiz_Click" style="display: none;" />
            </div>
        </div>
    </div>

    <asp:HiddenField ID="hfTimerMinutes" runat="server" ClientIDMode="Static" />
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const mins = document.getElementById('hfTimerMinutes').value;
            if (mins) initTimer(parseInt(mins));
        });
    </script>
</asp:Content>
