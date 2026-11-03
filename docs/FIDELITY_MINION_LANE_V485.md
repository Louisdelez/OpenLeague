# SYS-01.2-02 — Voies et navigation des sbires, V485

Huit fiches WORLD-{Blue,Red}_Minion_{Basic,Wizard,MechCannon,MechMelee}-AI-VOIE sont reliées aux ressources natives, aux points précis du code Rust et aux résultats de80 scénarios actuels. Chacune conserve une question ouverte. Aucun gameplay, asset, critère, prérequis ou état manuel modifié.

Référence : LoL4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build2014-11-17 à17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct. Projet F:/OpenLeague.

## Sources relues

43 fichiers SCO :25 repères de voie haute et18 de voie basse. Chaque CentralPoint est unique et contient trois coordonnées finies. Les X/Z correspondent aux points de map10_world.json à moins de0,001 unité ; les deltas de sérialisation sont conservés. L'équipe locale0 suit l'ordre enregistré, l'équipe1 le renverse. La positionY du marqueur ne devient pas une hauteur de sol : le mouvement courant utilise la grille.

AIPath.aimesh_ngrid : version3.1.0, grille306×129, cellule50. Les39 474 cellules sont comparées octet par octet pour la hauteur et les flags à tt_navigation_grid.cells.bin. Toutes concordent ; métadonnées et bornes comparées en float32. Les champs compacts region et open ne sont pas qualifiés comme consommés. Cette comparaison ne démontre ni le solveur historique, ni le rayon physique, ni une érosion de grille.

Huit INIBIN de personnages redécodés : MoveSpeed325 concorde partout. PathfindingCollisionRadius, GameplayCollisionRadius et SelectionRadius restent trois données distinctes, conservées avec leur présence et leur valeur. Le chemin actuel est un parcours en largeur sur quatre voisins, pour un point : aucun rayon propre au sbire n'est passé à Navigation.path.

Deux scripts Lua reparsés ; constantes, instructions et hashes des22 fonctions comparés aux preuves antérieures. Liens spécifiques : FindTargetOrMove/TimerMoveForward dans DATA/Scripts/Minion.luaobj et OnTargetLost/OnCanMove/OnCollisionEnemy/OnCollisionOther dans DATA/Shared/Scripts/Minions.luaobj. Les appels tels que SetStateAndMoveToForwardNav n'exposent pas leur implémentation native. Aucun callback historique ni serveur Riot exécuté.

Les appartenances RADS restent les résultats hérités des reçus waves-links et navigation-links, avec identité des fichiers revalidée ; les manifestes ne sont pas réaudités dans ce lot. L'ordre effectif de chargement et la sélection historique des repères restent ouverts. Les copiesF de ces deux reçus sont enregistrées comme identités distinctes des anciennes sources, sans les remplacer.

## Scénarios exécutés et portée

Nouveau programme Rust compilé/exécuté avec la bibliothèque coreV476 et ses entrées/outils/dépendances revalidés. Pas de nouveau cargo build. Commandes, codes de sortie0, binaire, journaux, observations et empreintes : revision485_runtime_checks/CURRENT_MINION_LANE.json.

80 cas : huit définitions × deux voies × cinq scénarios. La naissance provient du vrai planificateur local, avec sauts de ticks pour atteindre la vague/le créneau recherché. Pour les supers, la santé des inhibiteurs ennemis est fixée à0 ; cela ne teste pas leur destruction en jeu. La première observation inclut déjà le mouvement du tick de naissance.

Après naissance, les autres unités sont retirées et360 unités inertes hors carte (180 par équipe) empêchent les vagues suivantes par le plafond local. Elles n'ont ni AI active, ni cible, ni route, ni attaque. Les attaques de l'acteur sont aussi inhibées. Navigation, déplacement et réacquisition de cible du moteur courant restent actifs. Ces conditions isolent un parcours ; elles ne représentent pas une partie ordinaire.

| Cas, répété pour16 couples définition/voie | Attendu et observé |
| --- | --- |
| Route complète | Les16 files de route se vident avant6000ticks ; points suivis dans l'ordre selon l'équipe, aucune cible acquise. Pas maximal≤325/30+0,01. |
| Étourdissement6ticks | Position et route inchangées pendant les5 premiers ticks ; mouvement reprend au sixième. API grant_stun utilisée. |
| Interruption par combat | Ennemi contrôlé à la même position : cible acquise, route conservée, arrêt observé3ticks. Après sa mort via apply_damage, reprise à la prochaine recherche AI, sans perte de la route. |
| Repère à29unités | Retiré de la route, sans mouvement, cible absente. |
| Repère à30unités exactes | Conservé : la comparaison locale est strictement inférieure à30. |

