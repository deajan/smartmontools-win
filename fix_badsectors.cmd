:: Reallocate bad sector script v1.0
:: http://www.netpower.fr
:: (CopyLeft) 2013 by Orsiris "Ozy" de Jong

@echo off
setlocal
echo Experimental script to reallocate bad sectors
echo You can get last bad sector address by performing a smartmontools
echo long test and check results.
echo.
echo This script reads and writes 8 x 512 bytes of data to the LBA
echo address of a bad sector forcing drive's firmware to reallocate the bad sector.
echo Use at your own risk.
echo.
echo Please run this script in the directory where your dd executable is located
echo.
set /p none=Press any key to get a list of drives

:SETDRV
dd --list
echo Enter the drive name where the bad sector is located (or enter q to quit)
echo.
echo First drive could be \\?\Device\Harddisk0\DR0
echo Second drive could be \\?\Device\Harddisk1\DR0
echo.
set /p drive=Drive ? 

IF "%drive%"=="q" GOTO END
IF "%drive%"=="Q" GOTO END
IF "%drive%"=="" GOTO BADDRV

:SETADDR
set /p address=Enter LBA address of bad sector: 
IF "%address%"=="" GOTO BADADDR

:FIX
set /a faddress=%address%/8
dd bs=4096c count=1c if=%drive% of=%temp%\%address%.lba skip=%faddress%
dd bs=4096c count=1c if=/dev/zero of=%drive% skip=%faddress%
dd bs=4096c count=1c if=%temp%\%address%.lba of=%drive% skip=%faddress%
IF NOT "%ERRORLEVEL%"=="0" GOTO FALSE

echo Run complete, pleadse run a smartmontools test (smartctl -t long drive) to check. 
GOTO END

:FALSE
echo It seems that the fix did not succedd. You might try smartmontools long test (smartctl -t long drive) to check.
GOTO END

:BADDRV
echo Please enter a valid drive name
GOTO SETDRV

:BADADDR
echo Please enter a valid LBA address
GOTO SETADDR
:END
