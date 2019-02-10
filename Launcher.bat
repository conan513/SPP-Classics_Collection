@echo off
:beginning
SET NAME=Single Player Project - Classics Collection
TITLE %NAME%
set mainfolder=%CD%

IF NOT EXIST "%mainfolder%\music.on" (
  IF NOT EXIST "%mainfolder%\music.off" (
    echo music > "%mainfolder%\music.on"
  )
)
if exist "%mainfolder%\Server\Database" goto beginning_part2
cd "%mainfolder%\Server"
"%mainfolder%\Server\Tools\7za.exe" e -y -spf Database.7z
"%mainfolder%\Server\Tools\7za.exe" e -y -spf Database_Playerbot.7z
goto beginning_part2

:beginning_part2
if exist "%mainfolder%\music.on" goto music_start
if exist "%mainfolder%\music.off" goto select_expansion

:music_start
tasklist /FI "IMAGENAME eq cmdmp3win.exe" 2>NUL | find /I /N "cmdmp3win.exe">NUL
if "%ERRORLEVEL%"=="0" goto select_expansion
cd "%mainfolder%\Server\Tools"
start cmdmp3win.exe launcher.mp3
cls
echo Starting the launcher...
ping -n 4 127.0.0.1>nul
echo Get ready...
ping -n 4 127.0.0.1>nul
cls
echo Starting the launcher...
echo Get ready...for something nostalgic...
ping -n 3 127.0.0.1>nul
cls
echo CREDITS:
echo --------
echo.
ping -n 2 127.0.0.1>nul
echo MaNGOS
ping -n 2 127.0.0.1>nul
echo (C)ontinued MaNGOS
ping -n 2 127.0.0.1>nul
echo AzerothCore
ping -n 2 127.0.0.1>nul
echo TrinityCore
ping -n 2 127.0.0.1>nul
echo Ike3
ping -n 2 127.0.0.1>nul
echo Lidocain
ping -n 2 127.0.0.1>nul
echo Ovahlord
ping -n 3 127.0.0.1>nul
cls
echo Single Player Project
echo.
echo This repack created by Conan
ping -n 5 127.0.0.1>nul

cd "%mainfolder%"
goto select_expansion

:music_switch
if exist "%mainfolder%\music.on" goto music_off
if exist "%mainfolder%\music.off" goto music_on

:music_off
taskkill /f /im cmdmp3win.exe
cls
del "%mainfolder%\music.on"
echo music > "%mainfolder%\music.off"
goto beginning

:music_on
del "%mainfolder%\music.off"
echo music > "%mainfolder%\music.on"
goto beginning

:select_expansion
if exist "%mainfolder%\music.on" set music=ON
if exist "%mainfolder%\music.off" set music=OFF
set module_check_vanilla=Not Installed
set module_check_tbc=Not Installed
set module_check_wotlk=Not available yet
set module_check_cata=Not available yet

if exist "%mainfolder%\Modules\vanilla\dbc" set module_check_vanilla=Installed
if exist "%mainfolder%\Modules\tbc\dbc" set module_check_tbc=Installed
if exist "%mainfolder%\Modules\wotlk\dbc" set module_check_wotlk=Installed
if exist "%mainfolder%\Modules\cata\dbc" set module_check_cata=Installed
cls
echo #######################################################
echo # Single Player Project - Classics Collection
echo # https://www.patreon.com/conan513                    
echo #######################################################
echo.
echo 1 - World of Warcraft                          [%module_check_vanilla%]
echo 2 - World of Warcraft: The Burning Crusade     [%module_check_tbc%]
echo 3 - World of Warcraft: Wrath of the Lich King  [%module_check_wotlk%]
echo 4 - World of Warcraft: Cataclysm               [%module_check_cata%]
echo.
echo 0 - Intro/Music [%music%]
echo.
set /P choose_exp=What expension you want to play: 
if "%choose_exp%"=="1" (goto setup_vanilla)
if "%choose_exp%"=="2" (goto setup_tbc)
if "%choose_exp%"=="3" (goto setup_wotlk)
if "%choose_exp%"=="4" (goto setup_cata)
if "%choose_exp%"=="0" (goto music_switch)
if "%menu%"=="" (goto select_expansion)

