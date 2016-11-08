## Smartmontools for Windows Package
(C) 2012-2016 Orsiris de Jong - http://www.netpower.fr

Smartmontools For Windows is an alternate package for smartmontools by Bruce Allen and Christian Franke, and has been created to quickly install smartmontools as service,
support mail or local alerts, and preconfigure smart monitor options.
Installation can be run silently with command line parameters for massive deployments, or with a graphical user interface.

Configuration files are automatically generated (but you can still enjoy manual editing of course).
A service called "SmartD" is created and launched at system startups. This service will enumerate hard disks smartmontools can monitor and send an email and/or show a local message in case of errors.
A file called smart.log is created on error, including all smart information, and sent by mail. A error action log is created under erroraction.log.

Optionally, an initial smart.log file is kept on the disk, in the case you want to keep initial smart infos for warranty issues.

This software and the software it installs are under GPL licence. No responsibility will be taken for any problems or malfunctions that may occur while using this software.

Anyway,feel free to send a mail to ozy [at] netpower.fr for limited support on my free time.

## Upgrade path

The smartd.conf file from previous installations is now kept (unless a smartd.conf file is provided with the installer script).
The commandline options of the installer have heavily changed. Be sure to update your mass installer scripts according to new commandline syntax.

## Copyrights

The package itself and it's source code is licensed under GPLv2.
Additionnaly, it uses the following free software:

- smartmontools by Bruce Allen & Christian Franke, http://smartmontools.sourceforge.net
- smartd-pyngui by Orsiris de Jong, http://github.com/deajan/smartd-pyngui
- Mailsend by Muhammad Muquit, http://www.muquit.com
- Inno Setup by Jordan Russel, http://www.jrsoftware.org
- Gzip by Free Software Foundation, Inc. Copyright (C) 1992, 1993 Jean-loup Gailly, http://gnuwin32.sourceforge.net/
- Base64 by Matthias Gärtner, http://www.rtner.de/software/base64.htm
- dd by Chrysocome and John Newbigin, http://www.chrysocome.net/dd

## Binaries

You'll find the latest binaries at http://www.netpower.fr/smartmontools-win

## Compilation

Compilation works with Inno Setup & Inno Preprocessor 5.5+.
You'll need to download all the software mentionned above and extract them to the corresponding directories listed in main iss file.
Python executables are frozen versions with py2exe. Just rename the dist directory provided by the setup scripts and put them in the corresponding directories.

## Command line parameters

smartmontools-win-6.5.exe [-c c:\path\to\custom\smartd.conf] [-f source@mail.tld -t destination@mail.tld -s smtp.server.tld] [--port=25] [-u smtpuser] [-p smtppassword] [--security=(none|tls|ssl)]] [--localmessages=(yes|no)] [--warningmessage="Your custom alert message"] [--compresslogs=(yes|no)] [--keepfirstlog=(yes|no)] [--sendtestmessage=(yes|no)] [/silent]

-c Provide a custom smartd.conf for mass installation
-f Email address your alert mail will come from
-t destination email address for your alert
-s your smtp server
--port=your smtp server port (defaults to 25)
-u your smtp server username (not mandatory)
-p your smtp server password (not mandatory)
--tls (no|auto|yes) Use of TLS sécurity, is no if not defined
--localmessages=(no|yes) Display local warning messages on errors, is set to no if not defined
--warningmessage="Your custom warning message", if not set, the default warning message will be used
--compresslogs=(yes|no) is activated if not defined
--keepfirstlog=(yes|no) is activated if not defined
--sendtestmessage=(yes|no) is activated if not defined
/silent or /verysilent are silent switches. Please be aware these are the only switches using a slash, as they are Inno Setup internal logic switches.

See examples below

## Examples

A basic installation script:

smartmontools-win-6.5.exe -f sourcemail@example.tld -t destination@example.tld -s smtp.of.your.isp.com /silent

This line would silently install smartmontools mail alerts, autodetection of hdds, using all monitor parameters, and schedule a short selftest every day at 08AM and a long selftest every friday at 12AM.

An other example would be that would use tls for mails, authentificate on your ISP's SMTP server, never ignore temperature changes, show local warning messages, disables short tests and schedules a long selftest every tuesday and sunday at 02PM for the drives /dev/pd0 and /dev/csmi0,1 would look like

smartmontools-win-6.5.exe -c c:\smartd.conf -f sourcemail@example.tld -t destination@example.tld -s smtp.of.your.isp.com --port 587 -u username@smtp.server.tld -p pA55W0RD --tls=yes --localmessages=yes /silent
