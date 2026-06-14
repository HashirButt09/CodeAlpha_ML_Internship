@echo off
setlocal enabledelayedexpansion

title Speech Emotion Recognition App Bootloader
echo ===================================================
echo   Speech Emotion Recognition App - Booting up...
echo ===================================================

set "VENV_DIR=%~dp0.venv"
set "REQUIREMENTS=%~dp0requirements.txt"
set "APP_SCRIPT=%~dp0speech_emotion_bot.py"

:: Check if Python is installed
where python >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Python is not installed or not in your system PATH.
    echo Please download and install Python 3.8-3.11 and check "Add Python to PATH".
    pause
    exit /b 1
)

:: Check if virtual environment directory exists
if not exist "%VENV_DIR%" (
    echo [INFO] Virtual environment not found. Creating a new one in: "%VENV_DIR%"
    python -m venv "%VENV_DIR%"
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to create virtual environment.
        pause
        exit /b 1
    )
    
    echo [INFO] Virtual environment created successfully.
    echo [INFO] Installing required dependencies. This may take a few minutes...
    "%VENV_DIR%\Scripts\pip" install -r "%REQUIREMENTS%"
    if %errorlevel% neq 0 (
        echo [ERROR] Failed to install dependencies.
        pause
        exit /b 1
    )
    echo [INFO] Dependencies installed successfully.
) else (
    echo [INFO] Virtual environment detected.
)

echo [INFO] Starting the web application...
set "TF_CPP_MIN_LOG_LEVEL=3"
set "TF_ENABLE_ONEDNN_OPTS=0"
"%VENV_DIR%\Scripts\streamlit" run "%APP_SCRIPT%"

if %errorlevel% neq 0 (
    echo [ERROR] The application exited with code %errorlevel%.
    pause
)

endlocal
