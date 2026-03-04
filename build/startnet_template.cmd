@echo off
REM EZOSD Auto-Start Script

wpeinit
start cmd
start powershell

echo.
echo ============================================================
echo   EZOSD - Enterprise Windows Deployment
echo ============================================================
echo.

REM Start the deployment script
echo Starting automated deployment in 5 seconds...
ping -n 5 localhost > NUL
powercfg /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c > NUL
PowerShell -ExecutionPolicy Bypass -Command "Invoke-Expression (Invoke-RestMethod -Uri 'https://github.com/mattskare/EZOSD/releases/latest/download/EZOSD.ps1')"