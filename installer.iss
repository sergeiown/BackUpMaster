#define MyAppName "BackUpMaster"
#define MyAppVersion "1.0"
#define MyAppPublisher "Serhii I. Myshko"
#define MyAppURL "https://github.com/sergeiown/BackUpMaster"
#define MyAppExeName "backupmaster.bat"

[Setup]
AppId={{0C2A861E-B38F-4B0C-B5C1-692678382B90}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={userdocs}\BackUpMaster
DefaultGroupName=BackUpMaster
AllowNoIcons=no
LicenseFile=D:\Projects\BackUpMaster\LICENSE
InfoAfterFile=infoafter.txt
OutputBaseFilename=BackUpMasterInstall
SetupIconFile=D:\Projects\BackUpMaster\BackUpMaster.ico
Compression=lzma
SolidCompression=yes
WizardStyle=classic
PrivilegesRequired=lowest

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"
Name: "ukrainian"; MessagesFile: "compiler:Languages\Ukrainian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "D:\Projects\BackUpMaster\autorun.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\BackUpMaster\backupmaster.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\BackUpMaster\backupmaster.ico"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\BackUpMaster\compression.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\BackUpMaster\config.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\BackUpMaster\language.bat"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\BackUpMaster\english.msg"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\BackUpMaster\russian.msg"; DestDir: "{app}"; Flags: ignoreversion
Source: "D:\Projects\BackUpMaster\ukrainian.msg"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\{#MyAppName}"; Filename: "{app}\BackUpMaster.bat"; IconFilename: "{app}\BackUpMaster.ico"
Name: "{group}\{#MyAppName} Settings"; Filename: "{app}\Config.bat"; IconFilename: "{app}\BackUpMaster.ico"
Name: "{group}\{cm:ProgramOnTheWeb,{#MyAppName}}"; Filename: "{#MyAppURL}"
Name: "{group}\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; IconFilename: "{app}\BackUpMaster.ico"

Name: "{userstartmenu}\BackUpMaster\{#MyAppName}"; Filename: "{app}\BackUpMaster.bat"; IconFilename: "{app}\BackUpMaster.ico"
Name: "{userstartmenu}\BackUpMaster\{#MyAppName} Settings"; Filename: "{app}\Config.bat"; IconFilename: "{app}\BackUpMaster.ico"
Name: "{userstartmenu}\BackUpMaster\{cm:UninstallProgram,{#MyAppName}}"; Filename: "{uninstallexe}"; IconFilename: "{app}\BackUpMaster.ico"

Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; IconFilename: "{app}\BackUpMaster.ico"; Tasks: desktopicon
Name: "{autodesktop}\{#MyAppName} Settings"; Filename: "{app}\Config.bat"; IconFilename: "{app}\BackUpMaster.ico"; Tasks: desktopicon

[Uninstall]
DisplayName={#MyAppName}
AppId={{0C2A861E-B38F-4B0C-B5C1-692678382B90}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
UninstallDisplayIcon={app}\BackUpMaster.ico
UninstallString="{app}\{#MyAppExeName}" /uninstall

[UninstallDelete]
Type: files; Name: "{userdocs}\BackUpMaster\*"
Type: dirifempty; Name: "{userdocs}\BackUpMaster\"
