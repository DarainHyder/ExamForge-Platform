<%@ Page Language="VB" MasterPageFile="~/MasterPages/Admin.master" AutoEventWireup="true" CodeFile="ManageUsers.aspx.vb" Inherits="Admin_ManageUsers" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Manage Users - ExamForge</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="container">
        <h1 style="color: var(--primary); margin-bottom: 2rem;">User Management</h1>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">Registered System Users</h2>
            </div>
            
            <div style="margin-bottom: 1.5rem; display: flex; gap: 1rem;">
                <asp:DropDownList ID="ddlRoleFilter" runat="server" CssClass="form-control" AutoPostBack="true" OnSelectedIndexChanged="ddlRoleFilter_SelectedIndexChanged">
                    <asp:ListItem Text="All Roles" Value=""></asp:ListItem>
                    <asp:ListItem Value="Admin">Admin</asp:ListItem>
                    <asp:ListItem Value="Teacher">Teacher</asp:ListItem>
                    <asp:ListItem Value="Student">Student</asp:ListItem>
                </asp:DropDownList>
            </div>

            <asp:GridView ID="gvUsers" runat="server" CssClass="table" AutoGenerateColumns="False" GridLines="None" OnRowCommand="gvUsers_RowCommand">
                <Columns>
                    <asp:BoundField DataField="Username" HeaderText="Username" />
                    <asp:BoundField DataField="FullName" HeaderText="Full Name" />
                    <asp:BoundField DataField="Role" HeaderText="Role" />
                    <asp:BoundField DataField="Email" HeaderText="Email" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <%# If(Convert.ToBoolean(Eval("IsActive")), "<span class='user-badge' style='background: var(--success);'>Active</span>", "<span class='user-badge' style='background: var(--danger);'>Deactivated</span>")%>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Actions">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnToggle" runat="server" CommandName="ToggleStatus" CommandArgument='<%# Eval("UserID") %>' 
                                CssClass='<%# If(Convert.ToBoolean(Eval("IsActive")), "btn btn-danger btn-sm", "btn btn-success btn-sm") %>'
                                Text='<%# If(Convert.ToBoolean(Eval("IsActive")), "Deactivate", "Activate") %>'>
                            </asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
        </div>
    </div>
</asp:Content>
