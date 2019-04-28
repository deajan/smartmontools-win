﻿## Smartmontools for Windows Package
(C) 2012-2017 Orsiris de Jong - http://www.netpower.fr

Smartmontools For Windows is an alternate package for smartmontools by Bruce Allen and Christian Franke, that has been created to smoothly install smartmontools as service,
support out of the box mail or local alerts, and configure smart daemon options with a graphical user interface.
Installation can be run silently with command line parameters for massive deployments, or with a graphical user interface.

Configuration files are automatically generated (but you can still enjoy manual editing of course).
A service called "smartd" is created and launched at system startups. This service will enumerate hard disks smartmontools can monitor and send an email and/or show a local message in case of errors.
Everytime smartd detects an issue, the current states of the drives are written to smart.log and an alert is triggered.
When mail / local alerts are triggered, all actions regarding alerts are logged to erroraction.log.

On install, the current states of all drives smartd can detect are written to smartmontools-install-(version).log for warranty issues.

The software has been tested on multiple platforms, nevertheless no responsibility will be taken for any problems or malfunctions that may occur while using this software.
Anyway, feel free to send a mail to ozy [at] netpower.fr for support on my free time.

## Announcement

I am currently working on implementing a new GUI based on the incredible PySimpleGUI project.
This will make configuration steps easier, as well as provide encrypted mail passwords.
Also, external dependencies like mailsend / gzip or others won't be needed anymore.
My current work involves Nuitka dependencies improvements I made, and better Tcl/Tk integration.
See Smartmontools-win-7.x issue #26 for a roadmap.

## Upgrade path

The configuration from previous installations is now kept (unless a smartd.conf and/or and erroraction_config.cmd file is provided along with the installer script).
The commandline options of the installer have heavily changed. Be sure to update your mass installer scripts according to new commandline syntax (see below).

## Copyrights

The package itself, the python interfaces and it's source code is licensed under GPLv2.
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

## Useful command line parameters

smartmontools-win-6.6-x.exe [OPTIONS]

[OPTIONS]

/COMPONENTS="comma separated list of component names"

This setting overrides the default selection.

Valid components are:
core 						Basic install, cannot be unselected
core\service 				Install smartd service
core\service\gui			Graphical user interface for smartd and alerts
core\service\mailalert		On alerts send an email
core\service\localalert		On alerts show messages on screen
core\scheduledtestalerts	Trigger a test alert every month
fixbadsecttools				Fix bad sector script
regext						Register SMART right click actions on drives
updatedb					Update drive database right after installation
authorlinks					Include links to the authors websites
statistics					Send anonymous install statistics

/SILENT 					Installs smartmontools-win silently, without showing the configuration GUI.

/SUPPRESSMSGBOXES			Removes the configuration files overwrite confirmation and keep the original configuration (unless new config files are supplied along with the installer).

/HELP						Shows all possible commandline switches

See examples below

## Unattended examples

You may want to preconfigure smartd settings or alert setting when making an unattended installation.
In that case you can install the package on a test computer, use the GUI to configure the service and alerts, and use the generated configuration files for a mass installation.
Putting a preconfigured smartd.conf file along with the setup exe will load it automatically.
Putting a preconfigured erroraction_config.cmd file along with the setup exe will automatically configure alert options.
Example files can be found at https://github.com/deajan/smartmontools-win/tree/master/unattended

Put the following files in the same directory
- smartmontools-win-6.6-1.exe
- smartd.conf
- erroraction_config.cmd

Then run:
smartmontools-win-6.6-1.exe /COMPONENTS="core\service,core\service\gui,core\service\mailsupport,updatedb,regext,authorlinks,statistics" /SUPPRESSMSGBOXES /SILENT

## Compilation

Compilation works with Inno Setup & Inno Preprocessor 5.5+.
You'll need to download all the software mentionned above and extract them to the corresponding directories listed in main iss file.

## Build python executables

In order to build python executables from source, you'll need:

pip install pygubu pywin32 cx_freeze

You may then run cxsetup.py in order to create executable versions of smartd-pyngui and erroraction_config
