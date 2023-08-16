@echo off

REM Check if script is running as administrator
whoami /groups | find "S-1-16-12288" > nul
if %errorlevel% neq 0 (
    powershell -Command "Start-Process '%0' -Verb RunAs"
    exit /b
)
