Smartmontools for Windows �crit par Orsiris "Ozy" de Jong
Doc Rev 1.4 (C) 2012-2013          http://www.netpower.fr
---------------------------------------------------------

Pour l'utilisation en ligne de commandes, voir plus bas

Smartmontools for Windows est un package alternatif  pour smartmontools de Bruce Allen et Christian Franke et a �t� cr�e afin de pouvoir installer rapidement smartmontools en tant que service, utiliser le support d'alertes mail et locales et pr�configurer les options de monitoring S.M.A.R.T.
L'installation peut se faire en ligne de commandes pour un d�ploiement massif ou en graphique pour un utilisateur classique.

Les fichiers de configuration sont g�n�r�s automatiqueement pour plus de facilit� (cela �tant, vous pouvez toujours les �diter � la main au besoin).

Un service nomm� "SmartD" est cr�e et lanc� aux d�marrage du syst�me. Celui-ci �num�re les disques que smartmontools peut surveiller et envoi un email ou affiche un message en cas d'erreur.
Un fichier nomm� smart.log est alors cr�e incluant toutes les informations des disques, et envoy� par mail. Un log des actions d'erreurs  est cr�e en tant que erroraction.log.

Ce logiciel et les logiciels qu'il installe sont sous licence GPL. Aucune responsabilit� ne pourra �tre engag�e cas de probl�mes ou dysfonctionnements dus � l'usage de ce logiciel.

Neanmoins, vous pouvez �crire un email � ozy [at] netpower.fr pour un obtenir un support limit� durant mon temps libre.
Si vous aimez ce produit ou l'utilisez de mani�re profesionnelle, vous pouvez sponsoriser le projet sur mon site, 99% des b�n�fices seront revers�s dans la machine � caf� :)

Cet installeur utilise les logiciels suivants:

- smartmontools by Bruce Allen, http://smartmontools.sourceforge.net
- sendemail by Brandon Zehm, http://caspian.dotconf.net
- Inno Setup by Jordan Russel, http://www.jrsoftware.org
- Gzip by Free Software Foundation, Inc. Copyright (C) 1992, 1993 Jean-loup Gailly, http://gnuwin32.sourceforge.net/
- Base64 by Matthias G�rtner, http://www.rtner.de/software/base64.html

Utilisation sous forme de script
--------------------------------

