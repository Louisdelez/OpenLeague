# SYS-01.2-02 — Équipe, voie et position des 18 bâtiments, V476

Les 36 fiches STRUCTURE-00..17-POSITION-EQUIPE et STRUCTURE-00..17-POSITION-POSITION sont enrichies dans les quatre registres et les deux bases du plan. Chaque instance possède ses sources, ses consommateurs précis, une observation du cœur actuel et une question ouverte propre. Ce lot qualifie des liens et observations ; il ne déclare aucune de ces fiches ni le jeu terminé.

## Référence et périmètre

League of Legends 4.20.0.315, PUBLIC Releases/4.20, EUW/en_GB ; build du 2014-11-17 à 17:46:45, fuseau et date de déploiement non établis. Le catalogue officiel 4.20.1 reste distinct. Travail sur F:/OpenLeague, sources originales sous D:/LeagueOfLegendsV2/4.20.

Les dix-huit fichiers SCO, les dix-huit sections correspondantes d'ObjectCFG, les constantes du LevelScript natif et la configuration map10_world sont relus. Les champs natifs sont distingués des conventions du serveur communautaire et des conversions du moteur local.

## Observation exécutée du moteur actuel

Le cœur courant a été recompilé avec `cargo build --locked --offline -p openleague-core --lib`, dans un répertoire cible isolé. Un programme Rust d'observation lié à cette bibliothèque a ensuite été compilé et exécuté. Les trois commandes ont rendu le code 0. Les entrées collectées ont conservé leurs octets avant/après ; les exécutables, bibliothèques, outils, journaux et sources sont identifiés dans le reçu d'exécution. Ce périmètre d'entrées ne prétend pas constituer une construction entièrement hermétique.

Cas nominal : chargement de la vraie grille de navigation, initialisation des 18 bâtiments, comparaison bit à bit des coordonnées X/Z f32 et des valeurs équipe/voie avec la configuration, vérification de la hauteur retenue, snapshot interne puis un tick. Positions et équipes restent identiques après ce tick. La sérialisation de Unit omet lane, conformément à serde(skip).

Cas de repli : une grille synthétique située hors des 18 positions provoque l'absence de sol ; les 18 hauteurs configurées sont alors conservées exactement en f32. Quatre refus sont vérifiés : grille tronquée, position non finie, position hors grille et seconde activation de Map10.

Le programme observe le cœur CPU actuel. Il ne lance ni le client Riot, ni une partie ordinaire, ni le réseau, ni le GPU, ni l'audio. Aucun ancien binaire de test n'est présenté comme cette nouvelle exécution. Les trois tests unitaires V474 restent des preuves antérieures, non relancées ici.

## Hauteur : source conservée et comportement effectif distincts

Les X/Z correspondent aux CentralPoint natifs (tolérance du contrôle CPU : 0,002 unité ; comparaison de la configuration aux décimales SCO : 0,001). En revanche, spawn_unit utilise navigation.ground(position).unwrap_or(height). Pour les 18 bâtiments, le sol est disponible et remplace la hauteur SCO/configurée.

| Instance | Équipe locale | Voie locale | Y SCO | Y effectif | Écart effectif − SCO |
| --- | ---: | ---: | ---: | ---: | ---: |
| Barracks_T1_L1 | 0 | 0 | -4.8986 | 17.870987 | +22.769587 |
| Barracks_T1_R1 | 0 | 1 | -4.8986 | 12.283200 | +17.181800 |
| Barracks_T2_L1 | 1 | 0 | 1.4289 | 18.961391 | +17.532491 |
| Barracks_T2_R1 | 1 | 1 | 1.4289 | 12.283200 | +10.854300 |
| HQ_T1 | 0 | aucune | 56.5487 | 14.109426 | -42.439274 |
| HQ_T2 | 1 | aucune | 11.3934 | 13.884383 | +2.490983 |
| Turret_ChaosTurretShrine | 1 | aucune | 235.1346 | 150.604584 | -84.530016 |
| Turret_OrderTurretShrine | 0 | aucune | 234.4919 | 149.915390 | -84.576510 |
| Turret_T1_C_01 | 0 | aucune | 31.7994 | 17.798599 | -14.000801 |
| Turret_T1_C_06 | 0 | 0 | 26.1457 | 16.740099 | -9.405601 |
| Turret_T1_C_07 | 0 | 1 | 26.1457 | 12.283200 | -13.862500 |
| Turret_T1_L_02 | 0 | 0 | -93.9442 | -101.893913 | -7.949713 |
| Turret_T1_R_02 | 0 | 1 | -93.9442 | -102.962357 | -9.018157 |
| Turret_T2_C_01 | 1 | aucune | 36.7068 | 18.840900 | -17.865900 |
| Turret_T2_L_01 | 1 | 0 | 36.7068 | 16.729784 | -19.977016 |
| Turret_T2_L_02 | 1 | 0 | -93.9442 | -101.893929 | -7.949729 |
| Turret_T2_R_01 | 1 | 1 | 26.2324 | 12.283200 | -13.949200 |
| Turret_T2_R_02 | 1 | 1 | -93.9442 | -102.989197 | -9.044997 |

