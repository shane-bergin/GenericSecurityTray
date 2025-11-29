using System;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Windows.Forms;

namespace GenericSecurityTray
{
    internal class TrayApplicationContext : ApplicationContext
    {
        private readonly NotifyIcon _trayIcon;

        public TrayApplicationContext()
        {
            var menu = new ContextMenuStrip();
            menu.Items.Add("Apply Aggressive Mode", null, (_, _) => RunScript("Aggressive"));
            menu.Items.Add("Apply Audit Mode",       null, (_, _) => RunScript("Audit"));
            menu.Items.Add("Revert All Changes",    null, (_, _) => RunScript("Revert"));
            menu.Items.Add(new ToolStripSeparator());
            menu.Items.Add("Show Status",           null, (_, _) => RunScript("StatusOnly"));
            menu.Items.Add(new ToolStripSeparator());
            menu.Items.Add("Exit",                  null, (_, _) => Exit());

            _trayIcon = new NotifyIcon
            {
                Icon = System.Drawing.SystemIcons.Shield,
                Text = "Generic Security Tray",
                ContextMenuStrip = menu,
                Visible = true
            };

            _trayIcon.ShowBalloonTip(5000, "Generic Security Tray", "Right-click for options", ToolTipIcon.Info);
        }

        private string GetScriptPath()
        {
            // 1. Installed location (after installer)
            var installed = @"C:\Program Files\GenericSecurityTray\scripts\GenericSecurityHardening.ps1";
            if (File.Exists(installed)) return installed;

            // 2. Developer mode — go up 5 levels from bin\Release\net8.0-windows\
            var exeDir = Path.GetDirectoryName(Assembly.GetExecutingAssembly().Location)!;
            var root = exeDir;
            for (int i = 0; i < 5; i++)
                root = Path.GetDirectoryName(root)!;

            var dev = Path.Combine(root, "windows", "GenericSecurityTray", "scripts", "GenericSecurityHardening.ps1");
            if (File.Exists(dev))
                return dev;

            return string.Empty;
        }

        private void RunScript(string mode)
        {
            var path = GetScriptPath();
            if (string.IsNullOrEmpty(path))
            {
                _trayIcon.ShowBalloonTip(5000, "Error", "Hardening script not found!", ToolTipIcon.Error);
                return;
            }

            var escaped = path.Replace("\"", "\"\"");
            var psi = new ProcessStartInfo
            {
                FileName = "powershell.exe",
                Arguments = $"-NoProfile -ExecutionPolicy Bypass -NoExit -File \"{escaped}\" -Mode {mode}",
                Verb = "runas",
                UseShellExecute = true,
                CreateNoWindow = false
            };

            try
            {
                Process.Start(psi);
                _trayIcon.ShowBalloonTip(3000, "Generic Security Tray", $"{mode} mode started", ToolTipIcon.Info);
            }
            catch (Exception ex)
            {
                _trayIcon.ShowBalloonTip(5000, "Error", ex.Message, ToolTipIcon.Error);
            }
        }

        private void Exit()
        {
            _trayIcon.Visible = false;
            Application.Exit();
        }
    }
}