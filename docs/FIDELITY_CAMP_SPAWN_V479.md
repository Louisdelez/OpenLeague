# SYS-01.2-02 — Composition et apparition des camps Map10, V479

Les21 fiches CAMP-00..06-SOURCE-COMPOSITION, INITIAL et RESPAWN possèdent désormais des liens précis vers leurs sources et les fonctions qui les consomment. Les registres et les deux bases du plan sont synchronisés. Aucune case de complétion ou note manuelle n'est modifiée. Ces fiches restent partielles : les observations locales ne prouvent pas leur fidélité complète au moteur natif.

Référence : League of Legends4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build2014-11-17 à17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct. Projet F:/OpenLeague. Ce lot poursuit l'association sources/consommateurs de SYS-01.2-02 ; aucun code de gameplay ni asset n'est modifié.

## Correspondance exacte du plan

Le numéro de la fiche n'est pas l'index natif du camp. CAMP-00..05 correspondent aux camps1..6 et CAMP-06 au camp8, Vilemaw. Le camp natif7 est la relique, traitée séparément par le système d'interactions ; elle n'est pas un huitième camp perdu dans cette configuration de monstres.

| Fiche | Camp | Membres | Délai initial littéral natif | Apparition locale | Respawn configuré |
| --- | ---: | --- | ---: | ---: | ---: |
| CAMP-00 | 1 | TT_NWraith, TT_NWraith2, TT_NWraith2 | 15 | 100s / tick3000 | 50s |
| CAMP-01 | 2 | TT_NGolem, TT_NGolem2 | 15 | 100s / tick3000 | 50s |
| CAMP-02 | 3 | TT_NWolf, TT_NWolf2, TT_NWolf2 | 15 | 100s / tick3000 | 50s |
| CAMP-03 | 4 | TT_NWraith, TT_NWraith2, TT_NWraith2 | 15 | 100s / tick3000 | 50s |
| CAMP-04 | 5 | TT_NGolem, TT_NGolem2 | 15 | 100s / tick3000 | 50s |
| CAMP-05 | 6 | TT_NWolf, TT_NWolf2, TT_NWolf2 | 15 | 100s / tick3000 | 50s |
| CAMP-06 | 8 | TT_Spiderboss | 515 | 600s / tick18000 | 300s |

## Sources et consommateurs

NeutralMinionSpawn.luaobj est rehashé et reparsé. Les sept tableaux d'instructions, les cinq fonctions principales et la fermeture de création sont comparés aux empreintes conservées. Les groupes, positions et points de regard récupérés statiquement sont confrontés aux observations historiques et aux données actuelles. Les écritures littérales des délais sont vérifiées dans NeutralMinionInit.

Les observations Lua5.1 de révision42 sont héritées, identifiées, pas réexécutées. Elles provenaient d'un hôte avec adaptateurs : elles ne qualifient ni l'implémentation des API du moteur Riot, ni le producteur réel des événements, ni l'origine de l'horloge. Le rapport camp-reference.json conserve également les travaux communautaires historiques ; aucune exécution C# nouvelle n'est revendiquée ici.

Six ancres de code sont ajoutées dans crates/core/src/world.rs : échéance initiale absolue, déclenchement au tick atteint, création des membres, condition de mort complète, planification de respawn et hauteur de grille. Le dispatch normal déjà identifié dans le cœur est réutilisé pour INITIAL. Chaque fiche reçoit seulement les consommateurs pertinents à son objectif.

## Programme exécuté et résultats

Un nouveau programme Rust est compilé puis exécuté contre la bibliothèque coreV476. Les entrées enregistrées, les outils, la bibliothèque et les dépendances sont réidentifiés avant usage et préservés après exécution. Aucun nouveau cargo build du cœur n'est revendiqué. Les commandes, binaires, journaux et empreintes sont dans CURRENT_CAMP_SPAWN.json.

Chaque camp utilise une simulation distincte sans joueurs, la vraie grille de navigation locale, des dégâts vrais par apply_damage et des sauts explicites de ticks. Le programme ne constitue pas une partie ordinaire et ne lance pas le client graphique ni le jeu Riot.

