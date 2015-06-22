:: Smartmontools for Windows package v6.4-3 erroraction.cmd
:: http://www.netpower.fr
:: (L) 2013-2015 by Orsiris "Ozy" de Jong

:: Config can be changed in erroraction_config.cmd

@echo off
setlocal enabledelayedexpansion

:: Get currentdir
:: Get Script working dir if erroraction.cmd is launched as scheduled task
set curdir=%~dp0
set curdir=%curdir:~0,-1%

:: Load autgenerated configuration
call "%curdir%\erroraction_config.cmd"

:: Load autgenerated configuration
call "erroraction_config.cmd"
set DEBUG=no
set SCRIPT_ERROR=0
:: ---------------------------- Main -----------------------------
:: This variable contains a newline char... Please leave the empty 2 lines below as they're needed for the "newline" symbol.
:: The newline symbol will be used to parse a space separated list of devices (%DEVICE_LIST%) with the for command.
set newline=^



IF "%1"=="--dryrun" ( set DRY=1 ) ELSE ( set DRY=0 )
IF "%1"=="--test" ( call:Tests ) ELSE ( set TEST=0 )

call:GetComputerName
call:CreateSmartOutput
call:Mailer
call:LocalMessage
GOTO END


:Log
echo %~1 >> "%ERROR_LOG_FILE%"
IF "%DEBUG%"=="yes" echo %~1
GOTO:EOF

:Tests
set TEST=1
SC QUERY smartd | FINDSTR "RUNNING" > nul
IF "%ERRORLEVEL%"=="0" (
set SERVICE_RUNS=1
set WARNING_MESSAGE=Smartmontools for Windows test: Service runinng
) ELSE (
set SERVICE_RUNS=0
set WARNING_MESSAGE=Smartmontools for Windows test: Service not running
)
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
set COMPUTER_FQDN=%COMPUTERNAME%
IF NOT "%USERDOMAIN%"=="" set COMPUTER_FQDN=%COMPUTERNAME%.%USERDOMAIN%
IF NOT "%USERDNSDOMAIN%"=="" set COMPUTER_FQDN=%COMPUTERNAME%.%USERDNSDOMAIN%
GOTO:EOF

:GetPwd
FOR /F %%i IN ('"echo %SMTP_PASSWORD% | base64 -d"') DO SET SMTP_PASSWORD=%%i
GOTO:EOF

:Mailer
IF NOT "%MAIL_ALERT%"=="yes" GOTO:EOF
IF "!TEST!"=="1" (
set SUBJECT=Smart test on %COMPUTER_FQDN%
) ELSE (
set SUBJECT=Smart Error on %COMPUTER_FQDN%
)
set MAIL_CONTENT=%DATE% - %WARNING_MESSAGE%

call:CheckMailValues
call:GetPwd
IF "%MAILER%"=="blat" call:MailerBlat
IF "%MAILER%"=="sendemail" call:MailerSendEmail
IF "%MAILER%"=="mailsend" call:MailerMailSend
GOTO:EOF

:MailerMailSend
set attachment=
IF "%COMPRESS_LOGS%"=="yes" (
	"%PROGRAM_PATH%\bin\gzip" -c "%SMART_LOG_FILE%" > "%SMART_LOG_FILE%.gz"
	set attachment=-attach "%SMART_LOG_FILE%.gz"
) ELSE (
	set attachment=-attach "%SMART_LOG_FILE%"
)

IF "%SECURITY%"=="tls" set encryption=-starttls
IF "%SECURITY%"=="ssl" set encryption=-ssl

IF NOT "%SMTP_USER%"=="" set smtpuser=-auth -user "%SMTP_USER%"
IF NOT "%SMTP_PASSWORD%"=="" set smtppassword=-pass "%SMTP_PASSWORD%"
IF %DRY%==1 (
	echo "%PROGRAM_PATH%\bin\mailsend.exe" -f "%SOURCE_MAIL%" -t "%DESTINATION_MAIL%" -sub "%SUBJECT%" -M "%MAIL_CONTENT%" %attachment% -smtp "%SMTP_SERVER%" -port %SMTP_PORT% %smtpuser% %smtppassword% %encrypt%
) ELSE (
	"%PROGRAM_PATH%\bin\mailsend.exe" -f "%SOURCE_MAIL%" -t "%DESTINATION_MAIL%" -sub "%SUBJECT%" -M "%MAIL_CONTENT%" %attachment% -smtp "%SMTP_SERVER%" -port %SMTP_PORT% %smtpuser% %smtppassword% %encrypt%
)
	IF NOT %ERRORLEVEL%==0 (
	set SCRIPT_ERROR=1
	Call:Log "Sending mail using mailsend failed."
)
GOTO:EOF

:MailerSendEmail
set attachment=
IF "%COMPRESS_LOGS%"=="yes" (
	"%PROGRAM_PATH%\bin\gzip" -c "%SMART_LOG_FILE%" > "%SMART_LOG_FILE%.gz"
	set attachment=-a "%SMART_LOG_FILE%.gz"
) ELSE (
	set attachment=-a "%SMART_LOG_FILE%"
)

IF "%SECURITY%"=="tls" set encryption=-o tls=yes
IF "%SECURITY%"=="ssl" set encryption=-o tls=auto

IF NOT "%SMTP_USER%"=="" set smtpuser=-xu "%SMTP_USER%"
IF NOT "%SMTP_PASSWORD%"=="" set smtppassword=-xp "%SMTP_PASSWORD%"
IF %DRY%==1 (
	echo "%PROGRAM_PATH%\bin\sendemail.exe" -f "%SOURCE_MAIL%" -t "%DESTINATION_MAIL%" -u "%SUBJECT%" -m "%MAIL_CONTENT%" %attachment% -s %SMTP_SERVER%:%SMTP_PORT% %encryption% %smtpuser% %smtppassword%
) ELSE (
	"%PROGRAM_PATH%\bin\sendemail.exe" -f "%SOURCE_MAIL%" -t "%DESTINATION_MAIL%" -u "%SUBJECT%" -m "%MAIL_CONTENT%" %attachment% -s %SMTP_SERVER%:%SMTP_PORT% %encryption% %smtpuser% %smtppassword% >> "%ERROR_LOG_FILE%"
)
	IF NOT %ERRORLEVEL%==0 (
	set SCRIPT_ERROR=1
	Call:Log "Sending mail using sendemail failed."
)
GOTO:EOF

:: Blat support needs blat mail parameters already in registry
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
