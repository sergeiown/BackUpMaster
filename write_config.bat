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

    cls & echo Path to the files to be compressed^:
    set "folderSelection="
    for /f "delims=" %%d in ('powershell -Command "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('%culture%'); Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = 'Path to the files to be compressed:'; $f.Language = $culture; $f.ShowDialog(); $f.SelectedPath"') do set "folderSelection=%%d"
    set "source_path=!folderSelection!"
    cls & echo Path to the files to be compressed: !source_path!
    timeout /t 2 >nul

    cls & echo Path for compression results^:
    set "folderSelection="
    for /f "delims=" %%d in ('powershell -Command "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('%culture%'); Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = 'Path for compression results:'; $f.Language = $culture; $f.ShowDialog(); $f.SelectedPath"') do set "folderSelection=%%d"
    set "destination_path=!folderSelection!"
    cls & echo Path for compression results: !destination_path!
    timeout /t 2 >nul

    cls & choice /c 123456789 /n /m "Enter the compression level (1-9, where 9 - the best, but the slowest): "
    set "compression_level=%errorlevel%"
    timeout /t 2 >nul

    cls & echo Enter the file extensions to be excluded during compression ^(separated by space, e.g.^: txt mp3 log^)^: & set /p excluded_extensions=
    timeout /t 2 >nul

    (
        echo source_path=!source_path!
        echo destination_path=!destination_path!
        echo compression_level=!compression_level!
        echo excluded_extensions=!excluded_extensions!
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
    set "exitScript=1"
    exit /b
) else ( 
    REM Suggestion to overwrite the configuration if a file is available  
    setlocal enabledelayedexpansion
    cls & choice /c 12 /n /m "Create a new configuration? (1 - Yes, 2 - No): "
    if "!errorlevel!"=="1" (
        endlocal
        goto :rewrite
    ) else (
        endlocal
        set "exitScript=1"
        exit /b
    )
)
