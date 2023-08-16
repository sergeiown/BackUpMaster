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