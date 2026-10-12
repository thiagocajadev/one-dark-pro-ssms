@echo off
rem Double-click entry point: runs the uninstaller script (it asks for administrator rights)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Uninstall.ps1"
