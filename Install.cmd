@echo off
rem Double-click entry point: runs the installer script (it asks for administrator rights)
powershell.exe -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\Install.ps1"
