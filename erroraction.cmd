:: Smartmontools for Windows package v6.1-4 erroraction.cmd
:: http://www.netpower.fr
:: (CopyLeft) 2013 by Orsiris "Ozy" de Jong

:: Config should be changed in erroraction_config.cmd and not here

@echo off
setlocal enabledelayedexpansion

:: Load autgenerated configuration
call "erroraction_config.cmd"
set DEBUG=no
set SCRIPT_ERROR=0
:: ---------------------------- Main -----------------------------
:: This variable contains a newline char... Please leave the empty 2 lines below as they're needed for the "newline" symbol.
:: The newline symbol will be used to parse a space separated list of devices (%DEVICE_LIST%) with the for command.
set newline=^



IF "%1"=="--dryrun" ( set DRY=1 ) ELSE ( set DRY=0 )

call:GetComputerName
call:CreateSmartOutput
call:Mailer
call:LocalMessage
GOTO END


:Log
echo %~1 >> "%ERROR_LOG_FILE%"
IF "%DEBUG%"=="yes" echo %~1
GOTO:EOF

:CheckMailValues
echo "%SOURCE_MAIL%" | findstr /I "@" > nul
IF %ERRORLEVEL%==1 (
	call:Log "Source mail not set"
	GOTO End
	)
echo "%DESTINATION_MAIL%" | findstr /I "@" > nul
IF %ERRORLEVEL%==1 (
	call:Log "Destination Mail not Set"
	GOTO End
	)
IF "%SUBJECT%"=="" (
	call:Log "Mail subject not set"
	GOTO End
	)
echo "%SMTP_SERVER%" | findstr /I "." > nul
IF %ERRORLEVEL%==1 (
	call:Log "Smtp sever not set"
	GOTO End
	)
call:Log "Configuration file check success."
GOTO:EOF

:CreateSmartOutput
echo ------------------------------------------------------------------------------------------------- %DATE:~0,2%-%DATE:~3,2%-%DATE:~6,4% %TIME:~0,2%H%TIME:~3,2%m%TIME:~6,2%s >> "%SMART_LOG_FILE%"
IF "%DEVICE_LIST%"=="DEVICESCAN" (
	for /F "delims= " %%i in ('"%PROGRAM_PATH%\bin\smartctl" --scan') do "%PROGRAM_PATH%\bin\smartctl.exe" -a %%i >> "%SMART_LOG_FILE%"
	
) ELSE (
	for /F %%i in ("%DEVICE_LIST: =!newline!%") do "%PROGRAM_PATH%\bin\smartctl.exe" -a %%i >> "%SMART_LOG_FILE%"
)
GOTO:EOF

:GetComputerName
IF NOT "%USERDOMAIN%"=="" set COMPUTER_FQDN=%COMPUTERNAME%.%USERDOMAIN%
IF NOT "%USERDNSDOMAIN%"=="" set COMPUTER_FQDN=%COMPUTERNAME%.%USERDNSDOMAIN%
GOTO:EOF

:Mailer
IF NOT "%MAIL_ALERT%"=="yes" GOTO:EOF
set SUBJECT=Smart Error on %COMPUTER_FQDN%
set MAIL_CONTENT=%DATE% - %WARNING_MESSAGE%
call:CheckMailValues
IF "%MAILER%"=="blat" call:MailerBlat
IF "%MAILER%"=="sendemail" call:MailerSendEmail
GOTO:EOF

:MailerSendEmail
set attachment=
IF "%COMPRESS_LOGS%"=="yes" (
	"%PROGRAM_PATH%\bin\gzip" -c "%SMART_LOG_FILE%" > "%SMART_LOG_FILE%.gz"
	set attachment=-a "%SMART_LOG_FILE%.gz"
) ELSE (
	set attachment=-a "%SMART_LOG_FILE%"
)
IF NOT "%SMTP_USER%"=="" set smtpuser=-o username=%SMTP_USER%
IF NOT "%SMTP_PASSWORD%"=="" set smtppassword=-o password=%SMTP_PASSWORD%
IF %DRY%==1 (
	echo "%PROGRAM_PATH%\bin\sendemail.exe" -f "%SOURCE_MAIL%" -t "%DESTINATION_MAIL%" -u "%SUBJECT%" -m "%MAIL_CONTENT%" %attachment% -s "%SMTP_SERVER%" -o tls=%TLS% %smtpuser% %smtppassword%
) ELSE (
	"%PROGRAM_PATH%\bin\sendemail.exe" -f "%SOURCE_MAIL%" -t "%DESTINATION_MAIL%" -u "%SUBJECT%" -m "%MAIL_CONTENT%" %attachment% -s "%SMTP_SERVER%" -o tls=%TLS% %smtpuser% %smtppassword% >> "%ERROR_LOG_FILE%"
)
	IF NOT %ERRORLEVEL%==0 (
	set SCRIPT_ERROR=1
	Call:Log "Sending mail using sendemail failed."
)
GOTO:EOF

:MailerBlat
IF %DRY%==1 (
	echo blat - -q -subject "%SUBJECT%" -to "%DESTINATION_MAIL%" < "%MAIL_CONTENT%"
) ELSE (
	blat - -q -subject "%SUBJECT%" -to "%DESTINATION_MAIL%" < "%MAIL_CONTENT%"
)

IF NOT %ERRORLEVEL%==0 (
	set SCRIPT_ERROR=1
	Call:Log "Sending mail using blat failed".
)
:LocalMessage
IF NOT "%LOCAL_ALERT%"=="yes" GOTO:EOF
set local_alert_type_switch=
IF "%LOCAL_ALERT_TYPE%"=="active" set local_alert_type_switch=-a
IF "%LOCAL_ALERT_TYPE%"=="console" set local_alert_type_switch=-c
IF "%LOCAL_ALERT_TYPE%"=="connected" set local_alert_type_switch=-s
IF %DRY%==1 (
	echo "%PROGRAM_PATH%\bin\wtssendmsg.exe" %local_alert_type_switch% "%WARNING_MESSAGE% [%COMPUTER_FQDN%]"
) ELSE (
	"%PROGRAM_PATH%\bin\wtssendmsg.exe" %local_alert_type_switch% "%WARNING_MESSAGE% [%COMPUTER_FQDN%]"
)
IF NOT %ERRORLEVEL%==0 (
	set SCRIPT_ERROR=1
	Call:Log "Sending local message using wtssendmsg failed."
)
GOTO:EOF

:END
IF NOT %SCRIPT_ERROR%==0 echo Something bad happened while executing this script. Please check log file. You can also check what happens with parameter --dryrun
