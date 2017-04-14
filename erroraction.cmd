:: Smartmontools for Windows package v6.5 erroraction.cmd 2017041201
:: http://www.netpower.fr
:: (L) 2012-2017 by Orsiris de Jong

:: Config can be changed in erroraction_config.cmd

:: CHANGELOG:
:: 13 Avr 2017:
:: - Fixed preflight checks because of ambiguous batch syntax
:: 12 Avr 2017:
:: - Added more preflight checks
:: - Fixed syntax in smartctl device erxpansion
:: - Added exit code
:: 12 Nov 2016:
:: - Fixed password cannot contain '!' character
:: - Added -M environment variables from smartd
:: - Added date in logs
:: 10 Nov 2016:
:: - Added default mailer
:: - Added admin privileges check
:: - CreateSmartOutput now uses drive definitions found in smartd.conf in order to get drive status
:: - Added GetEnvironment function to check for executables before launching
:: - Better test message

@echo off
:: Needed in order to let password end with '!' character
setlocal disabledelayedexpansion

:: Get currentdir
:: Get Script working dir if erroraction.cmd is launched as scheduled task
set curdir=%~dp0
set curdir=%curdir:~0,-1%

:: Load autgenerated configuration
call "%curdir%\erroraction_config.cmd"

set DEBUG=yes
set SCRIPT_ERROR=0

set ERROR_LOG_FILE=%curdir%\erroraction.log
set SMART_LOG_FILE=%curdir%\smart.log

:: Add SMARTD environment variables to WARNING_MESSAGE
set WARNING_MESSAGE=%WARNING_MESSAGE% - SMARTD DETAILS: %SMARTD_TFIRST% %SMARTD_FULLMESSAGE% %SMARTD_DEVICE% %SMARTD_DEVICETYPE% %SMARTD_DEVICESTRING% %SMARTD_FAILTYPE%

IF "%1"=="--dryrun" ( set DRY=1 ) ELSE ( set DRY=0 )
IF "%1"=="--test" ( call:Tests ) ELSE ( set TEST=0 )

:: GetEnvironment is the only function that triggers premature end of the script as other failures might not interrupt processing
call:GetEnvironment
IF "!SCRIPT_ERROR!"=="1" GOTO END
call:GetComputerName
call:CreateSmartOutput
call:Mailer
call:LocalMessage
GOTO END


:Log
echo %DATE:~0,2%-%DATE:~3,2%-%DATE:~6,4% %TIME:~0,2%H%TIME:~3,2%m%TIME:~6,2%s - %~1 >> "%ERROR_LOG_FILE%"
echo %~1
GOTO:EOF

:Tests
set TEST=1
SC QUERY smartd | FINDSTR "RUNNING" > nul 2> nul
IF "%ERRORLEVEL%"=="0" (
set SERVICE_RUNS=1
set WARNING_MESSAGE=Smartmontools for Windows test: Service smartd is runinng
) ELSE (
set SERVICE_RUNS=0
set WARNING_MESSAGE=Alert: Smartmontools for Windows test: Service smartd is not running
)
GOTO:EOF

:GetEnvironment

:: Check for PC privileges :)
net session >nul 2>&1
IF NOT %ERRORLEVEL%==0 (
	call:Log "PC checked for insufficient privileges"
	SET SCRIPT_ERROR=1
	)
dir "%curdir%\smartd.conf" > nul 2> nul
IF NOT %ERRORLEVEL%==0 (
	call:Log "Missing smartd.conf file"
	SET SCRIPT_ERROR=1
	)
dir "%curdir%\smartctl.exe" > nul 2> nul
IF NOT %ERRORLEVEL%==0 (
	call:Log "Missing smartctl.exe file"
	SET SCRIPT_ERROR=1
	)

