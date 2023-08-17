@echo off

if not exist config.ini (
    @REM Request data from the user
    :rewrite
    setlocal enabledelayedexpansion
    
    set "culture=en-US"
    set "source_path="
    set "destination_path="
    set /a "compression_level=1"
    set "excluded_extensions="
    set "number_of_copies="
    set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
        
    :input_source_path
    cls & echo Path to the files you want to back up^:
    set "folderSelection="
    for /f "delims=" %%d in ('powershell -Command "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('%culture%'); Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = 'Path to the files you want to back up:'; $f.Language = $culture; $f.ShowDialog(); $f.SelectedPath"') do set "folderSelection=%%d"
    set "source_path=!folderSelection!"
    if not exist "!source_path!" (
        goto input_source_path
    )
    cls & echo Path to the files you want to back up: !source_path!
    timeout /t 2 >nul


    :input_destination_path
    cls & echo Path to the backup results^:
    set "folderSelection="
    for /f "delims=" %%d in ('powershell -Command "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('%culture%'); Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = 'Path to the backup results:'; $f.Language = $culture; $f.ShowDialog(); $f.SelectedPath"') do set "folderSelection=%%d"
    set "destination_path=!folderSelection!"
        if not exist "!destination_path!" (
        goto input_destination_path
    )
    cls & echo Path to the backup results: !destination_path!
    timeout /t 2 >nul

    cls & choice /c 123456789 /n /m "Enter the compression level (1-9, where 9 - the best, but the slowest): "
    set "compression_level=!errorlevel!"
    timeout /t 2 >nul

    cls & echo Enter the file extensions to be excluded during compression ^(separated by space, e.g.^: txt mp3 docx^):
    echo.
    set /p raw_extensions=
    set "excluded_extensions="
    for %%a in (!raw_extensions!) do (
        if defined excluded_extensions (
            set "excluded_extensions=!excluded_extensions! -x^!^"*.%%a^""
        ) else (
            set "excluded_extensions="*.%%a""
        )
    )
    timeout /t 2 >nul

    cls & choice /c 12345 /n /m "Enter the number of backups to keep (1 - 5): "
    set "number_of_copies=!errorlevel!"
    timeout /t 2 >nul

    (
        echo source_path=!source_path!
        echo destination_path=!destination_path!
        echo compression_level=!compression_level!
        echo excluded_extensions=!excluded_extensions!
        echo number_of_copies=!number_of_copies!
    ) > config.ini

    if %errorlevel% neq 0 (
        color 0C
        cls & echo An error occurred while writing to the config.ini file
        timeout /t 2 >nul
        set "exitScript=1"
        exit /b
    ) else (
        color 0A
        cls & echo Configuration data is successfully written to the config.ini file
        timeout /t 2 >nul
    )
    
    @REM Add and remove BackUpMaster autorun
    color 07

    if not exist "%~dp0\BackUpMaster.lnk" (
        cls & choice /c YN /n /m "Do you want to turn on BackUpMaster autorun? (Y - Yes, N - No): "
        if "!errorlevel!"=="1" (
            call autorun.bat
        ) else (
            exit /b
        )
    ) else (
        cls & choice /c YN /n /m "Do you want to disable BackUpMaster autorun? (Y - Yes, N - No): "
        if "!errorlevel!"=="1" (
            call autorun.bat
        ) else (
            exit /b
        )
    )

    endlocal

) else ( 
    @REM Suggestion to overwrite the configuration if a file is available  
    setlocal enabledelayedexpansion
    cls & color 07
    timeout /t 1 >nul

    @REM Reading data from the configuration file
    echo Copyright (c) 2023 Serhii I. Myshko
    echo.
    echo.
    echo Current configuration^:
    echo.
    for /f "usebackq tokens=1,2 delims==" %%i in ("config.ini") do (
        if "%%i"=="source_path" echo Source path          : %%j
        if "%%i"=="destination_path" echo Destination path     : %%j
        if "%%i"=="compression_level" echo Compression level    : %%j
        if "%%i"=="excluded_extensions"  echo Excluded extensions  : %%j
        if "%%i"=="number_of_copies" echo Number of copies     : %%j
    )
    if exist "%~dp0\BackUpMaster.lnk" (
        echo BackUpMaster autorun : On
    ) else (echo BackUpMaster autorun : Off)
    echo.
    echo.

    choice /c YN /n /m "Create a new configuration? (Y - Yes, N - No): "
    if "!errorlevel!"=="1" (
        endlocal
        goto :rewrite
    ) else (
        endlocal
        set "exitScript=1"
        exit /b
    )
)