:setup_vanilla
SET NAME=Single Player Project - Vanilla
TITLE %NAME%
COLOR 0E
set expansion=vanilla

set characters=vanilla_characters
set playerbot=vanilla_playerbot
set world=vanilla_world
set login=vanilla_realmd

set spp_update=vanilla_base

goto settings

:setup_tbc
SET NAME=Single Player Project - The Burning Crusade
TITLE %NAME%
COLOR 0A
set expansion=tbc

set characters=tbc_characters
set playerbot=tbc_playerbot
set world=tbc_world
set login=tbc_realmd

set spp_update=tbc_base

goto settings

:setup_wotlk
SET NAME=Single Player Project - Wrath of the Lich King
TITLE %NAME%
COLOR 0B
set expansion=wotlk

set characters=wotlk_characters
set playerbot=wotlk_playerbot
set world=wotlk_world
set login=wotlk_realmd

set spp_update=wotlk_base

cls
echo This expansion does not included yet.
echo Check back later.
echo.
pause
goto beginning

goto settings

:setup_cata
SET NAME=Single Player Project - Cataclysm
TITLE %NAME%
COLOR 0C
set expansion=cata

set characters=cata_characters
set playerbot=cata_playerbot
set world=cata_world
set login=cata_realmd

set spp_update=cata_base

cls
echo This expansion does not included yet.
echo Check back later.
echo.
pause
goto beginning

goto settings

:settings
REM --- Settings ---

set host=127.0.0.1
set port=3310
set user=root
set pass=123456

set realmserver=realmd.exe
set worldserver=mangosd.exe

REM --- Settings ---

:start_database
if not exist "%mainfolder%\Saves\%expansion%\autosave" mkdir "%mainfolder%\Saves\%expansion%\autosave"

IF NOT EXIST "%mainfolder%\autosave.on" (
  IF NOT EXIST "%mainfolder%\autosave.off" (
    echo autosave > "%mainfolder%\autosave.on"
  )
)

start "" /min "%mainfolder%\Server\Database\start.bat"
start "" /min "%mainfolder%\Server\Database_Playerbot\start.bat"

if not exist "%mainfolder%\%spp_update%.spp" goto update_install
goto menu

:update_install
cls
echo.
echo Database update required, please wait...
echo.
ping -n 15 127.0.0.1>nul
echo Applying updated world database...
echo.
"%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 < "%mainfolder%\sql\%expansion%\drop_world.sql"
"%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%world% < "%mainfolder%\sql\%expansion%\world.sql"

echo.
echo Applying characters updates...
echo.
for %%i in ("%mainfolder%\sql\%expansion%\characters\*sql") do if %%i neq "%mainfolder%\sql\%expansion%\characters\*sql" if %%i neq "%mainfolder%\sql\%expansion%\characters\*sql" if %%i neq "%mainfolder%\sql\%expansion%\characters\*sql" echo %%i & "%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%characters% < %%i
for %%i in ("%mainfolder%\sql\%expansion%\playerbot\*sql") do if %%i neq "%mainfolder%\sql\%expansion%\playerbot\*sql" if %%i neq "%mainfolder%\sql\%expansion%\playerbot\*sql" if %%i neq "%mainfolder%\sql\%expansion%\playerbot\*sql" echo %%i & "%mainfolder%\Server\Database_Playerbot\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database_Playerbot\connection.cnf" --default-character-set=utf8 --database=%playerbot% < %%i
for %%i in ("%mainfolder%\sql\%expansion%\realmd\*sql") do if %%i neq "%mainfolder%\sql\%expansion%\realmd\*sql" if %%i neq "%mainfolder%\sql\%expansion%\realmd\*sql" if %%i neq "%mainfolder%\sql\%expansion%\%expansion%\realmd\*sql" echo %%i & "%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%login% < %%i
echo.
echo Applying world updates...
echo.
for %%i in ("%mainfolder%\sql\%expansion%\world\*sql") do if %%i neq "%mainfolder%\sql\%expansion%\world\*sql" if %%i neq "%mainfolder%\sql\%expansion%\world\*sql" if %%i neq "%mainfolder%\sql\%expansion%\world\*sql" echo %%i & "%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%world% < %%i
for %%i in ("%mainfolder%\sql\%expansion%\world\Instances\*sql") do if %%i neq "%mainfolder%\sql\%expansion%\world\Instances\*sql" if %%i neq "%mainfolder%\sql\%expansion%\world\Instances\*sql" if %%i neq "%mainfolder%\sql\%expansion%\world\Instances\*sql" echo %%i & "%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%world% < %%i

