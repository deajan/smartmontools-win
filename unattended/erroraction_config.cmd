:: erroraction_config.cmd file for smartmontools for Windows v6.5+

:: Valid values are: yes, no
set MAIL_ALERT=yes


set SOURCE_MAIL=
set DESTINATION_MAIL=
set SMTP_SERVER=
set SMTP_PORT=25
set SMTP_USER=

:: SMTP Password must be encoded in base64 (example via https://www.base64encode.org)
set SMTP_PASSWORD=

:: Security may be: none, ssl or tls
set SECURITY=none

:: Valid values are: yes, no
set LOCAL_ALERT=no

:: You may change this to a customized warning message or leave it to the default
set WARNING_MESSAGE=[WARNING_MESSAGE]

:: Valid values are: yes, no
set COMPRESS_LOGS=yes

