@echo off

if not exist %USERPROFILE%\documents\BackUpMaster\config.ini (
    :rewrite
    setlocal enabledelayedexpansion
    
    set "culture=en-US"
    set "exitScript=0"
    set "7zPath="
    set "source_path="
    set "destination_path="
    set /a "compression_level=1"
    set "excluded_extensions="
    set "number_of_copies="
    set "startupFolder=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup"
    set "config_path=%USERPROFILE%\documents\BackUpMaster\"

    REM Search for 7-Zip in Program Files and Program Files (x86)
    for %%f in ("%ProgramFiles%\7-Zip\7z.exe" "%ProgramFiles(x86)%\7-Zip\7z.exe") do (
        set "7zPath=%%~dpf"
        goto found
    )

    :found
    if "!7zPath!"=="" (
        echo 7-Zip was not found.
        echo.
        echo Please download it from: https://www.7-zip.org/download.html
        echo.
        pause
        set "exitScript=1"
        exit /b
    ) else (
        "!7zPath!7z.exe" | findstr /i "7-Zip"
        @REM timeout /t 2 >nul & cls
    )

    @REM Request data from the user:

    @REM Path to BackUpMaster.exe
    :input_BackUpMaster_location
    cls & echo Path to the BackUpMaster.exe^:
    set "folderSelection="
    for /f "delims=" %%d in ('powershell -Command "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('%culture%'); Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = 'Path to the BackUpMaster.exe:'; $f.Language = $culture; $f.ShowDialog(); $f.SelectedPath"') do set "folderSelection=%%d"
    if not exist "!folderSelection!\BackUpMaster.exe" (
        goto input_BackUpMaster_location
    ) else (
        set "BackUpMaster_location=!folderSelection!"
        cls & echo Path to the BackUpMaster.exe: !BackUpMaster_location!
        timeout /t 2 >nul
    )
    
    @REM Path to the source files
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

    @REM Path to the destination files
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

    @REM Compression level
    cls & choice /c 123456789 /n /m "Enter the compression level (1-9, where 9 - the best, but the slowest): "
    set "compression_level=!errorlevel!"
    timeout /t 1 >nul

    cls & echo Enter the file extensions to be excluded ^(separated by space, e.g.^: mp3 docx^) or leave the line blank:
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
    timeout /t 1 >nul

    @REM Number of backups
    cls & choice /c 12345 /n /m "Enter the number of backups to keep (1 - 5): "
    set "number_of_copies=!errorlevel!"
    timeout /t 1 >nul

    REM Create the config_path if it doesn't exist
    if not exist "!config_path!" (
        mkdir "!config_path!"
    )

    (
        echo BackUpMaster_location=!BackUpMaster_location!
        echo zpath=!7zPath!
        echo source_path=!source_path!
        echo destination_path=!destination_path!
        echo compression_level=!compression_level!
        echo excluded_extensions=!excluded_extensions!
        echo number_of_copies=!number_of_copies!
    ) > !config_path!\config.ini

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

    if not exist "!config_path!\BackUpMaster.lnk" (
        cls & choice /c YN /n /m "Do you want to turn on BackUpMaster autorun? (Y - Yes, N - No): "
        if "!errorlevel!"=="1" (
            call %~dp0autorun.bat
        ) else (
            exit /b
        )
    ) else (
        cls & choice /c YN /n /m "Do you want to disable BackUpMaster autorun? (Y - Yes, N - No): "
        if "!errorlevel!"=="1" (
            call %~dp0autorun.bat
        ) else (
            exit /b
        )
    )

    endlocal

) else ( 
    @REM Suggestion to overwrite the configuration if a file is available  
    setlocal enabledelayedexpansion
    set "config_path=%USERPROFILE%\documents\BackUpMaster\"

    cls & color 07
    timeout /t 2 >nul

    @REM Reading data from the configuration file
    echo Copyright ^(c^) 2023 Serhii I. Myshko
    echo.
    echo.
    echo Current configuration^:
    echo.
    for /f "usebackq tokens=1,2 delims==" %%i in ("!config_path!\config.ini") do (
        if "%%i"=="BackUpMaster_location" echo BackUpMaster path    - %%j
        if "%%i"=="zpath" echo 7-zip path           - %%j
        if "%%i"=="source_path" echo Source path          - %%j
        if "%%i"=="destination_path" echo Destination path     - %%j
        if "%%i"=="compression_level" echo Compression level    - %%j
        if "%%i"=="excluded_extensions"  echo Excluded extensions  - %%j
        if "%%i"=="number_of_copies" echo Number of copies     - %%j
    )
    if exist "!config_path!\BackUpMaster.lnk" (
        echo BackUpMaster autorun - On
    ) else (echo BackUpMaster autorun - Off)
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
