@echo off

@REM @REM Elevate the script to administrator privileges
@REM whoami /groups | find "S-1-16-12288" > nul
@REM if %errorlevel% neq 0 (
@REM     powershell -Command "Start-Process '%0' -Verb RunAs"
@REM     exit /b
@REM )

set "culture=en-US"
set "shortcutPath=%startupFolder%\BackUpMaster.lnk"
set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "config_path=%USERPROFILE%\documents\BackUpMaster\"

if not exist "%config_path%\BackUpMaster.lnk" (

    if not exist "%config_path%\BackUpMaster.exe" (
    :input_BackUpMaster_location
    cls & echo Path to the BackUpMaster.exe^:
    set "folderSelection="
    for /f "delims=" %%d in ('powershell -Command "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('%culture%'); Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = 'Path to the files you want to back up:'; $f.Language = $culture; $f.ShowDialog(); $f.SelectedPath"') do set "folderSelection=%%d"
    set "BackUpMaster_location=%folderSelection%"
    if not exist "%BackUpMaster_location%" (
        goto input_BackUpMaster_location
    )
    cls & echo Path to the BackUpMaster.exe: %BackUpMaster_location%
    ) else (
        set "BackUpMaster_location=%config_path%"
    )


    set "targetPath=%BackUpMaster_location%\BackUpMaster.exe"
    set "iconPath=%BackUpMaster_location%\BackUpMaster.ico"
    timeout /t 2 >nul

    @REM Create a shortcut
    powershell.exe -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%startupFolder%\BackUpMaster.lnk'); $Shortcut.TargetPath = '%targetPath%'; $Shortcut.IconLocation = '%iconPath%,0'; $Shortcut.Save()"
    powershell.exe -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%config_path%\BackUpMaster.lnk'); $Shortcut.TargetPath = '%targetPath%'; $Shortcut.IconLocation = '%iconPath%,0'; $Shortcut.Save()"
    exit /b
) else (
    @REM Delete existing shortcut
    del "%startupFolder%\BackUpMaster.lnk"
    del "%config_path%\BackUpMaster.lnk"
    exit /b
)