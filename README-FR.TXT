Smartmontools for Windows écrit par Orsiris "Ozy" de Jong
Doc Rev 1.6 (L) 2012-2015          http://www.netpower.fr


Smartmontools for Windows est un package alternatif  pour smartmontools de Bruce Allen et Christian Franke et a été crée afin de pouvoir installer rapidement smartmontools en tant que service, utiliser le support d'alertes mail et locales et préconfigurer les options de monitoring S.M.A.R.T.
L'installation peut se faire en ligne de commandes pour un déploiement massif ou en graphique pour un utilisateur classique.

Les fichiers de configuration sont générés automatiqueement pour plus de facilité (cela étant, vous pouvez toujours les éditer à la main au besoin).

Un service nommé "SmartD" est crée et lancé aux démarrage du système. Celui-ci énumére les disques que smartmontools peut surveiller et envoi un email ou affiche un message en cas d'erreur.
Un fichier nommé smart.log est alors crée incluant toutes les informations des disques, et envoyé par mail. Un log des actions d'erreurs  est crée en tant que erroraction.log.

Ce logiciel et les logiciels qu'il installe sont sous licence GPL. Aucune responsabilité ne pourra être engagée cas de problèmes ou dysfonctionnements dus à l'usage de ce logiciel.

Neanmoins, vous pouvez écrire un email à ozy [at] netpower.fr pour un obtenir un support limité durant mon temps libre.

Cet installeur utilise les logiciels suivants:

- smartmontools by Bruce Allen, http://smartmontools.sourceforge.net
- sendemail by Brandon Zehm, http://caspian.dotconf.net
- Mailsend by Muhammad Muquit, http://www.muquit.com
- Inno Setup by Jordan Russel, http://www.jrsoftware.org
- Gzip by Free Software Foundation, Inc. Copyright (C) 1992, 1993 Jean-loup Gailly, http://gnuwin32.sourceforge.net/
- Base64 by Matthias Gärtner, http://www.rtner.de/software/base64.html
- dd by Chrysocome and John Newbigin, http://www.chrysocome.net/dd

Utilisation sous forme de script
--------------------------------

smartmontools-win-6.4-1.exe [--short=S/../.././10] [--long=L/../../5/13] [--hddlist="/dev/pd0;/dev/csmi0,1"] [--checkhealth=(yes|no)] [--checkataerrors=(yes|no)] [--checkfailureusae=(yes|no)] [--reportselftesterrors=(yes|no] [--reportcurrentpendingsect=(yes|no)] [--reportofflinependingsect=(yes|no)] [--trackchangeusageprefail=(yes|no)] [--ignoretemperature=(yes|no)] [--powermode=(never|sleep|standby|idle)] [--maxskips=7] [-f source@mail.tld -t destination@mail.tld -s smtp.server.tld [--port=25] [-u smtpuser] [-p smtppassword] [--security=(none|tls|ssl)]] [--localmessages=(yes|no)] [--warningmessage="Your custom alert message"] [--compresslogs=(yes|no)] [--keepfirstlog=(yes|no)] [--sendtestmessage=(yes|no)] [--mailer=(mailsend|sendemail)] [/silent]


--short=S/MM/DD/d/HH Expression régulière qui planifie l'exécution des autotests courts, par défaut tous les jours à 10h
	Vous pouvez désactiver les tests courts en spécifiant --short=no
	(Voir plus bas ou voir le manuel du fichier smartd.conf pour une explication détaillé des expressions régulieres utilisées)
--long=L/MM/DD/d/HH Expression régulière qui planifie l'exécution des autotests longs, par défaut tous les vendredis à 13h
	Vous pouvez désactiver les tests longs en spécifiant --long=no
	(Voir plus bas ou voir le manuel du fichier smartd.conf pour une explication détaillé des expressions régulieres utilisées))
