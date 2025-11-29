#define MyAppName       "Generic Security Tray"
#define MyAppVersion    "1.0"
#define MyAppPublisher  "Shane Bergin"
#define MyAppURL        "https://github.com/shane-bergin/GenericSecurityTray"

[Setup]
AppId={{7D80D301-B254-4D10-A079-5B63DEBDD6A6}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}

DefaultDirName={autopf}\GenericSecurityTray
DefaultGroupName=Generic Security Tray

OutputDir=.
OutputBaseFilename=GenericSecurityTray_Setup_v1.0
Compression=lzma
SolidCompression=yes
PrivilegesRequired=admin

[Files]
Source: "windows\GenericSecurityTray\src\GenericSecurityTray\bin\Release\net8.0-windows\*"; \
        DestDir: "{app}"; Flags: ignoreversion recursesubdirs
Source: "windows\GenericSecurityTray\scripts\*"; \
        DestDir: "{app}\scripts"; Flags: ignoreversion recursesubdirs

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\GenericSecurityTray.exe"
Name: "{autostartup}\{#MyAppName}"; Filename: "{app}\GenericSecurityTray.exe"; WorkingDir: "{app}"

[Run]
Filename: "{app}\GenericSecurityTray.exe"; Description: "Launch {#MyAppName}"; \
          Flags: nowait postinstall skipifsilent