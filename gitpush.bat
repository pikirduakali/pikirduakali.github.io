@echo off
cd /d "%~dp0"
set msg=%1
if "%msg%"=="" set msg=update
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
