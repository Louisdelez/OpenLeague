# SYS-01.2-02 — Contrats locaux de livraison et consommateurs, V785

Projet : F:/OpenLeague. Le référentiel du jeu demeure LoL PUBLIC4.20.0.315, EUW/en_GB. Cette révision qualifie les liens de livraison d’OpenLeague ; elle ne reproduit ni ne valide le patcher Riot.

## Résultat intégré

Les34exigences D24 reçoivent une base contractuelle locale explicite, liée à leur identifiant dans D24.md, aux documents et artefacts actuels, puis à leurs consommateurs conservés. Sept sources locales supplémentaires sont identifiées ;93liens vers21consommateurs restent conservés. Leurs empreintes et lignes sont vérifiées. Les contrats et limites de V15 sont conservés et rapprochés du projet actuel sur F.

Trois liens restent dans l’historique mais sortent des consommateurs actifs de leur exigence :

| Tâche | Lien conservé hors périmètre | Motif |
| --- | --- | --- |
| SYS-24.2-05 | sessions::status | Lire l’état du superviseur ne sauvegarde pas les données utilisateur avant migration. |
| SYS-24.2-06 | sessions::resume | Relancer un client de la partie détenue ne restaure pas des données après migration. |
| SYS-24.3-07 | sessions::resume | La capacité de reprise en mémoire ne démontre pas la persistance des paramètres après redémarrage Windows. |

Le lecteur réel du plan utilise consumer_scope_exclusions pour signaler ces limites dans le texte copié. Les liens ne sont pas effacés et les questions ouvertes sont conservées.

## Exécution du consommateur réel

Le module tools/download_assets.py est importé et exécuté sans modification. Les24cas utilisent de minuscules ZIP créés sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision785_delivery_runtime. Ce sont des données de test locales explicitement fabriquées ; elles ne remplacent aucune ressource historique ou archive de livraison réelle.

| Contrôle | Résultat attendu et observé |
| --- | --- |
| Fichier absent puis déjà identique | Restauration exacte ; le fichier identique n’est pas réécrit. |
| Fichier local divergent | Refus sans force ; remplacement seulement avec force explicite dans le dossier de test. |
| SHA incorrect pendant extraction | Ancien fichier conservé et temporaire supprimé. |
| Deux fichiers, second SHA incorrect | Premier fichier déjà remplacé ; deuxième conservé. Aucun rollback global. |
| Nouvelle tentative explicite | Le paquet de test est terminé après correction du SHA ; cela ne prouve pas une reprise de téléchargement interrompu. |
| Chemins traversants/absolus/Windows | Quatre refus par destination. |
| Membre supplémentaire, doublon, lien symbolique, taille erronée | Quatre refus. |
| Document de travail divergent | Conservé par défaut ; force peut rétablir la graine historique dans le test. |
| Politique de préservation incorrecte | Refus hors des trois chemins autorisés et refus d’une valeur non booléenne. |
| verify-only et membres du ZIP incohérents | verify-only réussit alors que le fichier installé manque ; la restauration normale refuse la liste de membres. |
| Pack local-only absent, cache absent, schéma inconnu | Refus explicites, sans réseau. |

Les24observations concordent avec les attentes, dont17erreurs attendues. La réussite des tests vérifie aussi les limitations ; elle ne signifie pas que les objectifs de livraison sont tous réalisés. Aucun asset de production n’a été remplacé, aucun téléchargement, build release, installeur ou jeu n’a été exécuté.

## Artefacts actuels et limites

Le manifeste actuel contient22packs, dont13local-only, et7 511fichiers. Il ne contient aucun membre .exe. Ces chiffres sont lus dans le manifeste courant ; la disponibilité et les empreintes de tous les packs réels ne sont pas retestées ici. La vérification d’un ZIP en cache ne valide ni ses membres ni les fichiers installés.

Le launcher inspecté sélectionne encore target/debug/openleague-server.exe et target/debug/openleague-client.exe. Sa racine utilise CARGO_MANIFEST_DIR et bundle.active vaut false. Ces constats statiques ne prouvent pas l’absence de tout autre outil dans le dépôt, mais ces consommateurs précis ne constituent pas la livraison autonome demandée.

Les exigences de sauvegarde, migration, désinstallation, installation sur machine propre et clôture restent ouvertes. La base locale explicite ne dispense d’aucun critère de fidélité native concernant le jeu. Les34tâches et la tâche de registre restent non terminées ; aucun statut manuel ou métier n’est promu.

## Couverture par tâche

