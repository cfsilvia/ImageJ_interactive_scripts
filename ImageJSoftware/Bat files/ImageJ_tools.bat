@echo off

setlocal

REM Read the first line of config.txt into the variable 'drive_letter' there are 2 options c:\LabSoftware or U:\LabSoftware\ImageJ_interactive_scripts
set /p drive_letter=<config_imagej.txt

"C:\Fiji.app\ImageJ-win64.exe" --run "%drive_letter%\ImageJSoftware\AutomaticCounting\MainProgramPVN_.ijm" 