- Initialisation : absence au tick précédent puis présence de tous les membres à l'échéance, pour les7 camps.
- Composition :17 membres comparés à la configuration, définition, nom, équipe2, X/Z, orientation, santé maximale, camp et point d'origine relevés.
- Mort partielle : pour les6 camps de plusieurs membres, conserver un membre vivant empêche une nouvelle génération, même après dépassement du délai de respawn.
- Mort complète : le tick suivant constate la mort du dernier membre et programme le délai ; absence au tick juste avant, puis tous les membres vivants à l'échéance avec de nouveaux identifiants et leur santé maximale.
- Activation tardive : activer Map10 après la date initiale ne crée pas les membres immédiatement ; ils arrivent au prochain advance. Le délai initial est absolu dans le tick de simulation, pas relatif à l'activation.
- Dégâts répétés : les7 dernières cibles déjà mortes refusent un nouveau dégât avec damage target dead.

| Camp | Mort du dernier membre | Détection / départ du délai | Respawn observé |
| --- | ---: | ---: | ---: |
| 1 | 4601 | 4602 | 6102 |
| 2 | 4601 | 4602 | 6102 |
| 3 | 4601 | 4602 | 6102 |
| 4 | 4601 | 4602 | 6102 |
| 5 | 4601 | 4602 | 6102 |
| 6 | 4601 | 4602 | 6102 |
| 8 | 18000 | 18001 | 27001 |

## Écarts et inconnues conservés

**Horloge initiale.** Les six camps ordinaires utilisent100s contre un champ natif15 ; Vilemaw600s contre515. L'écart littéral est+85s dans les7 cas. Sans qualification du point de départ de l'horloge native et des appels effectifs du scheduler, cet écart ne justifie pas de remplacer100 par15 ou600 par515. Il reste explicitement ouvert dans chaque fiche INITIAL.

**Réapparition.** Les valeurs50s et300s correspondent aux champs natifs, mais la même valeur ne prouve pas la même origine temporelle. Le moteur actuel démarre au tick de détection, ici dernier décès+1. Dans les observations Lua historiques, une notification répétée du dernier décès redemande un timer. La réaction effective du scheduler Riot et la possibilité d'un tel doublon dans le producteur réel restent inconnues. Refuser un nouveau dégât local n'est pas tester le même appel que recevoir deux événements natifs de décès.

**Position et orientation.** Les coordonnées brutes de la configuration correspondent aux sources natives. Les17 hauteurs sont cependant remplacées par la grille de navigation à la création. L'orientation locale correspond à atan2 du vecteur vers le point de regard natif ; cela ne qualifie pas la convention de yaw native ni la pose finale rendue. Pour Vilemaw en particulier, aucune nouvelle validation visuelle de son orientation n'est effectuée dans ce lot.

| Camp / membre | Hauteur configurée observée en f32 | Hauteur effective | Nom local | Nom natif |
| --- | ---: | ---: | --- | --- |
| 1/1 | -109.939003 | -107.394722 | camp_1_0 | TT_NWraith1.1.1 |
| 1/2 | -109.584999 | -104.943542 | camp_1_1 | TT_NWraith21.1.2 |
| 1/3 | -110.148003 | -107.263336 | camp_1_2 | TT_NWraith21.1.3 |
| 2/1 | -109.583000 | -108.703644 | camp_2_0 | TT_NGolem2.1.1 |
| 2/2 | -109.677002 | -109.669098 | camp_2_1 | TT_NGolem22.1.2 |
| 3/1 | -109.897003 | -98.626900 | camp_3_0 | TT_NWolf3.1.1 |
| 3/2 | -109.898003 | -98.626900 | camp_3_1 | TT_NWolf23.1.2 |
| 3/3 | -109.897003 | -98.626900 | camp_3_2 | TT_NWolf23.1.3 |
| 4/1 | -109.903000 | -107.381737 | camp_4_0 | TT_NWraith4.1.1 |
| 4/2 | -110.138000 | -107.360283 | camp_4_1 | TT_NWraith24.1.2 |
| 4/3 | -109.662003 | -104.337837 | camp_4_2 | TT_NWraith24.1.3 |
| 5/1 | -109.709000 | -108.690590 | camp_5_0 | TT_NGolem5.1.1 |
| 5/2 | -109.799004 | -109.643845 | camp_5_1 | TT_NGolem25.1.2 |
| 6/1 | -109.897003 | -97.835182 | camp_6_0 | TT_NWolf6.1.1 |
| 6/2 | -109.897003 | -95.334908 | camp_6_1 | TT_NWolf26.1.2 |
| 6/3 | -109.897003 | -96.656868 | camp_6_2 | TT_NWolf26.1.3 |
| 8/1 | -108.602997 | -61.595699 | camp_8_0 | TT_Spiderboss8.1.1 |

