@echo off

set "7zPath="
set "123=%7zPath%"
set "exitScript=0"

setlocal enabledelayedexpansion

REM Search for 7-Zip in Program Files and Program Files (x86)
for %%f in ("%ProgramFiles%\7-Zip\7z.exe" "%ProgramFiles(x86)%\7-Zip\7z.exe") do (
    set "7zPath=%%~dpf"
    goto found
)

:found
if "!7zPath!"=="" (
    echo 7-Zip was not found.
    echo.
    echo Please download it from: https://www.7-zip.org/download.html
    echo.
    pause
    set "exitScript=1"
    exit /b
) else (
    echo !7zPath!
    pause
    "!7zPath!7z.exe" | findstr /i "7-Zip"
    timeout /t 2 >nul & cls
)