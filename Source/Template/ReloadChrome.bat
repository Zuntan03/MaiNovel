@echo off
PowerShell -Version 5.1 -ExecutionPolicy RemoteSigned -File "%~dp0Source\ReloadChrome.ps1" "%~dp0TitlePlaceholder.json" 1
