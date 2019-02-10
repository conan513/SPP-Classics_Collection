@echo off
SET NAME=SingleCore Server Launcher
TITLE %NAME%
COLOR 0A
set mainfolder=%CD%

:start_server
cd "%mainfolder%\SPP-Classics_Collection"
Launcher.bat
exit