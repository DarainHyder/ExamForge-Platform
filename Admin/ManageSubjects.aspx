<%@ Page Language="VB" MasterPageFile="~/MasterPages/Admin.master" AutoEventWireup="true" CodeFile="ManageSubjects.aspx.vb" Inherits="Admin_ManageSubjects" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Manage Subjects - ExamForge</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="container">
        <h1 style="color: var(--primary); margin-bottom: 2rem;">Subject Management</h1>

        <asp:Panel ID="pnlMessage" runat="server" Visible="false" CssClass="alert alert-success">
            <asp:Label ID="lblMessage" runat="server"></asp:Label>
        </asp:Panel>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Add New Subject</h2>
            </div>
            <div style="display: flex; gap: 1rem; align-items: flex-end;">
                <div class="form-group" style="flex: 1; margin: 0;">
                    <label class="form-label">Subject Name</label>
                    <asp:TextBox ID="txtSubjectName" runat="server" CssClass="form-control" placeholder="e.g. Data Structures"></asp:TextBox>
                </div>
                <div class="form-group" style="flex: 2; margin: 0;">
                    <label class="form-label">Description</label>
                    <asp:TextBox ID="txtDescription" runat="server" CssClass="form-control" placeholder="Optional description"></asp:TextBox>
                </div>
                <asp:Button ID="btnAdd" runat="server" Text="Add" CssClass="btn btn-primary" OnClick="btnAdd_Click" />
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Active Subjects</h2>
            </div>
            <asp:GridView ID="gvSubjects" runat="server" CssClass="table" AutoGenerateColumns="False" GridLines="None" OnRowCommand="gvSubjects_RowCommand">
                <Columns>
                    <asp:BoundField DataField="SubjectID" HeaderText="ID" />
                    <asp:BoundField DataField="SubjectName" HeaderText="Subject Name" />
                    <asp:BoundField DataField="Description" HeaderText="Description" />
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteSubject" CommandArgument='<%# Eval("SubjectID") %>' CssClass="btn btn-danger btn-sm" OnClientClick="return confirm('Delete this subject?');">Delete</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
