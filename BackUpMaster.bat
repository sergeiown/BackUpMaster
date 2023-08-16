@echo off

REM Use the universal UTF-8 code
chcp 65001 >nul

REM Checking for the presence of 7z
call check_7z.bat
if "%exitScript%"=="1" (exit /b)

REM Checking for the existence of the configuration file
set "backup_call=1"
call write_config.bat
if "%exitScript%"=="1" (exit /b)

REM Performing a backup
call compression.bat