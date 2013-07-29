Smartmontools for Windows von Orsiris "Ozy" de Jong
Doc Rev 1.4 (C) 2012-2013    http://www.netpower.fr
---------------------------------------------------

F�r Kommandozeilensyntax bitte nach unten scrollen.

Smartmontools for Windows ist ein alternatives Package f�r "Smartmontools" von Bruce Allen und Christian Franke.
Er wurde programmiert, um smartmontools als Dienst zu installieren, Warnungen per email versenden zu k�nnen oder Lokal anzeigen, und um die S.M.A.R.T-�berwachung zu konfigurieren.
Das Installationsprogramm kann skriptbasiert per Kommandozeile oder graphisch f�r eine normale Einzelplatzinstallation benutzt werden.

Die Konfigurationsdateien werden automatisch geschrieben (k�nnen aber trozdem per Hand ge�ndert werden).

Ein Dienst "SmartD" wird installiert und f�r automatischen Start konfiguriert.
Dieser Dienst sucht nach allen Laufwerken, die smartmontools �berwachen kann und schickt eine email, wenn ein Fehler auftritt.
Eine Logdatei "smart.log" wird angelegt mit allen Laufwerksinformationen, die auch per email geschickt werden. Eine Logdatei "erroraction.log" wird ebenfalls angelegt und enth�lt alle email Sendedaten und lokale Fehlermeldungen.

Diese Software und die Software, die installiert wird, wird unter der GPL-Lizenz verteilt.
Es wird keine Haftung f�r eventuelle Probleme oder St�rungen �bernommen, die durch den Einsatz dieser Software verursacht werden.

Dennoch k�nnen sie gerne eine email an ozy [at] netpower.fr schreiben f�r eingeschr�nkte Unterst�zung in meiner Freizeit.
Solten sie dieses Produkt m�gen oder kommerziell benutzen, k�nnen sie auf meiner seite das Projekt sponsoren, 99% des Gewinns geht in die Kaffeemaschine :)

Die folgende Software wird von diesen Program benutzt:

- smartmontools by Bruce Allen & Christian Franke, http://smartmontools.sourceforge.net
- sendemail by Brandon Zehm, http://caspian.dotconf.net
- Inno Setup by Jordan Russel, http://www.jrsoftware.org
- Gzip by Free Software Foundation, Inc. Copyright (C) 1992, 1993 Jean-loup Gailly, http://gnuwin32.sourceforge.net/
- Base64 by Matthias G�rtner, http://www.rtner.de/software/base64.htm

Kommandozeilenparameter
-----------------------

