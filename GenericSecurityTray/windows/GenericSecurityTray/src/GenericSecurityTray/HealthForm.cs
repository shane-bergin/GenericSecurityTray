using System.Text;
using System.Windows.Forms;

namespace GenericSecurityTray
{
    public partial class HealthForm : Form
    {
        public HealthForm(SystemHealthReport r)
        {
            InitializeComponent();

            var sb = new StringBuilder();
            sb.AppendLine($"Firewall enabled: {r.FirewallEnabled}");
            sb.AppendLine($"Antivirus running: {r.AntivirusRunning}");
            sb.AppendLine($"Last scan: {r.LastScanTime:g}");

            if (r.Issues.Count == 0)
                sb.AppendLine("No outstanding issues.");
            else
                foreach (var i in r.Issues)
                    sb.AppendLine("- " + i);

            summaryText.Text = sb.ToString();
        }
    }
}
