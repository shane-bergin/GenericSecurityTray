using System;
using System.Collections.Generic;

namespace GenericSecurityTray
{
    internal class SystemHealthChecker
    {
        public SystemHealthReport BuildReport()
        {
            return new SystemHealthReport
            {
                FirewallEnabled = true,
                AntivirusRunning = true,
                LastScanTime = DateTime.Now.AddDays(-1),
                Issues = new List<string>()
            };
        }
    }
}