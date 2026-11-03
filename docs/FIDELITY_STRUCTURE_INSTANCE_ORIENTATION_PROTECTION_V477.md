# SYS-01.2-02 — Orientation, volume de clic et protection des bâtiments, V477

Les 36 fiches STRUCTURE-00..17-POSITION-ORIENTATION et STRUCTURE-00..17-POSITION-PROTECTION sont enrichies dans les registres et les deux bases du plan. Elles disposent de sources par instance, de chemins de code précis et de limites explicites. Ce travail qualifie la traçabilité et les observations disponibles, pas la fidélité complète de ces fonctionnalités.

Référence : LoL 4.20.0.315, PUBLIC Releases/4.20, EUW/en_GB ; build du 2014-11-17 à 17:46:45, fuseau et déploiement non établis ; catalogue officiel4.20.1 distinct. Projet F:/OpenLeague.

## Orientation et clic : résultats par instance

Les 18 sections ObjectCFG et leurs fichiers SCO sont identifiés. Douze triplets Rot sont non nuls ; 360 reste une valeur brute non nulle, sans être présenté comme une rotation visuelle différente de zéro. Le cœur actuel passe facing=0 à l'initialisation des18 bâtiments et le sérialise. Le client crée le parent visuel par Quat::from_rotation_y(unit.facing), puis utilise les déplacements pour les mises à jour. Le chemin de déplacement nul conserve la rotation antérieure.

Cela ne qualifie pas les conventions d'axes/unités d'ObjectCFG, les rotations incorporées au maillage ou squelette, ni la composition finale des animations. Aucun retournement automatique n'est appliqué : une différence entre champ brut et argument du code ne prouve pas à elle seule l'orientation finale incorrecte.

Le clic ordinaire appelle picking::target avec le rayon de caméra. Pour les unités, le code filtre équipe adverse et santé positive, intersecte un plan horizontal à unit.height, compare strictement la distance au rayon, puis choisit la plus petite distance au point calculé. Il ne réalise pas ici une intersection avec un volume 3D orienté, et ce bloc ne filtre pas protected. La validation des dégâts est distincte.

| Instance | Rot natif brut | Facing initial observé | Rayon natif | Rayon courant | SelectionHeight native |
| --- | --- | ---: | ---: | ---: | ---: |
| Barracks_T1_L1 | 0.0000 0.0000 0.0000 | 0.0 | absent | 160.0 | absente |
| Barracks_T1_R1 | 0.0000 0.0000 0.0000 | 0.0 | absent | 160.0 | absente |
| Barracks_T2_L1 | 278.0000 0.0000 0.0000 | 0.0 | absent | 160.0 | absente |
| Barracks_T2_R1 | 0.0000 0.0000 0.0000 | 0.0 | absent | 160.0 | absente |
| HQ_T1 | 0.0000 0.0000 0.0000 | 0.0 | absent | 160.0 | absente |
| HQ_T2 | 0.0000 0.0000 0.0000 | 0.0 | absent | 160.0 | absente |
| Turret_ChaosTurretShrine | 90.0000 2.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200 |
| Turret_OrderTurretShrine | 90.0000 0.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200 |
| Turret_T1_C_01 | 324.0000 0.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200.0000 |
| Turret_T1_C_06 | 360.0000 0.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200.0000 |
| Turret_T1_C_07 | 294.0000 0.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200.0000 |
| Turret_T1_L_02 | 296.0000 0.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200.0000 |
| Turret_T1_R_02 | 344.0000 0.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200.0000 |
| Turret_T2_C_01 | 302.0000 0.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200.0000 |
| Turret_T2_L_01 | 292.0000 0.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200.0000 |
| Turret_T2_L_02 | 0.0000 0.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200.0000 |
| Turret_T2_R_01 | 338.0000 0.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200.0000 |
| Turret_T2_R_02 | 294.0000 0.0000 0.0000 | 0.0 | 130.0 | 130.0 | 200.0000 |

