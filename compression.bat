@REM MIT License https://github.com/sergeiown/BackUpMaster/blob/main/LICENSE

@echo off

@REM Automatic language selection
call %~dp0language.bat

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
cls & echo.
echo %msg_26% & echo.

if "%excluded_extensions%" == "" (
    start "" /b "%zpath%\7z.exe" a -t7z -mx=%compression_level% -r "%destination_path%\%backup_filename%" "%source_path%\*.*" > "%destination_path%\last_backup_log.txt" 2>&1
) else (
    start "" /b "%zpath%\7z.exe" a -t7z -mx=%compression_level% -r -x!"%excluded_extensions%" "%destination_path%\%backup_filename%" "%source_path%\*.*" > "%destination_path%\last_backup_log.txt" 2>&1
)

@REM Displaying the progress bar
setlocal enabledelayedexpansion
:wait_loop
tasklist /fi "imagename eq 7z.exe" | find /i "7z.exe" >nul
if not errorlevel 1 (
    set "progress=!progress!*"
    cls & echo.
    echo %msg_26%
    echo.
    echo !progress!
    timeout /t 2 >nul
    goto wait_loop
)
endlocal

echo. >> "%destination_path%\last_backup_log.txt"

findstr /c:"Everything is Ok" "%destination_path%\last_backup_log.txt" >nul
if %errorlevel% equ 0 (
    color 0A
    cls & echo.
    echo %msg_27% & echo %date_time% - %msg_27% "%destination_path%\%backup_filename%" >> "%destination_path%\%main_backup_log.txt"
    echo.
    timeout /t 2 >nul

    @REM Delete older backup files if necessary
    setlocal enabledelayedexpansion
    for /F "Delims=" %%i in ('DIR /B/O:-N %destination_path%\backup_????.??.??_??.??.??.7z') do (
        set /A "number_of_copies-=1"
        if !number_of_copies! LSS 0 (
            echo %msg_28% %%i & echo %msg_28% %%i >> %destination_path%\last_backup_log.txt
            DEL "%destination_path%\%%i"
            timeout /t 2 >nul
        ) else (
            echo %msg_29% %%i & echo %msg_29% %%i >> %destination_path%\last_backup_log.txt
            timeout /t 1 >nul
        )
    )
    endlocal
) else (
    color 0C
    cls & echo.
    echo %msg_30% %destination_path%\last_backup_log.txt
    echo %date_time% - %msg_31% "%destination_path%\%backup_filename%" >> "%destination_path%\main_backup_log.txt"
    echo.
    timeout /t 2 >nul
    pause
)