echo.
echo Make sure you don't see any error message above.
echo Delete the "%spp_update%" file in the server folder if you want to apply this update again.
echo.
echo %spp_update% > "%mainfolder%\%spp_update%.spp"
pause
goto menu

:menu
cls
echo #######################################################
echo # %NAME%
echo # https://www.patreon.com/conan513                    
echo #######################################################
echo.
echo MySQL settings
echo --------------
echo Host: %host%
echo Port: %port%
echo User: %user%
echo Pass: %pass%
echo --------------
echo.
echo 1 - Start servers (Win32)
echo 2 - Start servers (Win64)
echo.
echo 3 - Create game account
echo 4 - Change server address
echo 5 - Character save manager
echo.
echo 6 - Reset randombots (can fix boot crash)
echo 7 - Wipe characters database
echo.
echo 0 - Shutdown all servers
echo.
set /P menu=Enter a number: 
if "%menu%"=="1" (goto quick_start_servers_x86)
if "%menu%"=="2" (goto quick_start_servers_x64)
if "%menu%"=="3" (goto account_tool)
if "%menu%"=="4" (goto ip_changer)
if "%menu%"=="5" (goto save_menu)
if "%menu%"=="6" (goto clear_bots)
if "%menu%"=="7" (goto clear_characters)
if "%menu%"=="0" (goto shutdown_servers)
if "%menu%"=="" (goto menu)

goto menu

:clear_bots
cls
echo #########################################################
echo # WARNING!                                              #
echo # All of your randombots deleted.                       #
echo #########################################################
echo.
pause
taskkill /f /im %realmserver%
taskkill /f /im %worldserver%
"%mainfolder%\Server\Database_Playerbot\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database_Playerbot\connection.cnf" --default-character-set=utf8 --database=%playerbot% < "%mainfolder%\sql\%expansion%\reset_randombots.sql"
pause
goto menu

:clear_characters
cls
echo #########################################################
echo # WARNING!                                              #
echo # All of your characters lost after this process.       #
echo #########################################################
echo.
pause
taskkill /f /im %realmserver%
taskkill /f /im %worldserver%
"%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 < "%mainfolder%\sql\%expansion%\drop_characters.sql"
"%mainfolder%\Server\Database_Playerbot\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database_Playerbot\connection.cnf" --default-character-set=utf8 < "%mainfolder%\sql\%expansion%\drop_playerbot.sql"
"%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 < "%mainfolder%\sql\%expansion%\drop_realmd.sql"

"%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%characters% < "%mainfolder%\sql\%expansion%\characters.sql"
"%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%realmd% < "%mainfolder%\sql\%expansion%\realmd.sql"
for %%i in ("%mainfolder%\sql\%expansion%\characters\*sql") do if %%i neq "%mainfolder%\sql\%expansion%\characters\*sql" if %%i neq "%mainfolder%\sql\%expansion%\characters\*sql" if %%i neq "%mainfolder%\sql\%expansion%\characters\*sql" echo %%i & "%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%characters% < %%i
for %%i in ("%mainfolder%\sql\%expansion%\playerbot\*sql") do if %%i neq "%mainfolder%\sql\%expansion%\playerbot\*sql" if %%i neq "%mainfolder%\sql\%expansion%\playerbot\*sql" if %%i neq "%mainfolder%\sql\%expansion%\playerbot\*sql" echo %%i & "%mainfolder%\Server\Database_Playerbot\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database_Playerbot\connection.cnf" --default-character-set=utf8 --database=%playerbot% < %%i
echo.
echo Clear completed.
pause
goto menu

