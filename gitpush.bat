@echo off
cd /d "%~dp0"
for /f "tokens=*" %%a in ('powershell -Command "Add-Type -AssemblyName Microsoft.VisualBasic; $m=[Microsoft.VisualBasic.Interaction]::InputBox('Enter commit message:', 'Git Push', 'update'); if ($m) { Write-Output $m } else { exit 1 }"') do set msg=%%a
if "%msg%"=="" (
  echo Cancelled.
  pause
  exit /b
)
git add -A
git commit -m "%msg%"
git push
if %errorlevel%==0 (
  echo.
  echo Done!
) else (
  echo.
  echo Something went wrong.
)
pause
