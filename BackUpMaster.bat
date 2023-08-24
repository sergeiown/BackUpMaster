@REM MIT License https://github.com/sergeiown/BackUpMaster/blob/main/LICENSE

@echo off

cls & color 07

@REM Checking for the existence of the configuration file
if not exist %USERPROFILE%\documents\BackUpMaster\config.ini (
call %~dp0write_config.bat
if "%exitScript%"=="1" (exit /b)
)

@REM Performing a backup
call %~dp0compression.bat