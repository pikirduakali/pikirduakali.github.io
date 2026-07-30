@echo off
cd /d "%~dp0"
start "" powershell -NoProfile -ExecutionPolicy Bypass -File "server.ps1"
timeout /t 2 /nobreak >nul
start "" "http://localhost:3456/ping"
start "" "sendmessage.html"
echo.
echo Server started at http://localhost:3456
echo Close "server.ps1" window to stop.
pause
