@echo off

setlocal enabledelayedexpansion

set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
set "config_path=%USERPROFILE%\documents\BackUpMaster"
set "culture=en-US"

if not exist "%config_path%\BackUpMaster.lnk" (

    for /f "usebackq tokens=1,2 delims==" %%i in ("%config_path%\config.ini") do (
    if "%%i"=="BackUpMaster_location" set "BackUpMaster_location=%%j"
    )

    @REM @REM Elevate the script to administrator privileges
    whoami /groups | find "S-1-16-12288" > nul
    if %errorlevel% neq 0 (
        powershell -Command "Start-Process '%0' -Verb RunAs"
        exit /b
    )
    
    @REM Create a shortcut
    powershell.exe -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%startupFolder%\BackUpMaster.lnk'); $Shortcut.TargetPath = '!BackUpMaster_location!\BackUpMaster.exe'; $Shortcut.IconLocation = '!BackUpMaster_location!\BackUpMaster.ico,0'; $Shortcut.Save()"
    powershell.exe -Command "$WshShell = New-Object -ComObject WScript.Shell; $Shortcut = $WshShell.CreateShortcut('%config_path%\BackUpMaster.lnk'); $Shortcut.TargetPath = '!BackUpMaster_location!\BackUpMaster.exe'; $Shortcut.IconLocation = '!BackUpMaster_location!\\BackUpMaster.ico,0'; $Shortcut.Save()"
    timeout /t 2 >nul
) else (
    @REM Delete existing shortcut
    del "%startupFolder%\BackUpMaster.lnk"
    del "%config_path%\BackUpMaster.lnk"
    timeout /t 2 >nul
)