:ip_changer
set /p current_ip=<"%mainfolder%\Server\Binaries\%expansion%\address.txt"
cls
echo Current address: %current_ip%
echo.
echo 1 - Change server address
echo 2 - Back to main menu
echo.
set /P ip_menu=Enter a number: 
if "%menu%"=="1" (goto setip)
if "%menu%"=="2" (goto menu)
if "%menu%"=="" (goto ip_changer)

:setip
cls
set /P setip=Enter the new server address: 
echo %setip%>"%mainfolder%\Server\Binaries\%expansion%\address.txt"
echo.
echo Saving the new address...
echo.
ping -n 2 127.0.0.1>nul
"%mainfolder%\Server\tools\fart.exe"  -r -c -- "%mainfolder%\sql\%expansion%\realmlist.sql" %current_ip% %setip%
echo.
echo Importing the new address into the database...
echo.
ping -n 2 127.0.0.1>nul
"%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%login% < "%mainfolder%\sql\%expansion%\realmlist.sql"
echo.
echo Server address successfully changed.
pause
goto menu

:report_issue
cls
echo ike3 is the developer of playerbot system.
echo We using this code without any modification.
echo.
pause
start https://github.com/ike3/mangosbot-bots/issues
goto menu

:quick_start_servers_x86
taskkill /f /im cmdmp3win.exe
cls
set serverstartoption=1
set /p realmname1=<"%mainfolder%\Settings\%expansion%\name.txt

echo Starting the first realm...
echo.
echo Name:     %realmname1%
echo.
ping -n 5 127.0.0.1>nul
goto check_autosave_start

:quick_start_servers_x64
taskkill /f /im cmdmp3win.exe
cls
set serverstartoption=2
set /p realmname1=<"%mainfolder%\Settings\%expansion%\name.txt

echo Starting the first realm...
echo.
echo Name:     %realmname1%
echo.
ping -n 5 127.0.0.1>nul
goto check_autosave_start

:check_autosave_start
if exist %mainfolder%\autosave.on goto autosave_start
if "%serverstartoption%"=="1" (goto server_x86)
if "%serverstartoption%"=="2" (goto server_x64)
goto menu

:autosave_start
cls
set saveslot=autosave
echo.
echo ###################
echo # Autosave is on! #
echo ###################
echo.
echo Exporting accounts...please wait...
"%mainfolder%\Server\Database\bin\mysqldump.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 %login% > "%mainfolder%\Saves\%expansion%\%saveslot%\realmd.sql"
echo Done!
echo.
echo Exporting characters...please wait...
"%mainfolder%\Server\Database\bin\mysqldump.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 %characters% > "%mainfolder%\Saves\%expansion%\%saveslot%\characters.sql"
echo Done!
echo.
echo Exporting playerbots...please wait...
"%mainfolder%\Server\Database_Playerbot\bin\mysqldump.exe" --defaults-extra-file="%mainfolder%\Server\Database_Playerbot\connection.cnf" --default-character-set=utf8 %playerbot% > "%mainfolder%\Saves\%expansion%\%saveslot%\playerbot.sql"
echo Done!
echo.
if "%serverstartoption%"=="1" (goto server_x86)
if "%serverstartoption%"=="2" (goto server_x64)

:servers_start
cls
cd "%mainfolder%\Settings\%expansion%
echo.
echo Select your architecture.
echo Win32 better for low-end pc or laptops.
echo.
echo 1 - Win32
echo 2 - Win64
echo.
set /P serverstartoption=Select your option: 
goto check_autosave_start

