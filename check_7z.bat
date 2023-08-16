@echo off

REM Checking for the presence of 7z using 'where' command
where 7z >nul 2>&1
if errorlevel 1 (
    REM Checking for the presence of 7z at the specific path
    if exist "C:\Program Files\7-Zip" (
        REM Check if script is running as administrator
        whoami /groups | find "S-1-16-12288" > nul
        if %errorlevel% neq 0 (
            REM Elevate script to administrator privileges
            powershell -Command "Start-Process '%0' -Verb RunAs"
            exit /b
        )
        REM Append the 7-Zip directory to the PATH environment variable
        setx PATH "%PATH%;C:\Program Files\7-Zip\" /M
        goto showversion
    ) else (
        echo 7z program not found at C:\Program Files\7-Zip\.
        echo.
        echo Please download it from: https://www.7-zip.org/download.html
        echo.
        set "exitScript=1"
        pause
        exit /b
    )
) else (
    goto showversion
)

REM Getting 7z version
:showversion
7z | findstr /i "7-Zip"
pause
timeout /t 1 >nul