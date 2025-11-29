param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("Aggressive","Audit","Revert","StatusOnly")]
    [string]$Mode
)

$ErrorActionPreference = 'Stop'

# Logging
$LogRoot = "$env:ProgramData\GenericSecurityTray\Logs"
New-Item -Path $LogRoot -ItemType Directory -Force | Out-Null
$LogPath = Join-Path $LogRoot ("hardening_$(Get-Date -Format 'yyyyMMdd_HHmmss').log")
Start-Transcript -Path $LogPath -Append -Force | Out-Null

function Log { param([string]$Msg) Write-Host "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $Msg" }

# Admin + Defender check
$principal = [Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()
if (-not $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Log "ERROR: Must run as Administrator"
    Stop-Transcript; exit 1
}
if (-not (Get-Command Set-MpPreference -ErrorAction SilentlyContinue)) {
    Log "ERROR: Defender cmdlets unavailable"
    Stop-Transcript; exit 1
}

# 19 validated ASR rules (2025)
$AsrRules = [ordered]@{
    '56a863a9-875e-4185-98a7-b882c64b5ce5' = 'Block vulnerable signed drivers'
    '7674ba52-37eb-4a4f-a9a1-f0f9a1619a2c' = 'Block Adobe Reader child processes'
    'd4f940ab-401b-4efc-aadc-ad5f3c50688a' = 'Block Office child processes'
    '9e6c4e1f-7d60-472f-ba1a-a39ef669e4b2' = 'Block LSASS credential stealing'
    'be9ba2d9-53ea-4cdc-84e5-9b1eeee46550' = 'Block exec content from email'
    '01443614-cd74-433a-b99e-2ecdc07bfc25' = 'Block untrusted executables'
    '5beb7efe-fd9a-4556-801d-275e5ffc04cc' = 'Block obfuscated scripts'
    'd3e037e1-3eb8-44c8-a917-57927947596d' = 'Block JS/VBS launching downloaded exec'
    '3b576869-a4ec-4529-8536-b80a7769e899' = 'Block Office creating executables'
    '75668c1f-73b5-4cf0-bb93-3ecf5cb7cc84' = 'Block Office code injection'
    '26190899-1602-49e8-8b27-eb1d0a1ce869' = 'Block Outlook child processes'
    'e6db77e5-3df2-4cf1-b95a-636979351e5b' = 'Block WMI persistence'
    'd1e49aac-8f56-4280-b9ba-993a6d77406c' = 'Block PSExec/WMI process creation'
    '33ddedf1-c6e0-47cb-833e-de6133960387' = 'Block Safe Mode reboot'
    'b2b3f03d-6a65-4f7b-a9c7-1c7ef74a9ba4' = 'Block unsigned USB processes'
    'c0033c00-d16d-4114-a5a0-dc9b3a7d2ceb' = 'Block impersonated system tools'
    'a8f5898e-1dc8-49a9-9878-85004b8a61e6' = 'Block webshell creation'
    '92e97fa1-2edf-4476-bdd6-9dd0b4dddc7b' = 'Block Win32 API calls from Office macros'
    'c1db55ab-c21a-4637-bb3f-a12568109d35' = 'Advanced ransomware protection'
}

function Set-ASRRules {
    param([string]$m)
    $action = if ($m -eq "Aggressive") { "Enabled" } elseif ($m -eq "Audit") { "AuditMode" } else { "Disabled" }
    $ids = $AsrRules.Keys
    $actions = @($action) * $ids.Count
    Log "Setting $($ids.Count) ASR rules → $action"
    Set-MpPreference -AttackSurfaceReductionRules_Ids $ids -AttackSurfaceReductionRules_Actions $actions
}

function Set-DefenderBaseline {
    param([string]$m)
    Log "Configuring Defender baseline ($m)"
    Set-MpPreference -DisableRealtimeMonitoring $false -MAPSReporting Advanced -PUAProtection Enabled -SubmitSamplesConsent Always
    Set-MpPreference -CloudBlockLevel $(if ($m -eq "Revert") { "Default" } else { "High" })
    Set-MpPreference -EnableNetworkProtection $(if ($m -eq "Aggressive") { "Enabled" } elseif ($m -eq "Audit") { "AuditMode" } else { "Disabled" })
    Set-MpPreference -EnableControlledFolderAccess $(if ($m -eq "Aggressive") { "Enabled" } elseif ($m -eq "Audit") { "AuditMode" } else { "Disabled" })
}

function Show-Status {
    Log "=== Current Defender / ASR Status ==="
    $p = Get-MpPreference
    $p | Format-List DisableRealtimeMonitoring,EnableNetworkProtection,EnableControlledFolderAccess,CloudBlockLevel,PUAProtection | Out-String | ForEach-Object { Log $_.Trim() }
    if ($p.AttackSurfaceReductionRules_Ids) {
        for ($i=0; $i -lt $p.AttackSurfaceReductionRules_Ids.Count; $i++) {
            $id = $p.AttackSurfaceReductionRules_Ids[$i]
            $ac = $p.AttackSurfaceReductionRules_Actions[$i]
            Log "$id → $ac ($($AsrRules[$id]))"
        }
    }
}

Log "Starting GenericSecurityHardening.ps1 → Mode: $Mode"

switch ($Mode) {
    "StatusOnly" { Show-Status }
    "Revert"     { Set-ASRRules "Revert"; Set-DefenderBaseline "Revert"; Show-Status }
    default      { Set-ASRRules $Mode; Set-DefenderBaseline $Mode; Show-Status }
}

Log "Completed. Log: $LogPath"
Stop-Transcript | Out-Null