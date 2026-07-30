@echo off
cd /d "%~dp0"
start "" powershell -NoProfile -ExecutionPolicy Bypass -File "server.ps1"
ping -n 3 127.0.0.1 >nul 2>&1
start "" "http://localhost:3457/sendmessage.html"
echo.
echo Server started — dashboard opened in browser.
echo Close the PowerShell window to stop.
echo.