:server_x86
cd "%mainfolder%\Settings\%expansion%"
if "%menu%"=="1" (Start ..\..\Server\Binaries\%expansion%\Bin\%worldserver%)
tasklist /FI "IMAGENAME eq %realmserver%" 2>NUL | find /I /N "%realmserver%">NUL
if "%ERRORLEVEL%"=="0" goto menu
start ..\..\Server\Binaries\%expansion%\Bin\%realmserver%
REM start Server\Tools\server_check.bat"
goto menu

:server_x64
cd "%mainfolder%\Settings\%expansion%"
if "%menu%"=="2" (Start ..\..\Server\Binaries\%expansion%\Bin64\%worldserver%)
tasklist /FI "IMAGENAME eq %realmserver%" 2>NUL | find /I /N "%realmserver%">NUL
if "%ERRORLEVEL%"=="0" goto menu
start ..\..\Server\Binaries\%expansion%\Bin64\%realmserver%
REM start Server\Tools\server_check.bat"
goto menu

:save_menu
cls
if exist "%mainfolder%\autosave.on" set autosave=ON
if exist "%mainfolder%\autosave.off" set autosave=OFF
if not exist "%mainfolder%\Saves" mkdir "%mainfolder%\Saves"
if not exist "%mainfolder%\Saves\%expansion%" mkdir "%mainfolder%\Saves\%expansion%"
if not exist "%mainfolder%\Saves\%expansion%\1" mkdir "%mainfolder%\Saves\%expansion%\1"
if not exist "%mainfolder%\Saves\%expansion%\2" mkdir "%mainfolder%\Saves\%expansion%\2"
if not exist "%mainfolder%\Saves\%expansion%\3" mkdir "%mainfolder%\Saves\%expansion%\3"
if not exist "%mainfolder%\Saves\%expansion%\4" mkdir "%mainfolder%\Saves\%expansion%\4"
if not exist "%mainfolder%\Saves\%expansion%\5" mkdir "%mainfolder%\Saves\%expansion%\5"
if not exist "%mainfolder%\Saves\%expansion%\6" mkdir "%mainfolder%\Saves\%expansion%\6"
if not exist "%mainfolder%\Saves\%expansion%\7" mkdir "%mainfolder%\Saves\%expansion%\7"
if not exist "%mainfolder%\Saves\%expansion%\8" mkdir "%mainfolder%\Saves\%expansion%\8"
if not exist "%mainfolder%\Saves\%expansion%\9" mkdir "%mainfolder%\Saves\%expansion%\9"
cls
echo.
set customname1=Empty slot
set customname2=Empty slot
set customname3=Empty slot
set customname4=Empty slot
set customname5=Empty slot
set customname6=Empty slot
set customname7=Empty slot
set customname8=Empty slot
set customname9=Empty slot

if exist "%mainfolder%\Saves\%expansion%\1\name.txt" set /p customname1=<"%mainfolder%\Saves\%expansion%\1\name.txt"
if exist "%mainfolder%\Saves\%expansion%\2\name.txt" set /p customname2=<"%mainfolder%\Saves\%expansion%\2\name.txt"
if exist "%mainfolder%\Saves\%expansion%\3\name.txt" set /p customname3=<"%mainfolder%\Saves\%expansion%\3\name.txt"
if exist "%mainfolder%\Saves\%expansion%\4\name.txt" set /p customname4=<"%mainfolder%\Saves\%expansion%\4\name.txt"
if exist "%mainfolder%\Saves\%expansion%\5\name.txt" set /p customname5=<"%mainfolder%\Saves\%expansion%\5\name.txt"
if exist "%mainfolder%\Saves\%expansion%\6\name.txt" set /p customname6=<"%mainfolder%\Saves\%expansion%\6\name.txt"
if exist "%mainfolder%\Saves\%expansion%\7\name.txt" set /p customname7=<"%mainfolder%\Saves\%expansion%\7\name.txt"
if exist "%mainfolder%\Saves\%expansion%\8\name.txt" set /p customname8=<"%mainfolder%\Saves\%expansion%\8\name.txt"
if exist "%mainfolder%\Saves\%expansion%\9\name.txt" set /p customname9=<"%mainfolder%\Saves\%expansion%\9\name.txt"