| Tâche | Objectif | Contrôle du consommateur dans V785 |
| --- | --- | --- |
| SYS-24.1-01 | Produire le build release du serveur | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.1-02 | Produire le build release du client Bevy | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.1-03 | Produire le build release du launcher Tauri | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.1-04 | Créer le manifeste des versions et empreintes du paquet | 1 cas du downloader, portée partielle |
| SYS-24.1-05 | Embarquer tous les packs requis sans dépendance aux 13 packs locaux actuels | 1 cas du downloader, portée partielle |
| SYS-24.1-06 | Créer l’installeur Windows avec les prérequis déclarés | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.1-07 | Créer le paquet autonome et ses chemins relatifs | 4 cas du downloader, portée partielle |
| SYS-24.2-01 | Appliquer une mise à jour dans un répertoire de préparation | 1 cas du downloader, portée partielle |
| SYS-24.2-02 | Vérifier les empreintes avant bascule atomique | 2 cas du downloader, portée partielle |
| SYS-24.2-03 | Revenir à la version précédente après échec de bascule | 1 cas du downloader, portée partielle |
| SYS-24.2-04 | Réparer un fichier manquant ou corrompu depuis les packs | 14 cas du downloader, portée partielle |
| SYS-24.2-05 | Sauvegarder les données utilisateur avant une migration | Sources et contrat inspectés ; aucun test de la fonctionnalité complète ; lien hors périmètre explicite |
| SYS-24.2-06 | Restaurer les données utilisateur après échec de migration | Sources et contrat inspectés ; aucun test de la fonctionnalité complète ; lien hors périmètre explicite |
| SYS-24.2-07 | Désinstaller les exécutables sans supprimer les sauvegardes sans choix explicite | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.3-01 | Installer et lancer sur un compte Windows propre | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.3-02 | Installer sans Blender, Python, Rust ni outils du poste de développement | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.3-03 | Lancer hors ligne après récupération des packs requis | 2 cas du downloader, portée partielle |
| SYS-24.3-04 | Réparer une installation dont une texture obligatoire manque | 3 cas du downloader, portée partielle |
| SYS-24.3-05 | Réparer une installation dont un exécutable est corrompu | 1 cas du downloader, portée partielle |
| SYS-24.3-06 | Reprendre une mise à jour interrompue par fermeture du processus | 2 cas du downloader, portée partielle |
| SYS-24.3-07 | Relancer après redémarrage avec les paramètres utilisateur conservés | Sources et contrat inspectés ; aucun test de la fonctionnalité complète ; lien hors périmètre explicite |
| SYS-24.4-01 | Rédiger le guide d’installation du paquet final | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.4-02 | Rédiger les commandes et contrôles de jeu réellement disponibles | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.4-03 | Rédiger le dépannage des erreurs de chargement et de session | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.4-04 | Fournir le registre des sources natives et reconstructions | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.4-05 | Fournir l’index des scénarios et preuves d’acceptation | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.4-06 | Vérifier notices et périmètre de diffusion avant une distribution autorisée | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.5-01 | Vérifier la couverture de chaque contenu historiquement requis dans le registre final | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.5-02 | Vérifier qu’aucune inconnue obligatoire n’est masquée par une exclusion | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.5-03 | Vérifier qu’aucune anomalie bloquante ne reste ouverte | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.5-04 | Rejouer la recette complète depuis le paquet de livraison exact | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.5-05 | Vérifier les SHA de tous les livrables remis | 2 cas du downloader, portée partielle |
| SYS-24.5-06 | Archiver l’acceptation technique et l’acceptation humaine séparément | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |
| SYS-24.5-07 | Clôturer le projet uniquement lorsque toutes les conditions de fin sont satisfaites | Sources et contrat inspectés ; aucun test de la fonctionnalité complète |

## Preuves et modifications

- docs/fidelity_delivery_contracts_v785.json : contrats, associations, cas précis et limites.
- revision785_delivery_runtime/OBSERVATIONS.json :24cas, attentes/observations, source et interpréteur identifiés.
- revision785_associations/OBSERVATIONS.json :34contrats et vérification des sources.
- revision785_delivery/ : publication, deltas réversibles et relecture des deux bases.

Les répertoires revision785_* sont sous F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20. Les fichiers modifiés sont les trois registres, les preuves, les documents de couverture/reprise et35fiches dans chacune des deux bases du plan. Le code du jeu, le downloader et les assets restent inchangés. Les cases, notes, historiques, inconnues et prérequis sont conservés.

REA a été utilisé en V784 ; aucune nouvelle analyse native n’est nécessaire pour constater ces contrats locaux. Ne pas présenter l’analyse antérieure comme une exécution nouvelle.

## Suite

Continuer SYS-01.2-02 sur F avec REA lorsque l’analyse native est nécessaire. V785 explicite34contrats locaux de livraison et exclut trois liens inadaptés sans les supprimer ; les24cas de ZIP de test ne valident pas le paquet final. Prochaine association : SYS-10.1-02 et SYS-10.1-03, identité du GLB restauré, manifeste actuel et consommateur client effectif, avec refus de l’ancien export. Les autres34exigences sans native_inputs ni base locale explicite restent à qualifier individuellement (24références communautaires, identifiant stable, deux cartes, deux combats, cinq Battle Training). Conserver aussi les écarts natifs audio V783 et ceux du recensement V784. Préserver sources, preuves, cases, notes, historiques et inconnues.