:: Incoherent %ERRORLEVEL% and !ERRORLEVEL!... Get your shit toghether cmd
dir "%curdir%\wtssendmsg.exe" > nul 2> nul
IF NOT %ERRORLEVEL%==0 (
	IF "%LOCAL_ALERT%"=="yes" call:Log "Missing wtssendmsg.exe file. Did you install without local alert support ?" && SET SCRIPT_ERROR=1
	)

dir "%curdir%\mailsend.exe" > nul 2> nul
IF NOT %ERRORLEVEL%==0 (
	IF "%MAIL_ALERT%"=="yes" call:Log "Missing mailsend.exe file. Did you install without  mail alert support ?" && SET SCRIPT_ERROR=1
	)
	
dir "%curdir%\base64.exe" > nul 2> nul
IF NOT %ERRORLEVEL%==0 (
	IF "%MAIL_ALERT%"=="yes" call:Log "Missing base64.exe file. Did you install without  mail alert support ?"
		SET SCRIPT_ERROR=1
		)
	
dir "%curdir%\gzip.exe" > nul 2> nul
IF NOT %ERRORLEVEL%==0 (
	IF "%MAIL_ALERT%"=="yes" call:Log "Missing gzip.exe file. Did you install without  mail alert support ?" && SET SCRIPT_ERROR=1
		SET SCRIPT_ERROR=1
		)
	

:CheckMailValues
echo "%SOURCE_MAIL%" | findstr /I "@" > nul
IF %ERRORLEVEL%==1 (
	call:Log "Source mail not set"
	GOTO END
	)
echo "%DESTINATION_MAIL%" | findstr /I "@" > nul
IF %ERRORLEVEL%==1 (
	call:Log "Destination Mail not Set"
	GOTO END
	)
IF "%SUBJECT%"=="" (
	call:Log "Mail subject not set"
	GOTO END
	)
echo "%SMTP_SERVER%" | findstr /I "." > nul
IF %ERRORLEVEL%==1 (
	call:Log "Smtp sever not set"
	GOTO END
	)
call:Log "Configuration file check success."
GOTO:EOF

:CreateSmartOutput
echo ------------------------------------------------------------------------------------------------- %DATE:~0,2%-%DATE:~3,2%-%DATE:~6,4% %TIME:~0,2%H%TIME:~3,2%m%TIME:~6,2%s >> "%SMART_LOG_FILE%"
for /F %%d in ('type "%curdir%\smartd.conf" ^| findstr /R /C:"^/"') do "%curdir%\smartctl.exe" -a %%d >> "%SMART_LOG_FILE%"
for /F %%d in ('type "%curdir%\smartd.conf" ^| findstr /R /C:"^DEVICESCAN"') do SET DEVICESCAN=yes
IF "%DEVICESCAN%"=="yes" FOR /F "delims= " %%i in ('"%curdir%\smartctl.exe" --scan') do "%curdir%\smartctl.exe" -a %%i >> "%SMART_LOG_FILE%"
IF %ERRORLEVEL%==1 call:Log "Cannot extract smartctl data."
GOTO:EOF

:GetComputerName
set COMPUTER_FQDN=%COMPUTERNAME%
IF NOT "%USERDOMAIN%"=="" set COMPUTER_FQDN=%COMPUTERNAME%.%USERDOMAIN%
IF NOT "%USERDNSDOMAIN%"=="" set COMPUTER_FQDN=%COMPUTERNAME%.%USERDNSDOMAIN%
GOTO:EOF

:GetPwd
:: Disable delayed expansion as there is no way the password can end with an exclamation mark if set
:: Dear people who invented batch, delayed expansion and those superb %dp~n variable namings, there's a special place in hell (or whatever afwul thing you believe in) for you !
FOR /F "delims=" %%p IN ('"echo %SMTP_PASSWORD% | "%curdir%\base64.exe" -d"') DO SET SMTP_PASSWORD=%%p
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
IF "%MAILER%"=="" call:MailerMailSend
GOTO:EOF

