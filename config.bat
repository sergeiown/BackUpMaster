@REM MIT License https://github.com/sergeiown/BackUpMaster/blob/main/LICENSE

@echo off

@REM Automatic language selection
call %~dp0language.bat

if not exist %USERPROFILE%\documents\BackUpMaster\config.ini (
    :rewrite
    setlocal enabledelayedexpansion
    cls
    
    set "exitScript=0"
    set "7zPath="
    set "source_path="
    set "destination_path="
    set /a "compression_level=1"
    set "excluded_extensions="
    set "number_of_copies="
    set "config_path=%USERPROFILE%\documents\BackUpMaster"

    REM *** Search for 7-Zip in Program Files and Program Files (x86) ***
    for %%f in ("%ProgramFiles%\7-Zip\7z.exe" "%ProgramFiles(x86)%\7-Zip\7z.exe") do (
        set "7zPath=%%~dpf"
        goto found
    )

    :found
    if "!7zPath!"=="" (
        echo !msg_1!
        echo.
        echo !msg_2!
        echo.
        pause
        set "exitScript=1"
        exit /b
    ) else (
        "!7zPath!7z.exe" | findstr /i "7-Zip"
        @REM timeout /t 2 >nul & cls
    )

    @REM *** Request data from the user: ***

    @REM Path to BackUpMaster
    
    if exist "!folderSelection!\BackUpMaster.bat" (
        set "BackUpMaster_location=!folderSelection!"
        goto input_BackUpMaster_location
    ) else (
        set "BackUpMaster_location="
        goto input_BackUpMaster_location
    )
    

    :input_BackUpMaster_location
    if "!BackUpMaster_location!"=="" (
        cls & echo !msg_03!
        set "folderSelection="
        for /f "delims=" %%d in ('powershell -Command "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('!culture!'); Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = '!msg_03!'; $f.Language = $culture; $f.ShowDialog(); $f.SelectedPath"') do set "folderSelection=%%d"
        if not exist "!folderSelection!\BackUpMaster.bat" (
            goto input_BackUpMaster_location
        ) else (
            color 0A
            set "BackUpMaster_location=!folderSelection!"
            cls & echo !msg_03! !BackUpMaster_location!
            echo.
            echo !msg_04!
            timeout /t 2 >nul
        )
    ) else (
        color 0A
        timeout /t 2 >nul
        cls & echo !msg_05! !BackUpMaster_location!
        echo.
        echo !msg_04!
        timeout /t 4 >nul
    )
    
    @REM Path to the source files
    :input_source_path
    color 07
    cls & echo !msg_06!
    set "folderSelection="
    for /f "delims=" %%d in ('powershell -Command "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('!culture!'); Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = '!msg_06!'; $f.Language = $culture; $f.ShowDialog(); $f.SelectedPath"') do set "folderSelection=%%d"
    set "source_path=!folderSelection!"
    if not exist "!source_path!" (
        goto input_source_path
    )
    cls & echo !msg_06! !source_path!
    timeout /t 2 >nul

    @REM Path to the destination files
    :input_destination_path
    cls & echo !msg_07!
    set "folderSelection="
    for /f "delims=" %%d in ('powershell -Command "$culture = [System.Globalization.CultureInfo]::CreateSpecificCulture('!culture!'); Add-Type -AssemblyName System.Windows.Forms; $f = New-Object Windows.Forms.FolderBrowserDialog; $f.Description = '!msg_07!'; $f.Language = $culture; $f.ShowDialog(); $f.SelectedPath"') do set "folderSelection=%%d"
    set "destination_path=!folderSelection!"
        if not exist "!destination_path!" (
        goto input_destination_path
    )
    cls & echo !msg_07! !destination_path!
    timeout /t 2 >nul

    @REM Compression level
    cls & choice /c 123456789 /n /m "!msg_08! "
    set "compression_level=!errorlevel!"
    timeout /t 1 >nul

    cls & echo !msg_09!
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
    cls & choice /c 12345 /n /m "!msg_10! "
    set "number_of_copies=!errorlevel!"
    timeout /t 1 >nul

    @REM *** Create the config_path if it does not exist and write the config.ini file ***
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
        cls & echo !msg_11!
        timeout /t 2 >nul
        set "exitScript=1"
        exit /b
    ) else (
        color 0A
        cls & echo !msg_12!
        timeout /t 2 >nul
    )
    
    @REM *** Add and remove BackUpMaster autorun ***
    color 07

    if not exist "!config_path!\BackUpMaster.lnk" (
        cls & choice /c YN /n /m "!msg_13! "
        if "!errorlevel!"=="1" (
            call %~dp0autorun.bat
        ) else (
            exit /b
        )
    ) else (
        cls & choice /c YN /n /m "!msg_14! "
        if "!errorlevel!"=="1" (
            call %~dp0autorun.bat
        ) else (
            exit /b
        )
    )

    endlocal

) else ( 
    setlocal enabledelayedexpansion
    set "config_path=%USERPROFILE%\documents\BackUpMaster"

    cls & color 07
    timeout /t 2 >nul

    @REM *** Show logo and read data from the configuration file ***
    echo     ____             __      __  __         __  ___           __           
    echo    / __ ^)____ ______/ /__   / / / /___     /  ^|/  /___ ______/ /____  _____
    echo   / __  / __ `/ ___/ //_/  / / / / __ \   / /^|_/ / __ `/ ___/ __/ _ \/ ___/
    echo  / /_/ / /_/ / /__/ ,^<    / /_/ / /_/ /  / /  / / /_/ ^(__  ^) /_/  __/ /    
    echo /_____/\__,_/\___/_/^|_^|   \____/ .___/  /_/  /_/\__,_/____/\__/\___/_/     
    echo                               /_/                                          
    echo Copyright ^(c^) 2023 Serhii I. Myshko
    timeout /t 1 >nul
    echo.
    echo.
    echo !msg_15!
    echo.
    for /f "usebackq tokens=1,2 delims==" %%i in ("!config_path!\config.ini") do (
        if "%%i"=="BackUpMaster_location" echo !msg_16! %%j
        if "%%i"=="zpath" echo !msg_17! %%j
        if "%%i"=="source_path" echo !msg_18! %%j
        if "%%i"=="destination_path" echo !msg_19! %%j
        if "%%i"=="compression_level" echo !msg_20! %%j
        if "%%i"=="excluded_extensions"  echo !msg_21! %%j
        if "%%i"=="number_of_copies" echo !msg_22! %%j
    )
    if exist "!config_path!\BackUpMaster.lnk" (
        echo !msg_23!
    ) else (
        echo !msg_24!
    )
    echo.
    echo.

    @REM *** Suggestion to overwrite the configuration if the file is available ***
    choice /c YN /n /m "!msg_25! "
    if "!errorlevel!"=="1" (
        endlocal
        goto :rewrite
    ) else (
        endlocal
        set "exitScript=1"
        exit /b
    )
)
