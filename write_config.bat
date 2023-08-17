@echo off

if not exist config.txt (
    REM Request data from the user
    :rewrite
    setlocal enabledelayedexpansion
    set "culture=en-US"
    set "source_path="
    set "destination_path="
    set /a "compression_level=1"
    set "excluded_extensions="

    cls & echo Path to the files you want to back up^:
    set "folderSelection="
    for /f "delims=" %%d in ('powershell -Command "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('%culture%'); Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = 'Path to the files you want to back up:'; $f.Language = $culture; $f.ShowDialog(); $f.SelectedPath"') do set "folderSelection=%%d"
    set "source_path=!folderSelection!"
    cls & echo Path to the files you want to back up: !source_path!
    timeout /t 2 >nul

    cls & echo Path to the backup results^:
    set "folderSelection="
    for /f "delims=" %%d in ('powershell -Command "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('%culture%'); Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = 'Path to the backup results:'; $f.Language = $culture; $f.ShowDialog(); $f.SelectedPath"') do set "folderSelection=%%d"
    set "destination_path=!folderSelection!"
    cls & echo Path to the backup results: !destination_path!
    timeout /t 2 >nul

    cls & choice /c 123456789 /n /m "Enter the compression level (1-9, where 9 - the best, but the slowest): "
    set "compression_level=%errorlevel%"
    timeout /t 2 >nul

    cls & echo Enter the file extensions to be excluded during compression ^(separated by space, e.g.^: txt mp3 docx^)^: & echo.
    set /p excluded_extensions=
    timeout /t 2 >nul

    cls & choice /c 12345 /n /m "Enter the number of backups to keep (1 - 5): "
    set "number_of_copies=%errorlevel%"
    timeout /t 2 >nul

    (
        echo source_path=!source_path!
        echo destination_path=!destination_path!
        echo compression_level=!compression_level!
        echo excluded_extensions=!excluded_extensions!
        echo number_of_copies=!number_of_copies!
    ) > config.txt

    if %errorlevel% neq 0 (
        color 0C
        cls & echo An error occurred while writing to the config.txt file
        timeout /t 2 >nul
    ) else (
        color 0A
        cls & echo Configuration data is successfully written to the config.txt file
        timeout /t 2 >nul
    )

    endlocal
) else ( 
    REM Suggestion to overwrite the configuration if a file is available  
    if "%backup_call%"=="1" (exit /b)
    setlocal enabledelayedexpansion
    cls & color 07
    choice /c 12 /n /m "Create a new configuration? (1 - Yes, 2 - No): "
    if "!errorlevel!"=="1" (
        endlocal
        goto :rewrite
    ) else (
        endlocal
        set "exitScript=1"
        exit /b
    )
)
