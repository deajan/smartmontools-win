Smartmontools for Windows Package
(C) 2012-2020 Orsiris de Jong - http://www.netpower.fr


Smartmontools for Windows est un package alternatif  pour smartmontools de Bruce Allen et Christian Franke et a été crée afin de pouvoir installer rapidement smartmontools en tant que service, utiliser le support d'alertes mail et locales et préconfigurer les options de monitoring S.M.A.R.T.
L'installation peut se faire en ligne de commandes pour un déploiement massif ou en graphique pour un utilisateur classique.

Les fichiers de configuration sont générés automatiqueement pour plus de facilité (cela étant, vous pouvez toujours les éditer à la main au besoin).

Un service nommé "SmartD" est crée et lancé aux démarrage du système. Celui-ci énumére les disques que smartmontools peut surveiller et envoi un email ou affiche un message en cas d'erreur.
Un fichier nommé smart.log est alors crée incluant toutes les informations des disques, et envoyé par mail. Un log des actions d'erreurs  est crée en tant que erroraction.log.

Ce logiciel et les logiciels qu'il installe sont sous licence GPL. Aucune responsabilité ne pourra être engagée cas de problèmes ou dysfonctionnements dus à l'usage de ce logiciel.

Neanmoins, vous pouvez écrire un email à ozy [at] netpower.fr pour un obtenir un support limité durant mon temps libre.

Mise à jour
-----------

Les fichiers de configuration des versions précédentes sont conservés (à mooins qu'un fichier smartd.conf et/ou erroraction_config.cmd sont fournis avec l'installeur).
Les options en ligne de commande de l'installeur ont énormément changés. Pensez à adapter vos éventuels scripts d'installation à la nouvelle syntaxre (voir ci-dessous).

Copyrights
----------

Les sources du package d'installation, les interfaces python sont distribués sous la licence GPLv2.
Cet installeur utilise les logiciels suivants:

- smartmontools by Bruce Allen, http://smartmontools.sourceforge.net
- sendemail by Brandon Zehm, http://caspian.dotconf.net
- Mailsend by Muhammad Muquit, http://www.muquit.com
- Inno Setup by Jordan Russel, http://www.jrsoftware.org
- Gzip by Free Software Foundation, Inc. Copyright (C) 1992, 1993 Jean-loup Gailly, http://gnuwin32.sourceforge.net/
- Base64 by Matthias Gärtner, http://www.rtner.de/software/base64.html
- dd by Chrysocome and John Newbigin, http://www.chrysocome.net/dd

Binaires
--------

Vous trouverez les derniers binaires sur la page http://www.netpower.fr/smartmontools-win

Compilation
-----------

La compilation fonctionne avec Inno Setup & Innot Preprocessor 5.5+.
Vous aurez besoin de télécharger les logiciels ci-dessus et les extraire aux endroits décrits par le fichier iis.
Les exécutables Python sont crées avec py2exe. Il suffit de renommer le dossier dist crée par les scripts de création d'exécutables.

Utilisation sous forme de script
--------------------------------

smartmontools-win-6.5-x.exe [OPTIONS]

[OPTIONS]

/COMPONENTS="liste des composants séparés par une virgule"

La liste des composants valide est:
core						Base de l'installation, ne peut être déselectionnée
core\service				Installer le service smartd
core\service\gui			Interface graphique pour configurer le service smartd et les alertes
core\service\mailalert		Envoyer un email en cas d'alerte
core\service\localalert		Afficher un message en cas d'alerte
core\scheduledtestalerts	Créer une alerte de test tous les mois
fixbadsecttools				Script de réparation de secteurs défectueux
reegext						Ajouter des options SMART au menu contextuel des disques durs
updatedb					Mettre à jour la base de données des disques après installation
authorlinks					Ajouter les liens vers le site de l'auteur
statistics					envoyer des statistiques anonymes sur l'installation

/SILENT						Installer smartmontools-win sans afficher l'interface graphique

/SUPPRESSMSGBOXES			Supprime la demande de confirmation d'écrasement de fichiers de configuration existants (à moins que des fichiers de configuration sont fournis avec l'installeur)

/HELP						Affiche l'ensemble des options de l'installeur

Voir les examples ci-dessous

Exemples d'utilisation
----------------------

Vous pouvez préconfigurer les options de smartd ainsi que les options d'alertes afin de créer une installation automatique.
Ajouter un fichier préconfiguré smartd.conf dans le dossier de l'installeur suffit à l'utiliser.
Ajouter un fichier préconfiguré erroraction_config.cmd dans le dossier de l'installeur suffit à l'utiliser.
Ces fichiers peuvent être trouvés à l'adressse https://github.com/deajan/smartmontools-win/tree/master/unattended

Il suffira alors de créer un dossier contenant les fichiers suivants
- smartmontools-win-6.5-x.exe
- smartd.conf
- erroraction_config.cmd

Pour exécuter l'installation en mode autonome:
smartmontools-win-6.5.x.exe /COMPONENTS="core\service,core\service\gui,core\service\mailsupport,updatedb,regext,authorlinks,statistics" /SUPPRESSMSGBOXES /SILENT