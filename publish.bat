@echo off
cd /d "%~dp0"
start "" powershell -NoProfile -ExecutionPolicy Bypass -File "server.ps1"
timeout /t 2 /nobreak >nul
start "" "http://localhost:3456/sendmessage.html"
echo.
echo Server started — dashboard opened in browser.
echo Close "server.ps1" window to stop.
echo.
