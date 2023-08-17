@echo off

REM Use a common color and universal UTF-8 code
color 07 & chcp 65001 >nul

REM Checking for the presence of 7z
call check_7z.bat
if "%exitScript%"=="1" (exit /b)

REM Checking for the existence of the configuration file
if not exist config.ini (
call write_config.bat
if "%exitScript%"=="1" (exit /b)
)

REM Performing a backup
call compression.bat