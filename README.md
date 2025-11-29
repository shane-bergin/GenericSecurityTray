# GenericSecurityTray

A lightweight Windows 11 system-tray utility that applies a full Microsoft-recommended security hardening baseline using only built-in tools — no third-party dependencies.

Please refer to Microsoft's Documentation linked below, and familiarize with the Attack Surface Reduction Rules Reference

https://learn.microsoft.com/en-us/defender-endpoint/attack-surface-reduction-rules-reference

## Features
- **Four modes**: Aggressive (block), Audit (monitor), Revert (undo), StatusOnly (report)
- Applies the **latest 19 Microsoft Defender ASR rules** (2025)
- Configures cloud protection, Controlled Folder Access, Network Protection
- Enables advanced auditing, PowerShell logging, firewall hardening
- Fully reversible — Revert restores defaults
- Logs everything to `%ProgramData%\GenericSecurityTray\Logs`

<img width="218" height="135" alt="image" src="https://github.com/user-attachments/assets/cbd00959-b211-45ce-a56b-eb6be9fa3c46" />

Polices not in place--

<img width="1084" height="536" alt="image" src="https://github.com/user-attachments/assets/498ea5f9-b957-4c42-8ad0-3881ee7e21ee" />


---Agressive Mode Active---
<img width="1092" height="528" alt="image" src="https://github.com/user-attachments/assets/1af64ff7-3fc6-43ef-9f97-61b4f717e7d4" />


If you close out of the tray with agressive mode on and run into difficulties accessing certain applications and are unable to use the Windows Security GUI to make exceptions use the following Powershell commands to remove Agressive baseline policy...

(Caution; the below Powershell snippet will remove all ASR rules.)

*Run Powershell as Adminstrator*

Get-MpPreference | Select-Object -ExpandProperty AttackSurfaceReductionRules_Ids | ForEach-Object { Remove-MpPreference -AttackSurfaceReductionRules_Ids $_ }


## Build
```bash
# Open in Visual Studio → Build → Release
# Or
dotnet build -c Release windows/GenericSecurityTray/src/GenericSecurityTray/GenericSecurityTray.csproj