Ces écarts sont observés, mais ne sont pas déclarés erreurs natives établies. ObjectCFG contient aussi Move/Rot, parfois non nuls ; l'ordre et l'effet de leur combinaison avec le SCO, la grille et le rendu restent à qualifier. Par exemple les fontaines possèdent des décalages Move et des rotations ; les appliquer arbitrairement risquerait un double décalage. Il reste à comparer la position visuelle effective sur la carte restaurée. Le lecteur client divise les coordonnées et la hauteur par 20 ; ce chemin est inspecté, sans observation GPU.

## Équipes et voies : trois niveaux à distinguer

Le Lua natif expose TEAM_ORDER=100, TEAM_CHAOS=200, RIGHT_LANE=0, CENTER_LANE=1 et LEFT_LANE=2. Les unités locales utilisent équipes 0/1 et voies 0 pour gauche, 1 pour droite, ou aucune. Ces nombres ne sont donc pas directement interchangeables.

Les noms T1/Order et T2/Chaos ainsi que les exceptions Turret_T1_C_06→gauche et C_07→droite concordent avec MapObject.cs et LevelScriptObjects.cs du serveur communautaire fourni. Cela documente une convention communautaire, sans prouver l'affectation exécutée par le moteur Riot. Les sections ObjectCFG examinées n'ont pas de champ team/lane.

L'argument s.team et l'argument s.lane du code courant sont reliés aux 18 fiches correspondantes. Le lecteur de voie qui détermine les vagues selon l'état des inhibiteurs n'est relié qu'aux quatre inhibiteurs ; il n'est pas présenté comme comportement des Nexus, tours ou fontaines. La voie absente des snapshots sérialisés est une limite explicite.

## Vérifications de la livraison

- 18 instances nominales, 18 cas de repli et quatre refus du programme Rust ; compilation et exécution réussies.
- Quatre refus du collecteur SCO : CentralPoint absent, dupliqué, non fini ou de dimension incorrecte.
- 37 sélecteurs nominaux et 38 invalides ; trois refus publics : mauvais propriétaire de question, résolution indue et condition de résolution vide.
- 42 214 textes de tâches comparés : 36 changés, 42 178 identiques. Les inconnues anciennes et toutes les fiches hors lot sont préservées, hors ajout de preuves au parent SYS.
- Publication puis audit séparé des quatre registres et des deux bases : 37 fiches par base ; 42 606 états/notes, 23 historiques et 42 569 autres lignes du catalogue conservés exactement. Intégrité SQLite correcte.
- Identités des 51 fichiers directement épinglés et des entrées de l'exécution contrôlées. Le validateur de structure du graphe n'est pas confondu avec cette vérification d'identité.

Aucun code de production ni asset n'est modifié ; aucune case n'est cochée. Les modifications portent sur les registres, les textes enrichis du plan, les preuves et les documents de reprise.

## Manques et suite

Les 36 questions restent ouvertes : affectations natives équipe/voie et conversions locales, hauteur native effective, ordre des Move/Rot, transform et alignement rendu. L'initialisation et un tick ne valident ni le cycle complet ni la protection des bâtiments.

Poursuivre les 72 autres fiches STRUCTURE : orientation, protection, position globale et cycle des 18 instances. Le sous-inventaire des liens au chargeur générique compte 358 associations à examiner, 158 partiellement qualifiées et 24 exclusions conservées. Ces nombres ne représentent pas le taux d'achèvement du jeu. Le Goal reste actif.

## Fichiers et preuves

- Reçu : docs/reference_structures_sources/instance-team-position-v476.json.
- Preuve publiée : docs/fidelity_structure_instance_team_position_v476.json.
- Registres : docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json, fidelity_unknowns_4_20.json.
- Bases : runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3.
- Couverture/reprise : docs/coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md et ai/HANDOFF.md.
- Scripts et sauvegardes : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision476_*.py, revision476_probe.rs, revision476/ et revision476_runtime_checks/.

Les preuves antérieures et les sauvegardes préalables sont conservées. Les fichiers du binaire, de la bibliothèque, du programme et des logs sont identifiés dans CURRENT_STRUCTURE_INITIALIZATION.json. Aucun refus ou résultat synthétique ne vaut acceptation humaine ou fidélité complète.

Ajouts : 72 liens natifs, 100 liens consommateurs, six ancres, trois sources et 36 questions ouvertes ; aucune inconnue résolue.
