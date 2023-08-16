@echo off

REM Creating the backup file name
set "backup_filename=backup_%year%%month%%day%_%hour%%minute%.zip"

REM Executing compression
7z a -tzip -mx=%compression_level% -xr!%excluded_extensions% "%destination_path%\%backup_filename%" "%source_path%\*.*"

REM Verify and log the compression result
if %errorlevel% equ 0 (
    echo %date% %time% Successful backup (%destination_path%\%backup_filename%) >> "%destination_path%\compression_log.txt"
) else (
    echo %date% %time% Backup failed (%destination_path%\%backup_filename%) >> "%destination_path%\compression_log.txt"
    echo %date% %time% Compression error: %errorlevel% >> "%destination_path%\compression_log.txt"
)