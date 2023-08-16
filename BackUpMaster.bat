@echo off
REM Use the universal UTF-8 code
chcp 65001 >nul

REM Checking for the presence of 7z
call check_7z.bat
if "%exitScript%"=="1" (exit /b)

REM Checking for the existence of the configuration file
call write_config.bat
if "%exitScript%"=="1" (exit /b)

REM Reading data from the configuration file and getting the current date and time
call read_config.bat

REM Performing a backup
call compression.bat
timeout /t 2 >nul