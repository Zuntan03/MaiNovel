@echo off
PowerShell -Version 5.1 -ExecutionPolicy RemoteSigned -File "%~dp0Source\GenerateCoeiroinkWav.ps1" "%~dp0TitlePlaceholder.json" 0
