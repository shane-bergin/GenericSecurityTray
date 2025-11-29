# GenericSecurityTray

A lightweight Windows 11 system-tray utility that applies a full Microsoft-recommended security hardening baseline using only built-in tools — no third-party dependencies.

## Features
- **Four modes**: Aggressive (block), Audit (monitor), Revert (undo), StatusOnly (report)
- Applies the **latest 19 Microsoft Defender ASR rules** (2025)
- Configures cloud protection, Controlled Folder Access, Network Protection
- Enables advanced auditing, PowerShell logging, firewall hardening
- Fully reversible — Revert restores defaults
- Logs everything to `%ProgramData%\GenericSecurityTray\Logs`

## Screenshot
*(Add tray icon + menu screenshot here after first build)*

## Build
```bash
# Open in Visual Studio → Build → Release
# Or
dotnet build -c Release windows/GenericSecurityTray/src/GenericSecurityTray/GenericSecurityTray.csproj