@echo off
set "targetPath=%~dp0BackUpMaster.exe"
set "iconPath=%~dp0BackUpMaster.ico"
set "shortcutPath=%startupFolder%\BackUpMaster.lnk"
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "config_path=%USERPROFILE%\documents\BackUpMaster\"

@REM Elevate the script to administrator privileges
whoami /groups | find "S-1-16-12288" > nul
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)

if not exist "%~dp0\BackUpMaster.lnk" (
    @REM Create a shortcut
    powershell.exe -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%startupFolder%\BackUpMaster.lnk'); $Shortcut.TargetPath = '%targetPath%'; $Shortcut.IconLocation = '%iconPath%'; $Shortcut.Save()"
    powershell.exe -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%config_path%\BackUpMaster.lnk'); $Shortcut.TargetPath = '%targetPath%'; $Shortcut.IconLocation = '%iconPath%'; $Shortcut.Save()"
    exit /b
) else (
    @REM Delete existing shortcut
    del "%startupFolder%\BackUpMaster.lnk"
    del "%config_path%\BackUpMaster.lnk"
    exit /b
)

