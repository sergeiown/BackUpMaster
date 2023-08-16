@echo off

REM Reading data from the configuration file
for /f "usebackq tokens=1,2 delims==" %%i in ("config.txt") do (
    if "%%i"=="source_path" set source_path=%%j
    if "%%i"=="destination_path" set destination_path=%%j
    if "%%i"=="compression_level" set compression_level=%%j
    if "%%i"=="excluded_extensions" set excluded_extensions=%%j
)

REM Getting the current date and time
for /f "tokens=1-4 delims=/ " %%a in ('date /t') do (
    set "day=%%a"
    set "month=%%b"
    set "year=%%c"
)
for /f "tokens=1-2 delims=: " %%a in ('time /t') do (
    set "hour=%%a"
    set "minute=%%b"
)

REM Creating the backup file name
set "backup_filename=backup_%year%%month%%day%_%hour%.%minute%.zip"

REM Executing compression

cls & echo The back up process is in progress... & echo.
7z a -tzip -mx=%compression_level% -xr!%excluded_extensions% "%destination_path%%backup_filename%" "%source_path%\*.*" > "%destination_path%\last_backup_log.txt" 2>&1

findstr /c:"Everything is Ok" "%destination_path%\last_backup_log.txt"
if %errorlevel% equ 0 (
    color 0A
    echo.
    echo Successful backup & echo %day%%month%%year% %hour%:%minute% - Successful backup %destination_path%%backup_filename% >> "%destination_path%\main_backup_log.txt"
    timeout /t 2 >nul
) else (
    color 0C
    echo Failed to create a backup. See %destination_path%last_backup_log.txt for details.
    echo %day%%month%%year% %hour%:%minute% - Backup failed %destination_path%%backup_filename% >> "%destination_path%\main_backup_log.txt"
    echo.
    timeout /t 2 >nul
    pause
)