echo Single Player Project save manager.
echo Select a slot where you want to save your characters.
echo.
echo -----------------------
echo Save 1  -  [%customname1%]
echo Save 2  -  [%customname2%]
echo Save 3  -  [%customname3%]
echo Save 4  -  [%customname4%]
echo Save 5  -  [%customname5%]
echo Save 6  -  [%customname6%]
echo Save 7  -  [%customname7%]
echo Save 8  -  [%customname8%]
echo Save 9  -  [%customname9%]
echo Save 10 -  [Autosave]
echo -----------------------
echo.
echo 1 - Save
echo 2 - Load
echo 3 - Delete
echo.
echo 4 - Turn autosave on/off [%autosave%]
echo.
echo 5 - Open the Saves folder
echo.
echo 0 - Back to main menu
echo.
set /P savemenu=Select your option: 
if "%savemenu%"=="1" (goto saveslot_choose)
if "%savemenu%"=="2" (goto saveslot_choose)
if "%savemenu%"=="3" (goto saveslot_choose)
if "%savemenu%"=="4" (goto autosave_switch)
if "%savemenu%"=="5" (explorer.exe Saves)
if "%savemenu%"=="0" (goto menu)
if "%savemenu%"=="" (goto save_menu)
goto save_menu
echo.
:saveslot_choose
set /P saveslot=Select a save slot: 
if "%saveslot%"=="1" (set saveslot=1)
if "%saveslot%"=="2" (set saveslot=2)
if "%saveslot%"=="3" (set saveslot=3)
if "%saveslot%"=="4" (set saveslot=4)
if "%saveslot%"=="5" (set saveslot=5)
if "%saveslot%"=="6" (set saveslot=6)
if "%saveslot%"=="7" (set saveslot=7)
if "%saveslot%"=="8" (set saveslot=8)
if "%saveslot%"=="9" (set saveslot=9)
if "%saveslot%"=="10" (set saveslot=autosave)
if "%saveslot%"=="" (goto save_menu)

if "%savemenu%"=="1" (goto export_char_check)
if "%savemenu%"=="2" (goto import_char_check)
if "%savemenu%"=="3" (goto delete_saveslot_check)

:delete_saveslot_check
cls
if exist "%mainfolder%\Saves\%expansion%\%saveslot%\characters.sql" goto delete_saveslot
echo.
echo This slot is empty. You can't delete the nothing...
echo.
pause
goto save_menu

:delete_saveslot
cls
echo.
set /P menu=Are you sure want to clear Save %saveslot% files? (Y/n)
if "%menu%"=="n" (goto menu)
if "%menu%"=="y" (goto delete_saveslot_1)

:delete_saveslot_1
cls
echo.
echo Removing the selected Save %saveslot% files...
echo.
del "%mainfolder%\Saves\%expansion%\%saveslot%\realmd.sql"
del "%mainfolder%\Saves\%expansion%\%saveslot%\characters.sql"
del "%mainfolder%\Saves\%expansion%\%saveslot%\playerbot.sql"
del "%mainfolder%\Saves\%expansion%\%saveslot%\name.txt"
echo.
echo Save %saveslot% is empty now.
echo.
goto save_menu

:export_char_check
cls
if exist "%mainfolder%\Saves\%expansion%\%saveslot%\characters.sql" goto export_char
goto export_char_1

:export_char
cls
echo.
echo This process overwrite your previous save files!
echo.
set /P menu=Are you sure want to export your characters into this save slot? (Y/n)
if "%menu%"=="n" (goto menu)
if "%menu%"=="y" (goto export_char_1)