--hddlist="/dev/pd0;/dev/pd1;/dev/sdc" Liste manuelle des disques durs séparés par un point virgule, si ce paramètre est omis, smartd essayera de détecter automatiquement vos disques.
Exemple: Pour un ensemble RAID intel de deux disques: --hddlist="/dev/csmi0,0;/dev/csmi0,1" (L'autodétection intel raid ne fonctionne pas toujours bien, la liste manuelle fonctionne toujours)
--checkhealth=(yes|no) est activé par défaut
--checkataerrors=(yes|no) est activé par défaut
--checkfailureusage=(yes|no) est activé par défaut
--reportselftesterrors=(yes|no) est activé par défaut
--reportcurrentpendingsect=(yes|no) est activé par défaut
--reportofflineuncorrectsect=(yes|no) est activé par défaut
--trackchangeusageprefail=(yes|no) est activé par défaut
--ignoretemperature=(yes|no) est activé par défaut
--powermode=(never|sleep|standby|idle) Determine le mode d'économie d'énergie minimal pour éffectuer les autotests. Par défaut, cette valeur est sleep
--maxskips=N Nombre maximal d'autotests à ne pas éffecteur selon le mode d'économie d'energie. Par défaut, ce nombre est 7.

-f Adresse email source de l'alerte
-t Adresse email de destination pour l'alerte
-s Votre serveur smtp
--port=Votre port smtp (par défaut 25)
-u Nom d'utilisateur du serveur smtp (non obligatoire)
-p Mot de passe du serveur smtp (non obligatoire)
--tls (no|auto|yes) Utilisation de la sécurité TLS, désactivée par défaut
--localmessages (no|yes) Affichage de messages d'alertes locaux, désactivé par défaut
--warningmessage="Votre message d'avertissement personnalisé". Si laissé vide, le message d'avertissement par défaut sera utilisé.
--compresslogs=(yes|no) Active ou désactive la compression des logs, cette option est activée par défaut
--keepfirstlog=(yes|no) Conserve le premier journal smart. Par défaut, ce paramètre est activé.
--sendtestmessage=(yes|no) Active ou désactive l'envoi d'un email de test. Ce paramètre est activé par défaut.
--mailer=(mailsend|sendemail) Il est possible d'utiliser un mailer alternatif (mailsend est le mailer par défaut)
/silent ou /verysilent sont les paramètres permettant une installation silencieuse. Attention à spécifier ce paremètre avec le slash plutôt que des tirets car il s'agit d'un paramètre de Inno Setup lui même.

Expressions régulieres des autotests
------------------------------------

Les expressions régulières sont au format T/MM/DD/d/HH où
T = le type de test (S=court, L=long)
MM = le mois (Janvier = 01, Décembre = 12)
DD = le jour du mois (01...31)
d = le jour de la semaine (Lundi = 1, Dimanche = 7)
HH = L'heure au format 24H

Ces valeurs peuvent être remplacés par des points qui sont des jokers. L'expression réguliere suivante planifie un test long tous les mardis et vendredis à 02h:

L/../../[2,5]/02

Exemples
--------

Installation automatisée basique:

smartmontools-win-6.4-1.exe -f sourcemail@example.tld -t destination@example.tld -s smtp.of.your.isp.com /silent

Cette ligne installe smartmontools avec le support des alertes par mail, l'autodétection des disques, l'utilisation de tous les paramètres de monitoring, et planifie l'exécution d'un autotest court tous les jours à 8h du matin et un autotest long tous les vendredis à midi.

Cet autre exemple utilise tls pour les emails, l'authentification du serveur SMTP, affiche également un message d'erreur local, monitore aussi les changements de température, désactive les autotests courts et planifie un autotest long tous les mardis et dimanches à 2h du matin pour les disques /dev/pd0 et /dev/csmi0,1

smartmontools-win-6.4-1.exe -f sourcemail@example.tld -t destination@example.tld -s smtp.of.your.isp.com --port 587 -u username@smtp.server.tld -p pA55W0RD --tls=yes --ignoretemperature=no --hddlist=/dev/pd0;/dev/csmi0,1 --short=no --long=L/../../[2,7]/02 --localmessages=yes /silent
