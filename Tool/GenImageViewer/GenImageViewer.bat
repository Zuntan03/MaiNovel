@echo off
PowerShell -Version 5.1 -ExecutionPolicy RemoteSigned -File "%~dp0GenImageViewer.ps1" "%~1"