:export_char_1
cls
echo.
set /P slotname=Add a name for the selected save slot: 
echo %slotname%>"%mainfolder%\Saves\%expansion%\%saveslot%\name.txt"
echo.
echo Exporting accounts...please wait...
"%mainfolder%\Server\Database\bin\mysqldump.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 %login% > "%mainfolder%\Saves\%expansion%\%saveslot%\realmd.sql"
echo Done!
echo.
echo Exporting characters...please wait...
"%mainfolder%\Server\Database\bin\mysqldump.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 %characters% > "%mainfolder%\Saves\%expansion%\%saveslot%\characters.sql"
echo Done!
echo.
echo Exporting playerbots...please wait...
"%mainfolder%\Server\Database_Playerbot\bin\mysqldump.exe" --defaults-extra-file="%mainfolder%\Server\Database_Playerbot\connection.cnf" --default-character-set=utf8 %playerbot% > "%mainfolder%\Saves\%expansion%\%saveslot%\playerbot.sql"
echo Done!
echo.
echo Save slot %saveslot% export completed.
echo The save files available in the Saves folder.
echo.
pause
goto menu

:import_char_check
cls
if exist "%mainfolder%\Saves\%expansion%\%saveslot%\characters.sql" goto import_char
echo.
echo This slot is empty.
echo Please select another slot.
echo.
pause
goto save_menu

:import_char
cls
echo.
echo Please stop all of your servers (except the database server) before continue from here!
echo This process overwrite your current database!
echo.
set /P menu=Are you sure want to import your characters? (Y/n)
if "%menu%"=="n" (goto menu)
if "%menu%"=="y" (goto import_char_1)

:import_char_1
cls
echo.
echo Importing accounts from the selected save file...please wait...
"%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%login% < "%mainfolder%\Saves\%expansion%\%saveslot%\realmd.sql"
echo Done!
echo.
echo Importing characters from the selected save file...please wait...
"%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%characters% < "%mainfolder%\Saves\%expansion%\%saveslot%\characters.sql"
echo Done!
echo.
echo Importing playerbots from the selected save file...please wait...
"%mainfolder%\Server\Database_Playerbot\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database_Playerbot\connection.cnf" --default-character-set=utf8 --database=%playerbot% < "%mainfolder%\Saves\%expansion%\%saveslot%\playerbot.sql"
echo Done!
echo.
echo Importing character database updates...please wait...
echo.
for %%i in ("%mainfolder%\sql\%expansion%\realmd\*sql") do if %%i neq "%mainfolder%\sql\%expansion%\realmd\*sql" if %%i neq "%mainfolder%\sql\%expansion%\realmd\*sql" if %%i neq "%mainfolder%\sql\%expansion%\realmd\*sql" echo %%i & "%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%login% < %%i
for %%i in ("%mainfolder%\sql\%expansion%\characters\*sql") do if %%i neq "%mainfolder%\sql\%expansion%\characters\*sql" if %%i neq "%mainfolder%\sql\%expansion%\characters\*sql" if %%i neq "%mainfolder%\sql\%expansion%\characters\*sql" echo %%i & "%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%characters% < %%i
for %%i in ("%mainfolder%\sql\%expansion%\characters_updates\*sql") do if %%i neq "%mainfolder%\sql\%expansion%\characters_updates\*sql" if %%i neq "%mainfolder%\sql\%expansion%\characters_updates\*sql" if %%i neq "%mainfolder%\sql\%expansion%\characters_updates\*sql" echo %%i & "%mainfolder%\Server\Database\bin\mysql.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 --database=%characters% < %%i
echo.
echo Done!
echo.
cls
echo Save slot %saveslot% import completed.
echo.
pause
goto menu

:account_tool
cls
echo Enter the following command into the worldserver window to create a normal account:
echo account create NAME PASSWORD
echo.
echo Create an administrator account:
echo account set gm NAME 3
echo.
echo Change the NAME and PASSWORD word to yours.
echo.
pause
goto menu

