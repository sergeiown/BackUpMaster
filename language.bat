@REM Automatic language selection according to the system language with the subsequent use of the universal UTF-8 code

for /f %%A in ('wmic os get locale ^| find "0"') do set "LOCALE=%%A"
if "%LOCALE%"=="0422" (
    chcp 65001 >nul
    set "file_name=ukrainian.msg"
    echo.
    cls
) else if "%LOCALE%"=="0419" (
    chcp 65001 >nul
    set "file_name=russian.msg"
    echo.
    cls
) else (
    chcp 65001 >nul
    set "file_name=english.msg"
    echo.
    cls
)

@REM Use external files with messages
for /f "delims=" %%a in (%file_name%) do (set "%%a")