smartmontools-win-6.2-1.exe [--short=S/../.././08] [--long=L/../../5/12] [--hddlist="/dev/pd0;/dev/csmi0,1"] [--checkhealth=(yes|no)] [--checkataerrors=(yes|no)] [--checkfailureusae=(yes|no)] [--reportselftesterrors=(yes|no] [--reportcurrentpendingsect=(yes|no)] [--reportofflinependingsect=(yes|no)] [--trackchangeusageprefail=(yes|no)] [--ignoretemperature=(yes|no)] [--powermode=(never|sleep|standby|idle)] [--maxskips=7] [-f source@mail.tld -t destination@mail.tld -s smtp.server.tld [-u smtpuser] [-p smtppassword] [--tls=no]] [--localmessages=(yes|no)] [--warningmessage="Your personnal alert message"] [--compresslogs=(yes|no)] [--keepfirstlog=(yes|no)] [--sendtestmessage=(yes|no)] [/silent]

--short=S/../.././08 Regul�rer Ausdruck mit Startzeit des kurzen Selbsttests. Wenn nicht angegeben: Jeden Tag 08:00 (siehe unten oder in der Manual-Seite zu smartd.conf)
--long=L/../../5/12  Regul�rer Ausdruck mit Startzeit des langen Selbsttests.  Wenn nicht angegeben: Jeden Freitag um 12:00 (siehe unten oder in der Manual-Seite zu smartd.conf)
--hddlist="/dev/pd0;/dev/pd1;/dev/sdc" Liste mit durch Semikola getrennten Festplattenger�tenamen. Wenn nicht angegeben, werden die Festplatten gesucht.
Beispiel: F�r ein Intel-RAID mit 2 Festplatten --hddlist="/dev/csmi0,0;/dev/csmi0,1" (Ein Intel-Raid wird nicht immer richtig automatisch gefunden. Diese manuelle Version funktioniert immer).
--checkhealth=(yes|no) ist standardm��ig aktiviert
--checkataerrors=(yes|no) ist standardm��ig aktiviert
--checkfailureusage=(yes|no) ist standardm��ig aktiviert
--reportselftesterrors=(yes|no) ist standardm��ig aktiviert
--reportcurrentpendingsect=(yes|no) ist standardm��ig aktiviert
--reportofflineuncorrectsect=(yes|no) ist standardm��ig aktiviert
--trackchangeusageprefail=(yes|no) ist standardm��ig aktiviert
--ignoretemperature=(yes|no) ist standardm��ig aktiviert
--powermode=(never|sleep|standby|idle) Legt den minimalen Energiesparmodus fest, in dem die Selbsttests ausgef�hrt werden. Wenn nicht angegeben, wird "sleep" verwendet.
--maxskips=N Maximale Anzahl wegen des Energiesparmodus ausgelassener Tests bevor ein Test erzwungen wird. wenn nicht angegeben: 7

-f Absenderadresse f�r Warnungsemails
-t Zieladresse f�r Warnungsemails
-s SMTP-Server f�r Warnungsemails
-u Benutzername f�r den SMTP-Server (optional)
-p Passwort f�r den SMTP-Server (optional)
--tls (no|auto|yes) TLS f�r SMTP benutzen, "no", wenn nicht angegeben
--localmessages (no|yes) Lokale Meldungen bei Fehlern anzeigen, "no" wenn nicht angegeben
--warningmessage="Ihre Pers�nliche Warnung Meldung", wenn nicht angegeben wird die Standard Meldung benutzt.
--compresslogs=(yes|no) Logdateien komprimieren, "yes": standard, wenn nicht angegeben oder nicht "no".
--keepfirstlog=(yes|no) Erste Logdatei behalten, "yes": standard, wenn nicht angegeben oder nicht "no".
--sendtestmessage=(yes|no) Testmail schicken, "yes": standard, wenn nicht angegeben oder nicht "no".
/silent oder /verysilent: Keine Meldungen zur Installation ausgeben. Bitte beachten sie das dies die einzigen Parameter sind der mit Slash geschireben wird, da es sich um interne Inno Setup Paremeter handelt.

Siehe auch die Beispiele weiter unten.

Erkl�rung zu den regul�ren Ausdr�cken f�r die Startzeit des Selbsttests:
----------------------------

Der regul�re Ausdruck hat die Form T/MM/DD/d/HH wobei:
T = Testtyp (S=kurz, L=lang)
MM = Monat (Januar = 01, Dezember = 12)
DD = Tag (01...31)
d = Wochentag (Montag = 1, Sonntag = 7)
HH = Stunde im 24h-Format

Jede der Zeitangaben kann durch Punkte ersetzt werden, die als Platzhalter f�r einen beliebigen Wert dienen.
Der folgende regul�re Ausdruck legt als Startzeit f�r einen langen Selbsttest jeden Dienstag und Freitag um 2 Uhr morgens fest:

L/../../[2,5]/02

Beispiele
---------

Einfache automatische Installation:

smartmontools-win-6.2-1.exe -f sourcemail@example.tld -t destination@example.tld -s smtp.of.your.isp.com /silent

Diese Kommandozeile w�rde smartmontools mit per email verschickten Warnmeldungen installieren,
Festplatten w�rden dabei automatisch erkannt werden, alle �berwachungsparameter w�rden verwendet werden,
und ein kurzer Selbsttest w�rde jeden Tag um 08:00, ein langer Selbsttest jeden Freitag um 12:00 ausgef�hrt werden.
Die Installation w�rde keine Meldungen ausgeben.


Folgendes weitere Beispiel w�rde TLS f�r SMTP und Benutzerauthentifizierung auf dem SMTP-Server verwenden,
keine �nderungen der Laufwerkstemperatur ignorieren, zeigt ebenfalls Lokale Warnungsmeldungen an und einen kurzen Selbsttest jeden Tag um 09:00
und einen langen Selbsttest jeden Dienstag und Sonntag um 02 Uhr morgens auf den Laufwerken /dev/pd0 und /dev/csmi0,1 ausf�hren:

smartmontools-win-6.2-1.exe -f sourcemail@example.tld -t destination@example.tld -s smtp.of.your.isp.com -u username@smtp.server.tld -p pA55W0RD --tls=yes --ignoretemperature=no --hddlist=/dev/pd0;/dev/csmi0,1 --short=S/../.././09 --long=L/../../[2,7]/02 --localmessages=yes /silent


--------------------------------------------------------------
