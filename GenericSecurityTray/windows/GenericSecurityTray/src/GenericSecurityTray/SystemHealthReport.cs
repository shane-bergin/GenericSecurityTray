using System;
using System.Collections.Generic;

namespace GenericSecurityTray
{
    public class SystemHealthReport
    {
        public bool FirewallEnabled { get; set; } = true;
        public bool AntivirusRunning { get; set; } = true;
        public DateTime LastScanTime { get; set; } = DateTime.Now.AddDays(-1);
        public IList<string> Issues { get; set; } = new List<string>();

        public string Summary =>
            Issues.Count == 0 ? "All security checks healthy." : string.Join(" ", Issues);
    }
}