**Identités et portée.** Les noms camp_index_j et l'équipe locale2 ne prouvent pas une conversion complète des UniqueNames, de l'équipe native300 et de GroupBuffSide. Les récompenses, l'aggro, le retour/reset, les buffs, animations, effets et sons ne sont pas acceptés par ces contrôles de spawn. Aucun rendu GPU, audio, réseau ou comportement ordinaire complet n'est testé.

**Branches non exercées.** La condition de mort considère un identifiant d'unité absent comme mort ; cette branche est inspectée, pas provoquée séparément. Une liste de membres vide ne déclenche pas la planification. Une création refusée par spawn_unit n'est pas ajoutée à la liste, alors que l'échéance est ensuite effacée ; ce comportement est lu dans le code, pas qualifié par un test de configuration invalide du runtime. Les refus de configuration ci-dessous appartiennent au collecteur de preuves, pas à l'API de jeu.

## Contrôles du registre et conservation

- 5 refus du collecteur : camp inconnu, index dupliqué, liste vide, délai non fini, définition manquante.
- 22 sélecteurs nominaux et23 sélecteurs invalides ;3 refus du lecteur public : mauvaise exigence propriétaire, résolution indue, condition de résolution vide.
- 42 214 textes comparés :21 changés,42 193 identiques ; toutes les autres exigences et questions préservées.
- Publication puis relecture indépendante des quatre registres et des deux bases SQLite ;22 fiches par base. Les42 606 états/notes,23 historiques et42 584 autres lignes du catalogue sont conservés exactement.
- 37 fichiers directement épinglés, plus les entrées/dépendances du programme Rust réidentifiées. Validation structurelle du graphe et contrôles d'empreintes restent distingués.

Les21 nouvelles questions restent ouvertes, aucune ancienne question n'est déclarée résolue. Aucune case de validation ou d'acceptation humaine n'est cochée.

## Fichiers et reprise

Modifiés : docs/fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json, fidelity_unknowns_4_20.json ; les deux bases locales du plan ; docs/coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md et ai/HANDOFF.md. Les preuves antérieures restent conservées.

Nouveaux livrables : docs/reference_camp_sources/camp-spawn-v479.json, docs/fidelity_camp_spawn_v479.json et ce rapport. Scripts, sauvegardes, programme et journaux : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision479*. L'exécution est identifiée dans revision479_runtime_checks/CURRENT_CAMP_SPAWN.json ; la comparaison indépendante est dans revision479/CANDIDATE_CHECK.json.

Le sous-inventaire des liens du chargeur contient désormais265 associations encore à examiner,251 partielles et24 exclusions conservées dont12 audio. Ce compteur ne mesure pas le pourcentage du jeu. Il reste42 fiches CAMP à préciser dans ce sous-inventaire : les agrégats SOURCE, AI, REWARD, ACCEPT et les enfants RESET/REWARD pour chacun des7 camps. Poursuivre les règles de récompense et de mort/reset, sans déduire leurs valeurs des tests de spawn. Goal actif.

Ajouts :21 liens natifs,76 liens consommateurs,6 ancres,3 sources,21 questions ouvertes,0 résolution. Graphe :98633 sources,2462 consommateurs,25586 questions ouvertes,5517 résolues avec historique.