Les huit définitions de tours/fontaines ont SelectionRadius=130 et SelectionHeight=200. Les profils locaux conservent le rayon mais le lecteur de clic inspecté ne consomme pas SelectionHeight. Les champs de sélection examinés sont absents dans les quatre définitions des inhibiteurs/Nexus, soit six instances : le client utilise le fallback local160. L'absence dans ces INIBIN ne prouve ni l'absence d'une valeur native calculée ailleurs ni la justesse de160.

Les champs PathfindingCollisionRadius et GameplayCollisionRadius sont relevés séparément ; ils ne sont pas assimilés au volume de clic. Le programme CPU vérifie les18 rayons optionnels actuels et l'intersection d'un rayon central à la hauteur de l'unité. Il n'exécute pas le système de picking complet du client, le clic réel, les occultations ou le GPU.

## Protection : contrat local observé

Le prédicat actuel protège toujours les fontaines. Pour les autres bâtiments, il protège si une dépendance depends_all est vivante, ou si depends_any est non vide et que toutes ses dépendances sont vivantes. Une dépendance manquante est traitée comme non vivante. Un identifiant de bâtiment inconnu renvoie false dans protected, alors que apply_damage refuse ensuite une cible inconnue.

Toutes les combinaisons de santé des dépendances locales sont exercées pour les18 instances aux ticks0,299,300 et301, soit184 cas. Les ticks sont assignés directement, sans simulation d'une partie jusqu'à ces instants. Les cas protégés refusent1 dégât vrai sans changer la santé ; les cas ouverts retirent exactement1. La suppression synthétique de toutes les dépendances confirme le comportement des références manquantes. Ces observations couvrent le graphe local, pas sa correspondance au graphe Riot ni une destruction ordinaire.

| Instance | Dépendances devant toutes disparaître | Groupe dont une disparition suffit | Cas de prédicat/dégâts |
| --- | --- | --- | ---: |
| Barracks_T1_L1 | Turret_T1_C_06 | aucun | 8 |
| Barracks_T1_R1 | Turret_T1_C_07 | aucun | 8 |
| Barracks_T2_L1 | Turret_T2_L_01 | aucun | 8 |
| Barracks_T2_R1 | Turret_T2_R_01 | aucun | 8 |
| HQ_T1 | Turret_T1_C_01 | Barracks_T1_L1, Barracks_T1_R1 | 32 |
| HQ_T2 | Turret_T2_C_01 | Barracks_T2_L1, Barracks_T2_R1 | 32 |
| Turret_ChaosTurretShrine | aucune | aucun | 4 |
| Turret_OrderTurretShrine | aucune | aucun | 4 |
| Turret_T1_C_01 | aucune | Barracks_T1_L1, Barracks_T1_R1 | 16 |
| Turret_T1_C_06 | Turret_T1_L_02 | aucun | 8 |
| Turret_T1_C_07 | Turret_T1_R_02 | aucun | 8 |
| Turret_T1_L_02 | aucune | aucun | 4 |
| Turret_T1_R_02 | aucune | aucun | 4 |
| Turret_T2_C_01 | aucune | Barracks_T2_L1, Barracks_T2_R1 | 16 |
| Turret_T2_L_01 | Turret_T2_L_02 | aucun | 8 |
| Turret_T2_L_02 | aucune | aucun | 4 |
| Turret_T2_R_01 | Turret_T2_R_02 | aucun | 8 |
| Turret_T2_R_02 | aucune | aucun | 4 |

La règle spéciale des deux fontaines reste prioritaire, même sans dépendance. Le code local ne lit pas le temps dans protected. Le LevelScript natif contient OnLevelInitServer et son timer AllowDamageOnBuildings10s, ainsi que AllowDamageOnBuildings, DeactivateCorrectStructure, ApplyBarracksRespawnReductions et HandleDestroyedObject. Leurs constantes et identités de code sont revérifiées par rapport aux preuves conservées. Cela ne qualifie ni l'ancrage effectif du timer ni chaque arête par instance ; aucun callback du moteur Riot n'est exécuté ici.