smartmontools-win-6.2-1.exe [--short=S/../.././08] [--long=L/../../5/12] [--hddlist="/dev/pd0;/dev/csmi0,1"] [--checkhealth=(yes|no)] [--checkataerrors=(yes|no)] [--checkfailureusae=(yes|no)] [--reportselftesterrors=(yes|no] [--reportcurrentpendingsect=(yes|no)] [--reportofflinependingsect=(yes|no)] [--trackchangeusageprefail=(yes|no)] [--ignoretemperature=(yes|no)] [--powermode=(never|sleep|standby|idle)] [--maxskips=7] [-f source@mail.tld -t destination@mail.tld -s smtp.server.tld [-u smtpuser] [-p smtppassword] [--tls=no]] [--localmessages=(yes|no)] [--warningmessage="Your personnal alert message"] [--compresslogs=(yes|no)] [--keepfirstlog=(yes|no)] [--sendtestmessage=(yes|no)] [/silent]


--short Expression r�guli�re qui planifie l'ex�cution des autotests cours, par d�faut tous les jours � 8h (voir plus bas ou voir le manuel du fichier smartd.conf)
--long Expression r�guli�re qui planifie l'ex�cution des autotests longs, par d�faut tous les vendredis � 12h (voir plus bas ou voir le manuel du fichier smartd.conf)
--hddlist="/dev/pd0;/dev/pd1;/dev/sdc" Liste manuelle des disques durs s�par�s par un point virgule, si ce param�tre est omis, smartd essayera de d�tecter automatiquement vos disques.
Exemple: Pour un ensemble RAID intel de deux disques: --hddlist="/dev/csmi0,0;/dev/csmi0,1" (L'autod�tection intel raid ne fonctionne pas toujours bien, la liste manuelle fonctionne toujours)
--checkhealth=(yes|no) est activ� par d�faut
--checkataerrors=(yes|no) est activ� par d�faut
--checkfailureusage=(yes|no) est activ� par d�faut
--reportselftesterrors=(yes|no) est activ� par d�faut
--reportcurrentpendingsect=(yes|no) est activ� par d�faut
--reportofflineuncorrectsect=(yes|no) est activ� par d�faut
--trackchangeusageprefail=(yes|no) est activ� par d�faut
--ignoretemperature=(yes|no) est activ� par d�faut
--powermode=(never|sleep|standby|idle) Determine le mode d'�conomie d'�nergie minimal pour �ffectuer les autotests. Par d�faut, cette valeur est sleep
--maxskips=N Nombre maximal d'autotests � ne pas �ffecteur selon le mode d'�conomie d'energie. Par d�faut, ce nombre est 7.

-f Adresse email source de l'alerte
-t Adresse email de destination pour l'alerte
-s Votre serveur smtp
-u Nom d'utilisateur du serveur smtp (non obligatoire)
-p Mot de passe du serveur smtp (non obligatoire)
--tls (no|auto|yes) Utilisation de la s�curit� TLS, d�sactiv�e par d�faut
--localmessages (no|yes) Affichage de messages d'alertes locaux, d�sactiv� par d�faut
--warningmessage="Votre message d'avertissement personnalis�". Si laiss� vide, le message d'avertissement par d�faut sera utilis�.
--compresslogs=(yes|no) Active ou d�sactive la compression des logs, cette option est activ�e par d�faut
--keepfirstlog=(yes|no) Conserve le premier journal smart. Par d�faut, ce param�tre est activ�.
--sendtestmessage=(yes|no) Active ou d�sactive l'envoi d'un email de test. Ce param�tre est activ� par d�faut.
/silent ou /verysilent sont les param�tres permettant une installation silencieuse. Attention � sp�cifier ce parem�tre avec le slash plut�t que des tirets car il s'agit d'un param�tre de Inno Setup lui m�me.

Expressions r�gulieres des autotests
------------------------------------

Les expressions r�guli�res sont au format T/MM/DD/d/HH o�
T = le type de test (S=court, L=long)
MM = le mois (Janvier = 01, D�cembre = 12)
DD = le jour du mois (01...31)
d = le jour de la semaine (Lundi = 1, Dimanche = 7)
HH = L'heure au format 24H

Ces valeurs peuvent �tre remplac�s par des points qui sont des jokers. L'expression r�guliere suivante planifie un test long tous les mardis et vendredis � 02h:

L/../../[2,5]/02

Exemples
--------

Installation automatis�e basique:

smartmontools-win-6.2-1.exe -f sourcemail@example.tld -t destination@example.tld -s smtp.of.your.isp.com /silent

Cette ligne installe smartmontools avec le support des alertes par mail, l'autod�tection des disques, l'utilisation de tous les param�tres de monitoring, et planifie l'ex�cution d'un autotest court tous les jours � 8h du matin et un autotest long tous les vendredis � midi.

Cet autre exemple utilise tls pour les emails, l'authentification du serveur SMTP, affiche �galement un message d'erreur local, monitore aussi les changements de temp�rature, planifie un autotest court tous les jours � 9h et un autotest long tous les mardis et dimanches � 2h du matin pour les disques /dev/pd0 et /dev/csmi0,1

smartmontools-win-6.2-1.exe -f sourcemail@example.tld -t destination@example.tld -s smtp.of.your.isp.com -u username@smtp.server.tld -p pA55W0RD --tls=yes --ignoretemperature=no --hddlist=/dev/pd0;/dev/csmi0,1 --short=S/../.././09 --long=L/../../[2,7]/02 --localmessages=yes /silent


--------------------------------------------------------------
