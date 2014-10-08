Smartmontools for Windows von Orsiris "Ozy" de Jong
Doc Rev 1.5 (L) 2012-2013    http://www.netpower.fr

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

Die folgende Software wird von diesen Program benutzt:

- smartmontools by Bruce Allen & Christian Franke, http://smartmontools.sourceforge.net
- sendemail by Brandon Zehm, http://caspian.dotconf.net
- Mailsend by Muhammad Muquit, http://www.muquit.com
- Inno Setup by Jordan Russel, http://www.jrsoftware.org
- Gzip by Free Software Foundation, Inc. Copyright (C) 1992, 1993 Jean-loup Gailly, http://gnuwin32.sourceforge.net/
- Base64 by Matthias Gärtner, http://www.rtner.de/software/base64.htm
- dd by Chrysocome and John Newbigin, http://www.chrysocome.net/dd

Kommandozeilenparameter
-----------------------

smartmontools-win-6.3-1.exe [--short=S/../.././08] [--long=L/../../5/12] [--hddlist="/dev/pd0;/dev/csmi0,1"] [--checkhealth=(yes|no)] [--checkataerrors=(yes|no)] [--checkfailureusae=(yes|no)] [--reportselftesterrors=(yes|no] [--reportcurrentpendingsect=(yes|no)] [--reportofflinependingsect=(yes|no)] [--trackchangeusageprefail=(yes|no)] [--ignoretemperature=(yes|no)] [--powermode=(never|sleep|standby|idle)] [--maxskips=7] [-f source@mail.tld -t destination@mail.tld -s smtp.server.tld [--port=25] [-u smtpuser] [-p smtppassword] [--security=(none|tls|ssl)]] [--localmessages=(yes|no)] [--warningmessage="Your custom alert message"] [--compresslogs=(yes|no)] [--keepfirstlog=(yes|no)] [--sendtestmessage=(yes|no)] [--mailer=(mailsend|sendemail)] [/silent]

--short=S/../.././08 Regulärer Ausdruck mit Startzeit des kurzen Selbsttests. Wenn nicht angegeben: Jeden Tag 08:00 (siehe unten oder in der Manual-Seite zu smartd.conf)
--long=L/../../5/12  Regulärer Ausdruck mit Startzeit des langen Selbsttests.  Wenn nicht angegeben: Jeden Freitag um 12:00 (siehe unten oder in der Manual-Seite zu smartd.conf)
--hddlist="/dev/pd0;/dev/pd1;/dev/sdc" Liste mit durch Semikola getrennten Festplattengerätenamen. Wenn nicht angegeben, werden die Festplatten gesucht.
Beispiel: Für ein Intel-RAID mit 2 Festplatten --hddlist="/dev/csmi0,0;/dev/csmi0,1" (Ein Intel-Raid wird nicht immer richtig automatisch gefunden. Diese manuelle Version funktioniert immer).
--checkhealth=(yes|no) ist standardmäßig aktiviert
--checkataerrors=(yes|no) ist standardmäßig aktiviert
--checkfailureusage=(yes|no) ist standardmäßig aktiviert
--reportselftesterrors=(yes|no) ist standardmäßig aktiviert
--reportcurrentpendingsect=(yes|no) ist standardmäßig aktiviert
--reportofflineuncorrectsect=(yes|no) ist standardmäßig aktiviert
--trackchangeusageprefail=(yes|no) ist standardmäßig aktiviert
--ignoretemperature=(yes|no) ist standardmäßig aktiviert
--powermode=(never|sleep|standby|idle) Legt den minimalen Energiesparmodus fest, in dem die Selbsttests ausgeführt werden. Wenn nicht angegeben, wird "sleep" verwendet.
--maxskips=N Maximale Anzahl wegen des Energiesparmodus ausgelassener Tests bevor ein Test erzwungen wird. wenn nicht angegeben: 7

-f Absenderadresse für Warnungsemails
-t Zieladresse für Warnungsemails
-s SMTP-Server für Warnungsemails
--port=SMTP-Server Port (standard ist 25)
-u Benutzername für den SMTP-Server (optional)
-p Passwort für den SMTP-Server (optional)
--tls (no|auto|yes) TLS für SMTP benutzen, "no", wenn nicht angegeben
--localmessages (no|yes) Lokale Meldungen bei Fehlern anzeigen, "no" wenn nicht angegeben
--warningmessage="Ihre Persönliche Warnung Meldung", wenn nicht angegeben wird die Standard Meldung benutzt.
--compresslogs=(yes|no) Logdateien komprimieren, "yes": standard, wenn nicht angegeben oder nicht "no".
--keepfirstlog=(yes|no) Erste Logdatei behalten, "yes": standard, wenn nicht angegeben oder nicht "no".
--sendtestmessage=(yes|no) Testmail schicken, "yes": standard, wenn nicht angegeben oder nicht "no".
--mailer=(mailsend|sendemail) Mann kann einen Alternativen mailer benützen (mailsend ist standard)
/silent oder /verysilent: Keine Meldungen zur Installation ausgeben. Bitte beachten sie das dies die einzigen Parameter sind der mit Slash geschireben wird, da es sich um interne Inno Setup Paremeter handelt.

Siehe auch die Beispiele weiter unten.

Erklärung zu den regulären Ausdrücken für die Startzeit des Selbsttests:
----------------------------

Der reguläre Ausdruck hat die Form T/MM/DD/d/HH wobei:
T = Testtyp (S=kurz, L=lang)
MM = Monat (Januar = 01, Dezember = 12)
DD = Tag (01...31)
d = Wochentag (Montag = 1, Sonntag = 7)
HH = Stunde im 24h-Format

Jede der Zeitangaben kann durch Punkte ersetzt werden, die als Platzhalter für einen beliebigen Wert dienen.
Der folgende reguläre Ausdruck legt als Startzeit für einen langen Selbsttest jeden Dienstag und Freitag um 2 Uhr morgens fest:

L/../../[2,5]/02

Beispiele
---------

Einfache automatische Installation:

smartmontools-win-6.2-1.exe -f sourcemail@example.tld -t destination@example.tld -s smtp.of.your.isp.com /silent

Diese Kommandozeile würde smartmontools mit per email verschickten Warnmeldungen installieren,
Festplatten würden dabei automatisch erkannt werden, alle Überwachungsparameter würden verwendet werden,
und ein kurzer Selbsttest würde jeden Tag um 08:00, ein langer Selbsttest jeden Freitag um 12:00 ausgeführt werden.
Die Installation würde keine Meldungen ausgeben.


Folgendes weitere Beispiel würde TLS für SMTP und Benutzerauthentifizierung auf dem SMTP-Server verwenden,
keine Änderungen der Laufwerkstemperatur ignorieren, zeigt ebenfalls Lokale Warnungsmeldungen an und einen kurzen Selbsttest jeden Tag um 09:00
und einen langen Selbsttest jeden Dienstag und Sonntag um 02 Uhr morgens auf den Laufwerken /dev/pd0 und /dev/csmi0,1 ausführen:

smartmontools-win-6.3-1.exe -f sourcemail@example.tld -t destination@example.tld -s smtp.of.your.isp.com --port 587 -u username@smtp.server.tld -p pA55W0RD --tls=yes --ignoretemperature=no --hddlist=/dev/pd0;/dev/csmi0,1 --short=S/../.././09 --long=L/../../[2,7]/02 --localmessages=yes --mailer=sendemail /silent

Gmail issues
------------

Wenn sie gmail benützen, benützen sie die Parameter --security=ssl und --port=465
Der Parameter --security=tls wird mailsend blockieren.

--------------------------------------------------------------
