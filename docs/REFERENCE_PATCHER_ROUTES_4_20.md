# SYS-01.1-04 — Écrans et parcours du patcher historique

Référence : **LoL 4.20.0.315 PUBLIC / Releases/4.20**, EUW / en_GB. Patcher natif **0.4.0.122**, release RADS **0.0.0.11**. Relevé du 20 octobre 2026.

## Résultat et niveau de preuve

Le catalogue recense **25 écrans/états**, **15 parcours**, **8 contrôleurs**, **7 modales HTML** et **13 commandes UI vers l’hôte**. Les variantes détaillées ci-dessous font partie du recensement ; ces nombres ne sont pas des quotas de conception.

Les sept bundles récupérés donnent **457 membres**. Les neuf fichiers récupérés totalisent **7 340 206 octets**. **Chaque fichier récupéré est comparé à son chemin exact, sa taille et son MD5 dans le manifeste natif RLSM**, et son SHA-256 est conservé. Ce lien direct est plus précis qu’une attribution d’après une capture, le nom d’un dossier ou le numéro d’un client récent.

La copie D: contient le binaire, le manifeste, les textes et les journaux ; son `deploy/data/config.prop` est vide et les bundles Content sont absents de cette copie. Les fichiers UI originaux ont été retrouvés dans l’index local du Riot Archive Project, sous **live/projects/lol_patcher/releases/0.0.0.11/files/**, puis récupérés par plages HTTPS bornées. Aucun fichier original D: n’a été modifié ; aucun patcher n’a été lancé.

Les sources originales sont conservées dans [reference_patcher_sources](reference_patcher_sources/). Les contrôleurs et templates utiles sont lisibles dans `reference_patcher_sources/review/`. Le lecteur vérifie les formats RLSM et r3d2load v2, les limites, les chemins et les pointeurs. Les 16 octets présents après les données des membres LOAD sont conservés comme métadonnée opaque : ils ne sont pas inventés comme un MD5 de membre. La vérification cryptographique porte sur les fichiers complets liés au manifeste natif et leurs SHA-256, puis les membres sont hachés séparément.

## Les écrans et états

| ID | Écran ou état | Type de source | Variantes et actions |
|---|---|---|---|
| P01 | Fenêtre principale et contrôles de fenêtre | shell | 1280x800 or 992x620 selected in ChromeController, home, minimize, close |
| P02 | Présentation du patcher rénové au premier lancement | popup | close then InitialLaunchEvent, learn more external link |
| P03 | Retrait facultatif de Pando Media Booster | popup | offer, retry after removal failure, yes, not now, never ask again |
| P04 | Mise à jour et progression | main_state | initializing, manifest loading, scanning, downloading, applying patches, unused-file cleanup, executing update files, interface then game files, repair progress |
| P05 | À jour, lancement disponible et disponibilité du service | main_state | ready, blocked, busy/limited, launch requested; repeat disabled in UI |
| P06 | Options et diagnostic | modal | P2P setting, SFX volume and mute, repair, save logs, about, disabled during patching |
| P07 | Sélection de région et langue | modal | filter languages per region, save, cancel |
| P08 | Accord EULA | modal | accept=1, reject=0, close=reject |
| P09 | Accord de type NDA / disclaimer | modal | accept=1, reject=0, shown after EULA in Nov20 log |
| P10 | Erreur et envoi de journaux | modal | continue closes modal, send logs dispatches SendLogs, update failure, repair failure, load/hardware/license/language/launch errors |
| P11 | À propos / mentions de copyright | modal | display supplied text, close |
| P12 | Enregistrer les journaux et résultat | native_dialog_and_status | save-as dialog, cancel, saving, saved, permission failure, disabled while patching |
| P13 | Confirmation de réparation complète | native_dialog | yes, no |
| P14 | Corruption détectée / proposition de réparation douce | native_dialog | repair affected files, quit |
| P15 | Confirmation de fermeture avec PvP.net actif | native_dialog | yes close, no return |
| P16 | Incidents, statut et bandeau de service | main_state | expanded ticker, external status link, online transition restarts update |
| P17 | Accueil éditorial | routed_view | large article, two small articles, rotation preview, patch article, home return |
| P18 | Article d’actualité 1 | routed_view | article source template, historical remote content not reconstructed |
| P19 | Article d’actualité 2 | routed_view | article source template, historical remote content not reconstructed |
| P20 | Article d’actualité 3 | routed_view | article source template, historical remote content not reconstructed |
| P21 | Article de notes de patch de l’accueil | routed_view | articles/patch-notes route |
| P22 | Vue dédiée des notes de patch | routed_view | patch-notes/default route |
| P23 | Rotation et fiches des champions gratuits | routed_view | champion slider, champion accordion, role and stats labels |
| P24 | Erreur de chargement JavaScript | fallback_page | fallback document retained; native invocation not observed |
| P25 | Avertissements d’installation et de désinstallation | resource_defined_native_warning | risk detected, fix failure or permission denied, fix success; no repair tool executed here |

Les écrans P13–P15 et P25 sont définis par le binaire natif et les traductions, avec commandes génériques côté hôte ; leur rendu et leurs branches ne sont pas présentés comme une observation nouvelle. P24 est une page de secours conservée ; son invocation native n’a pas été observée. EULA et NDA partagent la modale d’accord et gardent des entrées séparées, car le journal natif les montre successivement.

## Les parcours

| ID | Parcours | Écrans / états | Commandes hôte |
|---|---|---|---|
| J01 | Ouvrir, initialiser, première présentation et Pando puis contrôler les mises à jour | P01 → P02 → P03 → P04 | PandoRemove, StartUpdate |
| J02 | Mise à jour nominale puis état prêt | P04 → P05 | StartUpdate |
| J03 | État du service, blocage et retour en ligne | P16 → P05 → P04 | CheckServerStatus, StartUpdate |
| J04 | Jouer puis EULA/NDA si requis, acceptation ou refus | P05 → P08 → P09 | Launch, SendAgreementResponse |
| J05 | Options, P2P, volume, silence, fermer | P01 → P06 | SetP2PEnabled, SfxVolume, SfxMute |
| J06 | Options puis confirmer/annuler la réparation et suivre son état | P06 → P13 → P04 → P10 | StartValidate, SendGenericTwoButtonResponse |
| J07 | Proposition de réparation douce ou quitter | P14 → P04 | SendGenericTwoButtonResponse |
| J08 | Enregistrer des journaux, annuler, succès ou erreur de fichier | P06 → P12 | SaveLogs |
| J09 | Échec de mise à jour/réparation/lancement, continuer ou envoyer les journaux | P04 → P05 → P10 | SendLogs |
| J10 | Changer de région/langue, enregistrer ou annuler | P01 → P07 → P04 | SetRegionAndLocale |
| J11 | Lire les mentions de copyright et fermer | P06 → P11 | ShowCopyright |
| J12 | Fermer la fenêtre, confirmer ou revenir si PvP.net actif | P01 → P15 | SendGenericTwoButtonResponse |
| J13 | Accueil vers les trois articles et notes puis retour | P17 → P18 → P19 → P20 → P21 → P22 |  |
| J14 | Accueil vers rotation et informations d’un champion puis retour | P17 → P23 |  |
| J15 | Erreur de chargement et avertissements anciens conservés | P24 → P25 → P10 |  |

### Démarrage et mise à jour

`ChromeController.js` ouvre `landing`, initialise la fenêtre, reçoit `ClientInit`, affiche éventuellement la présentation initiale, traite Pando puis émet `StartUpdate`. Le code de taille choisit 1280×800 ou 992×620 selon la surface disponible. Les temps et seuils de cette UI restent des faits de source, sans mesure de performance native nouvelle.

La progression distingue scan, téléchargement et application, avec phase interface puis fichiers du jeu. Le bouton de lancement est soumis à l’expression réelle **(bDisabled || bServerStatus) && bUrf**. Les états serveur error, online, unavailable, busy, blocked et limited ne sont pas fusionnés : la table du contrôleur bloque error/unavailable/blocked, mappe busy/limited vers limited, et relance `StartUpdate` lors d’un retour vers online. Le comportement spécial `bUrf` est recensé comme une branche de source, sans manipulation d’un service ou d’un client officiel.

### Accords, réparation et refus

Les boutons d’accord envoient exactement `SendAgreementResponse('1')` ou `('0')` ; la croix de la modale suit le refus. Le journal du **20 novembre** contient `StartUpdate`, `SetTaskState:1`, `OnTaskComplete`, `SetTaskState:0`, puis `Launch 2000`, EULA, réponse1, NDA, réponse1. Ce sont des observations historiques de ce fichier, pas une recette exécutée aujourd’hui ni une date de déploiement EUW déduite.

Les options émettent `StartValidate`, `SaveLogs`, `ShowCopyright`, les réglages P2P, volume et silence. Les textes et le binaire définissent confirmation de réparation, réparation douce proposée, erreurs et fermeture avec PvP.net actif. Les contrôleurs et le DOM prévoient désactivation des journaux/réparation pendant le patch, dialogue d’enregistrement, annulation et résultats. Les refus testés hors ligne ne sont pas annoncés comme des retours d’un serveur ou d’un processus natif.

### Navigation éditoriale

`routes.csv` relie les rôles chrome, landing, f2p, articles/news1–3, articles/patch-notes et patch-notes/default à leurs pages exactes. Chaque vue routée de ce catalogue est présente dans les bundles récupérés. Les rôles assets/libs décrivent des dépendances, pas de nouveaux écrans. Les données JSON d’exemple, les articles et URL de service conservés ne sont pas une preuve du contenu effectivement diffusé à EUW à une date précise.

Les pages `bundle-client-sitemap` et le sélecteur `bundle-riotclient` sont classifiés **prototype/développement, non routés comme écrans de production du patcher**. Une page placeholder de connexion ou de sélection de champion n’est donc pas transformée en écran AIR historique ; ce périmètre appartient à SYS-01.1-05.

## Consommateur réel d’OpenLeague

Le launcher courant a été inspecté : `launcher/web/index.html`, `app.js`, `launcher/src-tauri/src/main.rs`. Il prépare une partie locale et utilise ses commandes locales de lancement. Cette interface ne constitue pas une reconstruction de ces 25 écrans historiques.

Le résultat de cette tâche de **recensement** est consommé par le contexte de SYS-01.1-04, le générateur existant de consignes et le catalogue SQLite partagé par le site et l’application Tauri. Le contrat structuré inclut les ancrages de source et leurs lignes, variantes, commandes, parcours et limites. Il prépare les travaux d’interface ultérieurs sans élargir cette tâche à leur implémentation.

## Contrôles, résultat attendu et résultat observé

| Contrôle | Attendu | Observé / preuve |
|---|---|---|
| Identité | Patcher 0.4.0.122 et release0.0.0.11 liés à la référence | VERSIONINFO et manifeste natif relus |
| Récupération | Ressources de la release exacte, non d’un client récent/Maclive | Neuf fichiers sous live/0.0.0.11, taille/MD5 natifs et SHA-256 concordants |
| Dépendances de vues | Templates de modales et vues de routes présents | Sept modales et toutes les pages des rôles UI recensés résolues |
| Parcours | Chaque commande UI reliée à un parcours nommé | 13 commandes couvertes, graphe sans cible inconnue |
| Cas nominal | Mise à jour puis lancement et accords | Journal Nov20 ordonné, 420 événements filtrés dans les deux journaux retenus |
| Refus | Accord rejeté, annulation sans enregistrement, lancement indisponible | Contrôleurs originaux et expression DOM testés en VM Node hors ligne, hôte simulé explicitement |
| Sources invalides | Refus d’une source/bundle modifié, mauvais chemin ou graphe incohérent | Tests Python et vérificateur, résultats dans le reçu de vérification |
| Suivi manuel | Aucun état utilisateur modifié | Comparaison intégrale avant/après dans le reçu final |

Commandes depuis E:/OpenLeague :

```powershell
python -B tools/project-plan/patcher_reference.py --root E:/OpenLeague
python -B tools/project-plan/test_patcher_reference.py
node --test tools/project-plan/test_patcher_controllers.cjs
python -B tools/project-plan/patcher_reference.py --root E:/OpenLeague --member bundle-chrome/src/js/app/ChromeController.js
```

[Contrat détaillé](reference_patcher_routes_4_20.json) · [Résultats, fichiers modifiés et limites](reference_patcher_routes_4_20_verification.json)

## Limites conservées

Aucune fenêtre du patcher historique, aucun service distant et aucun rendu n’ont été qualifiés aujourd’hui. Les tests des contrôleurs utilisent le JavaScript original dans un contexte VM avec un hôte simulé ; ils n’acceptent aucun accord réel, ne retirent aucun logiciel et n’envoient aucun journal. Les bundles assets/fonts et vendor nécessaires à un rendu complet n’ont pas été récupérés pour cet inventaire de sources. Les confirmations natives, les contenus distants et la fidélité visuelle gardent leurs limites indiquées. Les échecs et corrections des premiers lecteurs sont conservés dans le dossier de preuve ; ils ne sont pas présentés comme des contrôles finaux réussis.

La tâche reste **à valider par l’utilisateur**. Aucune case n’est cochée, aucune autre tâche ni le jeu ne sont déclarés terminés.