Pour chaque type, durée mesurée depuis la naissance observée : équipe bleue1795ticks voie0 et1590 voie1 ; équipe rouge1797 et1572. Distance au dernier repère quand la file est vidée : environ26,223 /25,006 /29,903 /21,568 unités respectivement. Ce sont des observations isolées, pas des temps natifs attendus.

**File de route vide ne signifie pas arrivée exacte au centre ou arrêt total.** Les états finaux conservent les points du chemin encore présents et la destination. La tolérance locale peut retirer un repère avant la fin du chemin vers celui-ci. Le scénario de combat ne teste ni poursuite longue ni combat complet. Les limites29/30 sont contrôlées sur l'axeX à valeur float32 exacte.

## Consommateurs et vérifications du plan

Neuf ancres : initialisation/orientation de route, choix du point de naissance, sélection du prochain objectif, dispatch du chemin dynamique, délégation sans obstacle, BFS, budget de déplacement, seuil de consommation des repères, hauteur de sol. Les chemins sans cercle Trundle sont exercés ; les obstacles dynamiques et ralentissements ne sont pas validés par ce lot.

Dix refus de format : six copies Lua invalides et quatre CentralPoint manquant, dupliqué, incomplet ou non fini. Neuf sélecteurs nominaux et dix invalides. Trois refus du lecteur public : inconnue attribuée à un autre propriétaire, fausse résolution, condition de résolution vide.

42 214 instructions comparées :8 modifiées,42 206 inchangées. Critères, prérequis, anciens liens et inconnues conservés. Publication et audit indépendant sur les quatre registres et les deux bases ; neuf fiches/base avec SYS-01.2-02.42 606 états/notes,23 lignes d'historique et42 597 autres entrées du catalogue conservés exactement. Lectures et copies réelles du Store vérifiées. Aucune case cochée.

## Anomalies et limites ouvertes

La première préparation a refusé un reçuF absent du registre (KeyError waves-links). Aucun répertoire de préparation ni registre/base modifié à cette étape. Le collecteur fautif est conservé dans revision485_prepare_failure01.py ; ajout explicite des identitésF des reçus hérités, puis préparation réussie. La fonction TimerMoveForward a aussi été attribuée au bon script avant cette seconde exécution. Une commande de génération du vérificateur a échoué sur les guillemets PowerShell et sa copie a trouvé le fichier absent ; corrigé en utilisant un fichier Python, sans changement de données.

Le wrapper runtime conserve un suffixe de schéma v481 erroné, hérité du modèle. Le reçu n'est pas réécrit : cheminsV485, scripts, hashes, commandes et observations identifient cette exécution. Le reçu d'association V485 signale cette anomalie. Aucun échec du programme de parcours lui-même.

Restent à qualifier : helpers et ordonnanceur natifs, ordre effectif des marqueurs, calcul historique des chemins, rayons et évitement physique entre unités, formation, obstacles temporaires, ralentissements, déplacement en combat long, arrivée/arrêt final, rendu et alignement terrain. Les données de navigation sont disponibles ; le manque concerne surtout les algorithmes et les observations historiques comparables.

## Fichiers et reprise

Nouveaux : docs/reference_minion_behavior_sources/minion-lane-v485.json, docs/fidelity_minion_lane_v485.json et ce rapport. Scripts, reçus bruts, sauvegardes et contrôles : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision485*.

Modifiés : fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json, fidelity_unknowns_4_20.json ; bases F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 ; coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md et ai/HANDOFF.md. Aucun code de jeu ni asset modifié.

Sous-inventaire du chargeur :191 associations encore génériques (WORLD163, MODE27, SYS1),325 partielles,24 exclusions dont12 audio. Ce comptage ne mesure pas l'achèvement global du jeu. Suite : améliorations temporelles des sbires et fiches SOURCE, en préservant les inconnues et les cases. Goal actif.

Ajouts : 376 liens natifs, 81 liens consommateurs, 9 nouveaux consommateurs, 4 sources et 8 questions ouvertes. 1280 fichiers directement épinglés. Graphe : 98646 sources, 2503 consommateurs, 25660 ouvertes, 5517 résolues avec historique.
