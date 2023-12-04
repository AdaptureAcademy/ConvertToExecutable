@echo off
REM Check for script argument
IF "%~1"=="" (
    echo Usage: %0 ^<script-to-convert^>.py
    goto :eof
)

REM Set variables
SET ENTRY_SCRIPT=%~1
SET VENV_DIR=venv
SET DIST_DIR=dist

REM Activate the virtual environment
CALL %VENV_DIR%\Scripts\activate.bat

REM Install PyInstaller
pip install pyinstaller

REM Create the .exe file with PyInstaller
pyinstaller --onefile --add-data "%VENV_DIR%\Lib\site-packages\*;.\lib" "%ENTRY_SCRIPT%"

REM Check if PyInstaller succeeded
IF NOT EXIST "%DIST_DIR%\%~n1.exe" (
    echo PyInstaller failed to create an executable.
    goto :error
)

REM Move the .exe to the current directory
move "%DIST_DIR%\%~n1.exe" .\

REM Clean up the build directories
rmdir /s /q build
del /q "%ENTRY_SCRIPT%.spec"

echo The standalone %ENTRY_SCRIPT%.exe has been created.
goto :eof

:error
deactivate
echo Failed to create the executable.
