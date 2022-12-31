@echo off
del "%~dp0wav\s*m*.wav" /S /Q > NUL 2>&1
PowerShell -Version 5.1 -ExecutionPolicy RemoteSigned -File "%~dp0Source\GenerateCoeiroinkWav.ps1" "%~dp0TitlePlaceholder.json" 0
