@REM MIT License https://github.com/sergeiown/BackUpMaster/blob/main/LICENSE

@echo off

@REM Reading data from the configuration file
set "config_path=%USERPROFILE%\documents\BackUpMaster\"
for /f "usebackq tokens=1,2 delims==" %%i in ("%config_path%\config.ini") do (
    if "%%i"=="zpath" set "zpath=%%j"
    if "%%i"=="source_path" set source_path=%%j
    if "%%i"=="destination_path" set destination_path=%%j
    if "%%i"=="compression_level" set compression_level=%%j
    if "%%i"=="excluded_extensions" set excluded_extensions=%%j
    if "%%i"=="number_of_copies" set number_of_copies=%%j
)

@REM Creating the backup file name
set "date_time=%DATE:~-4%.%DATE:~3,2%.%DATE:~0,2%_%TIME:~0,2%.%TIME:~3,2%.%TIME:~6,2%"
set "backup_filename=backup_%date_time%.7z"

@REM Executing compression
cls & echo The back up process is in progress... & echo.

if "%excluded_extensions%" == "" (
    "%zpath%7z.exe" a -t7z -mx=%compression_level% -r "%destination_path%\%backup_filename%" "%source_path%\*.*" > "%destination_path%\last_backup_log.txt" 2>&1
) else (
    "%zpath%7z.exe" a -t7z -mx=%compression_level% -r -x!"%excluded_extensions%" "%destination_path%\%backup_filename%" "%source_path%\*.*" > "%destination_path%\last_backup_log.txt" 2>&1
)
echo. >> "%destination_path%\last_backup_log.txt"

findstr /c:"Everything is Ok" "%destination_path%\last_backup_log.txt"
if %errorlevel% equ 0 (
    color 0A
    echo.
    echo Successful backup & echo %date_time% - Successful backup "%destination_path%\%backup_filename%" >> "%destination_path%\%main_backup_log.txt"
    echo.
    timeout /t 2 >nul

    @REM Delete older backup files if necessary
    setlocal enabledelayedexpansion
    for /F "Delims=" %%i in ('DIR /B/O:-N %destination_path%\backup_????.??.??_??.??.??.7z') do (
        set /A "number_of_copies-=1"
        if !number_of_copies! LSS 0 (
            echo. & echo. >> %destination_path%\last_backup_log.txt
            echo Delete according to the rules: %%i & echo Delete according to the rules: %%i >> %destination_path%\last_backup_log.txt
            DEL "%destination_path%\%%i"
            timeout /t 2 >nul
        ) else (
            echo Store  according to the rules: %%i & echo Store  according to the rules: %%i >> %destination_path%\last_backup_log.txt
            timeout /t 1 >nul
        )
    )
    endlocal
) else (
    color 0C
    echo Failed to create a backup. See %destination_path%\last_backup_log.txt for details.
    echo %date_time% - Backup failed     %destination_path%\%backup_filename% >> "%destination_path%\main_backup_log.txt"
    echo.
    timeout /t 2 >nul
    pause
)