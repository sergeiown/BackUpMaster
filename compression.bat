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
set "backup_filename=backup_%year%%month%%day%_%hour%%minute%.zip"

REM Executing compression
7z a -tzip -mx=%compression_level% -xr!%excluded_extensions% "%destination_path%\%backup_filename%" "%source_path%\*.*"

REM Verify and log the back up result
if %errorlevel% equ 0 (
    echo Successful backup & echo %date% %time% Successful backup (%destination_path%\%backup_filename%) >> "%destination_path%\backup_log.txt"
    timeout /t 2 >nul
) else (
    echo Backup failed & echo %date% %time% Backup failed (%destination_path%\%backup_filename%) >> "%destination_path%\backup_log.txt"
    echo %date% %time% Compression error: %errorlevel% >> "%destination_path%\backup_log.txt"
    timeout /t 2 >nul
)