## Exécution et provenance

Le programme d'audit Rust V477 est nouvellement compilé puis exécuté contre la bibliothèque core produite enV476. Avant utilisation, toutes les entrées enregistrées du build précédent, la bibliothèque et les outils sont réidentifiés contre l'état actuel ; les dépendances rlib sont épinglées et inchangées après exécution. Cette réutilisation est explicite : pas de nouvelle compilation Cargo du cœur ni de garantie de construction entièrement hermétique.

Le premier programme d'audit a échoué à la compilation sur une comparaison &&str/&str, avant toute exécution ou publication. Son source et son diagnostic sont conservés dans revision477_runtime_checks. La correction porte sur ce programme isolé ; sa compilation et son exécution réussissent dans revision477_runtime_checks_retry. Aucun fichier de production n'est corrigé à cette occasion.

Les huit refus des helpers couvrent cible inconnue, dégât non fini, cible morte, définition de sélection inconnue, rayon parallèle, intersection derrière la caméra, origine non finie et hauteur non finie. L'identifiant inconnu dans protected est aussi observé séparément comme false, sans être compté comme un refus.

## Contrôles de la livraison

- 184 cas de protection/dégâts,18 orientations initiales,18 profils et intersections centrales, huit refus de helpers : réussis.
- Quatre refus du lecteur de triplet Rot : vide, deux composantes, non fini, quatre composantes.
- 37 sélecteurs nominaux,38 invalides et trois refus publics du registre : propriétaire incorrect, résolution indue, condition de résolution vide.
- 42 214 textes comparés :36 changés,42 178 identiques ; les données des autres exigences et les anciennes inconnues sont conservées.
- Publication puis audit indépendant des quatre registres et deux bases :37 fiches/base ;42 606 états/notes,23 historiques et42 569 autres lignes du catalogue conservés exactement ; intégrité SQLite correcte.
- 74 fichiers directement épinglés, plus les entrées du programme d'exécution vérifiées. Le contrôle structurel du graphe ne remplace pas ces contrôles d'identité.

## Limites et travail restant

Les36 questions restent ouvertes. Pour l'orientation/clic : qualifier Rot/transform/pose finale, la sémantique native de SelectionHeight et des defaults absents, le volume réellement sélectionnable, l'occultation et les priorités, puis observer le client en partie. Pour la protection : relier chaque arête aux appels natifs, qualifier le timer, le ciblage et l'invulnérabilité dans une partie ordinaire.

Aucun code du jeu, asset, case, note ou historique manuel n'est modifié. Aucun jeu Riot, rendu GPU, audio ou scénario ordinaire n'est exécuté. Les limites antérieures sur les hauteurs, les sons et les animations sont conservées. Les scripts, journaux et binaires de ce lot sont identifiés ; un contrôle local réussi ne vaut pas acceptation humaine ni jeu complet.

La suite immédiate couvre les36 fiches STRUCTURE encore attachées seulement au chargeur générique :18 positions agrégées et18 cycles de vie. Le sous-inventaire compte322 associations à examiner,194 partiellement qualifiées et24 exclusions de portée conservées. Ce compteur ne mesure pas la complétion du jeu. Goal actif.

## Fichiers livrés

- Reçu : docs/reference_structures_sources/instance-orientation-protection-v477.json.
- Preuve : docs/fidelity_structure_instance_orientation_protection_v477.json.
- Registres : docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json, fidelity_unknowns_4_20.json.
- Bases : runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3.
- Couverture et reprise : docs/coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md, ai/HANDOFF.md.
- Scripts, sauvegardes et résultats : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision477*, dont CURRENT_ORIENTATION_PROTECTION.json dans revision477_runtime_checks_retry.

Ajouts vérifiés : 90 liens natifs, 152 liens consommateurs, sept ancres, deux sources,36 questions ouvertes et zéro résolution.
