# Répertoire du marqueur : lanceurs parents — V60

V60 localise les étapes de lancement précédant potentiellement le patcher et documente leurs paramètres CreateProcess. Le répertoire courant effectif lors du test first_time reste non établi. Les tâches EMPTY-032-CLASSIFY et EMPTY-032-RESOLVE restent ouvertes ;aucun processus historique n'est lancé et aucun fichier natif n'est modifié.

## Identités observées

| Binaire fourni | Version observée | Provenance et limite |
|---|---|---|
| lol.launcher.exe à la racine | VERSIONINFO absente | 97 464octets,SHA-256 db8423dabbf877059ea31fd6bf4b1ff623f270f784c74f90ac75130c2dc522e1 ;artefact installé fourni,pas de build inventé |
| lol.launcher.admin.exe à la racine | VERSIONINFO absente | 97 464octets,SHA-256 70ac19c117958c60b56a2e9d0d489f70fae084467f703813cca361f898869848 ;même taille,octets différents |
| RADS/system/rads_user_kernel.exe | FileVersion et ProductVersion0.0.0.0 | 1 294 336octets,SHA-256 6b5ddc452ae70fa7dc1eb712e7b4101a3aac10da6c723f6c80a6bf11f698bd6b ;valeur fixe lue,sans l'assimiler au patcher ou au jeu |
| LoLLauncher.exe du projet lol_launcher | FileVersion et ProductVersion2.22.0.237 | 2 436 600octets,SHA-256 e6ea2025c142fc6a31f64bffecb3cf7f9b4e3e13aa23d7a4d1d61e01d9f6ed60 ;membre conforme au manifeste du projet0.0.0.227 |
| jpatch.exe du même déploiement | VERSIONINFO absente | 114 680octets,SHA-256 343bbb93670bfcbf584758146cf7d972510d0e60e7e9e10f80c6dbed3bef087c ;membre conforme au même manifeste,pas de build inventé |

Les deux membres deploy sont comparés par chemin,taille et MD5 au manifeste exact lol_launcher0.0.0.227. Les autres binaires sont identifiés dans la copie fournie,avec une provenance d'artefacts installés distincte. La lecture VERSIONINFO n'exécute aucun programme. Ces versions supplémentaires ne remplacent ni patcher0.4.0.122,AIR4.20.14_11_18_18_52,jeu4.20.0.315 ni catalogue4.20.1.

## Contrats et observations

Les appels d'import et fenêtres statiques sont enregistrés avec leurs octets. Les deux lanceurs racine contiennent la commande rads_user_kernel.exe updateandrun lol_launcher LoLLauncher.exe ;le mini-lanceur contient le nom LoLPatcher.exe. Ces chaînes ne constituent pas encore une preuve du dispatch complet.

La déclaration locale CreateProcessA/W du SDK Windows10.0.26100.0 fixe les dix positions d'arguments. Le header est identifié par chemin/version/SHA dans le reçu et sert uniquement de contrat d'API actuel,pas d'oracle de comportement Windows2014. Cinq blocs continus de dix push sont liés à cette déclaration :deux dans le lanceur racine,un dans la variante admin,un dans le user kernel et un dans le mini-lanceur.

Dans les trois appels des lanceurs racine,l'argument lpCurrentDirectory est alimenté par un LEA vers un tampon de pile,sans appel intermédiaire ni réécriture du registre. Ce sont des pointeurs explicites vers des tampons pour un caller valide ;leurs contenus restent à qualifier. Dans le bloc user-kernel4BCBD4,l'argument est un zéro littéral ;cela ne prouve pas la valeur du CWD hérité ni que ce bloc lance le patcher. Dans le mini-lanceur4BE5F0,l'argument vient de [ebp-0x8078] ;son producteur reste à tracer.

Cinq autres fenêtres d'appels sont partielles :pas de correspondance complète avec le modèle borné de dix push. Aucune absence d'appel ou de fonctionnalité n'en est déduite. Les prologues voisins restent des hypothèses de limites ;les chaînes sont sélectionnées jusqu'à60correspondances par binaire,ce n'est pas un graphe d'appels exhaustif.

## Résultats et suite

L'inventaire des cinq binaires termine avec succès. Les cinq blocs d'arguments et les trois définitions de pointeurs de pile sont vérifiés statiquement. Aucun CreateProcess,SetCurrentDirectory,programme historique ou instruction originale n'est exécuté dans V60. Les sondes Unicorn/JS et contrôles Store des étapes précédentes ne sont pas rejoués.

Il reste à qualifier le contenu des tampons racine,l'étape updateandrun du user kernel,le producteur du champ du mini-lanceur et les changements/restaurations du CWD jusqu'au test first_time. La création effective,les erreurs/exception,le pont popup et le consommateur actuel dédié restent ouverts. Intégrer seulement ces liens lorsqu'ils sont prouvés ;ne pas remplir le marqueur observé vide.

Sources détaillées :E:/mapslol3v3/Requirements_registry_4_20_2026-10-20/revision60/parent-launcher-CWD-research.json,parent-process-argument-qualification.json et root-CWD-pointer-definitions.json. Recherche partielle,en attente d'intégration au graphe. La livraison canonique V59 reste intacte :92 164sources,265ancres,918associations génériques et1469frontières seules,soit2387lacunes spécifiques visibles. Les six objectifs initiaux,les deux divergences4312/4313 et les évaluations communautaires restent ouverts selon leurs états. Toutes les cases,notes,révisions,consignes et tout l'historique sont conservés. Goal actif.
