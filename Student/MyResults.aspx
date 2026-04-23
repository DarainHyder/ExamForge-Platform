<%@ Page Language="VB" MasterPageFile="~/MasterPages/Student.master" AutoEventWireup="true" CodeFile="MyResults.aspx.vb" Inherits="Student_MyResults" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>My Results - ExamForge</title>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="container">
        <h1 style="color: var(--primary); margin-bottom: 2rem;">Performance & History</h1>

        <asp:Panel ID="pnlLatest" runat="server" Visible="false" CssClass="card" style="border-left: 5px solid var(--success);">
            <div class="card-header">
                <h2 class="card-title">Latest Quiz Performance</h2>
            </div>
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem; align-items: center;">
                <div>
                    <p style="font-size: 1.1rem; margin-bottom: 1rem;">
                        <strong>Quiz:</strong> <asp:Label ID="lblLatestTitle" runat="server"></asp:Label>
                    </p>
                    <div style="font-size: 3.5rem; font-weight: 800; color: var(--success); margin-bottom: 0.5rem;">
                        <asp:Label ID="lblLatestScore" runat="server"></asp:Label>%
                    </div>
                    <p style="color: var(--gray); font-weight: 600;">
                        Obtained <asp:Label ID="lblLatestMarks" runat="server"></asp:Label> out of <asp:Label ID="lblLatestTotal" runat="server"></asp:Label>
                    </p>
                </div>
                <div class="chart-container">
                    <canvas id="latestChart"></canvas>
                </div>
            </div>
        </asp:Panel>

        <div class="card">
            <div class="card-header">
                <h2 class="card-title">All Attempts</h2>
            </div>
            <asp:GridView ID="gvResults" runat="server" CssClass="table" AutoGenerateColumns="False" EmptyDataText="No quiz history found." GridLines="None">
                <Columns>
                    <asp:BoundField DataField="QuizTitle" HeaderText="Quiz" />
                    <asp:BoundField DataField="AttemptDate" HeaderText="Date" DataFormatString="{0:dd MMM yyyy HH:mm}" />
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

    <asp:HiddenField ID="hfChartData" runat="server" ClientIDMode="Static" />
    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const dataStr = document.getElementById('hfChartData').value;
            if (dataStr) {
                const data = JSON.parse(dataStr.replace(/'/g, '"'));
                new Chart(document.getElementById('latestChart'), {
                    type: 'doughnut',
                    data: data,
                    options: {
                        plugins: { legend: { position: 'bottom', labels: { color: '#94a3b8' } } },
                        cutout: '70%'
                    }
                });
            }
        });
    </script>
</asp:Content>