:shutdown_servers
cls
taskkill /f /im %realmserver%
taskkill /f /im %worldserver%
if exist %mainfolder%\autosave.on goto autosave_shutdown
"%mainfolder%\Server\Database\bin\mysqladmin.exe" -u root -p123456 --port=3310 shutdown
"%mainfolder%\Server\Database_Playerbot\bin\mysqladmin.exe" -u root -p123456 --port=3312 shutdown

goto exit

:autosave_shutdown
set saveslot=autosave
echo.
echo ###################
echo # Autosave is on! #
echo ###################
echo.
echo Exporting accounts...please wait...
"%mainfolder%\Server\Database\bin\mysqldump.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 %login% > "%mainfolder%\Saves\%expansion%\%saveslot%\realmd.sql"
echo Done!
echo.
echo Exporting characters...please wait...
"%mainfolder%\Server\Database\bin\mysqldump.exe" --defaults-extra-file="%mainfolder%\Server\Database\connection.cnf" --default-character-set=utf8 %characters% > "%mainfolder%\Saves\%expansion%\%saveslot%\characters.sql"
echo Done!
echo.
echo Exporting playerbots...please wait...
"%mainfolder%\Server\Database_Playerbot\bin\mysqldump.exe" --defaults-extra-file="%mainfolder%\Server\Database_Playerbot\connection.cnf" --default-character-set=utf8 %playerbot% > "%mainfolder%\Saves\%expansion%\%saveslot%\playerbot.sql"
echo Done!
echo.
"%mainfolder%\Server\Database\bin\mysqladmin.exe" -u root -p123456 --port=3310 shutdown
"%mainfolder%\Server\Database_Playerbot\bin\mysqladmin.exe" -u root -p123456 --port=3312 shutdown

goto exit

:vcredist_install_x86
cls
echo.
"%mainfolder%\Addons\vcredist\2005 Updated\vcredist_x86.exe" /Q
"%mainfolder%\Addons\vcredist\2008 SP1\vcredist_x86.exe" /qb
"%mainfolder%\Addons\vcredist\2010\vcredist_x86.exe" /passive /norestart
"%mainfolder%\Addons\vcredist\2012 Update 4\vcredist_x86.exe" /passive /norestart
"%mainfolder%\Addons\vcredist\2013\vcredist_x86.exe" /install /passive /norestart
"%mainfolder%\Addons\vcredist\2015 Update 3\vc_redist.x86.exe" /install /passive /norestart
"%mainfolder%\Addons\vcredist\2017\vc_redist.x86.exe" /install /passive /norestart
goto service_menu

:vcredist_install_x64
cls
echo.
"%mainfolder%\Addons\vcredist\2005 Updated\vcredist_x64.exe" /Q
"%mainfolder%\Addons\vcredist\2008 SP1\vcredist_x64.exe" /qb
"%mainfolder%\Addons\vcredist\2010\vcredist_x64.exe" /passive /norestart
"%mainfolder%\Addons\vcredist\2012 Update 4\vcredist_x64.exe" /passive /norestart
"%mainfolder%\Addons\vcredist\2013\vcredist_x64.exe" /install /passive /norestart
"%mainfolder%\Addons\vcredist\2015 Update 3\vc_redist.x64.exe" /install /passive /norestart
"%mainfolder%\Addons\vcredist\2017\vc_redist.x64.exe" /install /passive /norestart
goto service_menu

:log_file
notepad "%mainfolder%\Server\Logs\server.log"
goto service_menu

:autosave_switch
if exist "%mainfolder%\autosave.on" goto autosave_off
if exist "%mainfolder%\autosave.off" goto autosave_on

:autosave_off
cls
del "%mainfolder%\autosave.on"
echo autosave > "%mainfolder%\autosave.off"
goto save_menu

:autosave_on
del "%mainfolder%\autosave.off"
echo autosave > "%mainfolder%\autosave.on"
goto save_menu


:exit
exit