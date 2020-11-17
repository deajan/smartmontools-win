Smartmontools for Windows Package
(C) 2012-2020 Orsiris de Jong - http://www.netpower.fr

Smartmontools for Windows ist ein alternatives Package für "Smartmontools" von Bruce Allen und Christian Franke.
Er wurde programmiert, um smartmontools als Dienst zu installieren, Warnungen per email versenden zu können oder Lokal anzeigen, und um die S.M.A.R.T-Überwachung zu konfigurieren.
Das Installationsprogramm kann skriptbasiert per Kommandozeile oder graphisch für eine normale Einzelplatzinstallation benutzt werden.

Die Konfigurationsdateien werden automatisch geschrieben (können aber trozdem per Hand geändert werden).

Ein Dienst "SmartD" wird installiert und für automatischen Start konfiguriert.
Dieser Dienst sucht nach allen Laufwerken, die smartmontools überwachen kann und schickt eine email, wenn ein Fehler auftritt.
Eine Logdatei "smart.log" wird angelegt mit allen Laufwerksinformationen, die auch per email geschickt werden. Eine Logdatei "erroraction.log" wird ebenfalls angelegt und enthält alle email Sendedaten und lokale Fehlermeldungen.

Diese Software und die Software, die installiert wird, wird unter der GPL-Lizenz verteilt.
Es wird keine Haftung für eventuelle Probleme oder Störungen übernommen, die durch den Einsatz dieser Software verursacht werden.

Dennoch können sie gerne eine email an ozy [at] netpower.fr schreiben für eingeschränkte Unterstüzung in meiner Freizeit.

Upgrade
-------

Die Konfigurationsdateien von älteren Installationen werden behalten.
Die Kommandozeilenparameter von den Installer haben sich viel geändert. Sie müssen ihre installer Scripts aktualisieren für die neuen Kommandozeilenparameter.

Copyright
---------

Der Installer, die Python Benützeroberfläche und der source sind unter GPLv2 lizenziert.
Die folgende Software wird von diesen Program benutzt:

- smartmontools by Bruce Allen & Christian Franke, http://smartmontools.sourceforge.net
- sendemail by Brandon Zehm, http://caspian.dotconf.net
- Mailsend by Muhammad Muquit, http://www.muquit.com
- Inno Setup by Jordan Russel, http://www.jrsoftware.org
- Gzip by Free Software Foundation, Inc. Copyright (C) 1992, 1993 Jean-loup Gailly, http://gnuwin32.sourceforge.net/
- Base64 by Matthias Gärtner, http://www.rtner.de/software/base64.htm
- dd by Chrysocome and John Newbigin, http://www.chrysocome.net/dd

Binärdatein
-----------

Sie können die letzten Binärdatein runterladen bei http://www.netpower.fr/smartmontools-win

Kompilieren
-----------

Der Installer kann mit Inno Setup 5.5+ kompiliert werden.
Alle vorstehenden tools mussen geladen werden und die Datein die von iis file angegeben werden kopiert werden.
Python programme sind mit py2exe kompiliert. Nach kompilation müssen die dist datein kopiert werden zu der datei die von iss Datei angegeben wurde.


Kommandozeilenparameter
-----------------------

smartmontools-win-6.5-x.exe [OPTIONEN]

[OPTIONEN]

/COMPONENTS="Komma separate Liste der komponenten"

Diese Option ubergehen die Defaultoptionen.

Acceptierbare komponentent sind
core						Basic Installation
core\service				smartd Dienst installieren
core\service\gui			Benützeroberfläche installieren
core\service\mailalert		Auf Fehler E-mail senden
core\service\localalert		Auf Fehler Error bericht anzeigen
core\scheduledtestalerts	Jeden monat ein test Fehler auslösen
fixbadsecttools				Defektsektor Reparaturscript installieren
regext						Recht-klick SMART Optionen für Festplatten einstellen
updatedb					Nach installation smart Festplattendatabase updaten
authorlinks					Link zur Internetseite einstellen
statistics					Anonyme Installationstatistik senden

/SILENT						Keine Meldungen zur Installation ausgeben

/SUPPRESSMSGBOXES			Konfigurationsdateien überschreiben ohne anfrage

/HELP						Alle Komandozeilenparameter anzeigen

Beispiele
---------

Sie können eine forfertige Konfigurationsdatei zur Installation hunzufügen.
Eine forfertige smartd.conf Datei kann mit den Installationsprogramm automatisch geladen werden.
Eine forfertige erroraction_config.cmd Datei kann mit den Installationsprogram automatisch geladen werden.
Beispieldatein können an folgender Adresse geladen werden: https://github.com/deajan/smartmontools-win/tree/master/unattended

Die Konfigurationsdateien müssen in der gleichen Datei als das Installationsprogram sein:
- smartmontools-win-6.5-x.exe
- smartd.conf
- erroraction_config.cmd

Laden mit:
smartmontools-win-6.5-1.exe /COMPONENTS="core\service,core\service\gui,core\service\mailsupport,updatedb,regext,authorlinks,statistics" /SUPPRESSMSGBOXES /SILENT