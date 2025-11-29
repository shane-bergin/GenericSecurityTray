# GenericSecurityTray

A lightweight Windows 11 system-tray utility that applies a full Microsoft-recommended security hardening baseline using only built-in tools — no third-party dependencies.

## Features
- **Four modes**: Aggressive (block), Audit (monitor), Revert (undo), StatusOnly (report)
- Applies the **latest 19 Microsoft Defender ASR rules** (2025)
- Configures cloud protection, Controlled Folder Access, Network Protection
- Enables advanced auditing, PowerShell logging, firewall hardening
- Fully reversible — Revert restores defaults
- Logs everything to `%ProgramData%\GenericSecurityTray\Logs`

<img width="218" height="135" alt="image" src="https://github.com/user-attachments/assets/cbd00959-b211-45ce-a56b-eb6be9fa3c46" />


## Build
```bash
# Open in Visual Studio → Build → Release
# Or
dotnet build -c Release windows/GenericSecurityTray/src/GenericSecurityTray/GenericSecurityTray.csproj