:MailerMailSend
set attachment=
IF "%COMPRESS_LOGS%"=="yes" (
	"%curdir%\gzip" -c "%SMART_LOG_FILE%" > "%SMART_LOG_FILE%.gz"
	set attachment=-attach "%SMART_LOG_FILE%.gz,application/gzip,a"
) ELSE (
	set attachment=-attach "%SMART_LOG_FILE%"
)

IF "%SECURITY%"=="tls" set encryption=-starttls
IF "%SECURITY%"=="ssl" set encryption=-ssl

IF NOT "%SMTP_USER%"=="" set smtpuser=-auth -user "%SMTP_USER%"
IF NOT "%SMTP_PASSWORD%"=="" set smtppassword=-pass "%SMTP_PASSWORD%"
IF %DRY%==1 (
	echo "%curdir%\mailsend.exe" -f "%SOURCE_MAIL%" -t "%DESTINATION_MAIL%" -sub "%SUBJECT%" -M "%MAIL_CONTENT%" %attachment% -smtp "%SMTP_SERVER%" -port %SMTP_PORT% %smtpuser% %smtppassword% %encryption%
) ELSE (
	"%curdir%\mailsend.exe" -f "%SOURCE_MAIL%" -t "%DESTINATION_MAIL%" -sub "%SUBJECT%" -M "%MAIL_CONTENT%" %attachment% -smtp "%SMTP_SERVER%" -port %SMTP_PORT% %smtpuser% %smtppassword% %encryption%
)
	IF NOT %ERRORLEVEL%==0 (
	set SCRIPT_ERROR=1
	Call:Log "Sending mail using mailsend failed."
)
GOTO:EOF

:: SendEmail from Brandon Zehm mailer (http://caspian.dotconf.net), kept for compatibility
:MailerSendEmail
set attachment=
IF "%COMPRESS_LOGS%"=="yes" (
	"%curdir%\gzip" -c "%SMART_LOG_FILE%" > "%SMART_LOG_FILE%.gz"
	set attachment=-a "%SMART_LOG_FILE%.gz"
) ELSE (
	set attachment=-a "%SMART_LOG_FILE%"
)

IF "%SECURITY%"=="tls" set encryption=-o tls=yes
IF "%SECURITY%"=="ssl" set encryption=-o tls=auto

IF NOT "%SMTP_USER%"=="" set smtpuser=-xu "%SMTP_USER%"
IF NOT "%SMTP_PASSWORD%"=="" set smtppassword=-xp "%SMTP_PASSWORD%"
IF %DRY%==1 (
	echo "%curdir%\sendemail.exe" -f "%SOURCE_MAIL%" -t "%DESTINATION_MAIL%" -u "%SUBJECT%" -m "%MAIL_CONTENT%" %attachment% -s %SMTP_SERVER%:%SMTP_PORT% %encryption% %smtpuser% %smtppassword%
) ELSE (
	"%curdir%\sendemail.exe" -f "%SOURCE_MAIL%" -t "%DESTINATION_MAIL%" -u "%SUBJECT%" -m "%MAIL_CONTENT%" %attachment% -s %SMTP_SERVER%:%SMTP_PORT% %encryption% %smtpuser% %smtppassword%
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
	echo "%curdir%\wtssendmsg.exe" %local_alert_type_switch% "%WARNING_MESSAGE% [%COMPUTER_FQDN%]"
) ELSE (
	"%curdir%\wtssendmsg.exe" %local_alert_type_switch% "%WARNING_MESSAGE% [%COMPUTER_FQDN%]"
)
IF NOT %ERRORLEVEL%==0 (
	set SCRIPT_ERROR=1
	Call:Log "Sending local message using wtssendmsg failed."
)
GOTO:EOF

:END
:: Keeping the ping part in order to let commandline window open for some seconds after execution
IF NOT %SCRIPT_ERROR%==0 echo Something bad happened while executing this script. Please check log file. You can also check what happens with parameter --dryrun && ping 127.0.0.1 > nul && exit /b 1
exit /b 0
