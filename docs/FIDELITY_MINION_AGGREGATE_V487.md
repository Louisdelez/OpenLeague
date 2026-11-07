# SYS-01.2-02 — Sources et IA des sbires, consolidation V487

Les huit fiches SOURCE et les huit fiches AI générales des sbires Blue/Red Basic, Wizard, MechCannon et MechMelee sont reliées à leurs preuves détaillées. Les associations SOURCE de V250 restent conservées. Les40 tâches comportementales détaillées, leurs critères et leurs40 questions restent inchangés. Aucun gameplay, asset ou état manuel modifié.

Référence : LoL4.20.0.315 PUBLIC Releases/4.20, EUW/en_GB ; build2014-11-17 à17:46:45, fuseau et déploiement non établis ; catalogue4.20.1 distinct. Projet F:/OpenLeague.

## Ce qui est intégré

Chaque SOURCE conserve ses25 champs typés V250, soit200 champs pour les huit définitions. Les valeurs courantes ont été comparées à ces observations héritées. Les fichiers natifs et communautaires liés sont réidentifiés ; leurs rôles restent distincts. Les31 anciennes ancres SOURCE uniques correspondent toujours aux fichiers et lignes actuels. Elles ne sont ni supprimées ni remplacées.

Chaque SOURCE référence quatre sous-preuves pertinentes : acquisition/valeurs de cible, attaque, voie et améliorations. Chaque AI référence exactement ses cinq prérequis actuels : CIBLE, ATTAQUE, VOIE, AGGRO et UPGRADE. Les preuves enfant utilisées par SOURCE sont des références documentaires ; aucune dépendance inverse n'est ajoutée au plan. Les cinq sous-tâches continuent de dépendre de SOURCE comme auparavant.

Les nouvelles références rendent explicite la distinction entre données présentes, lecture par le code, comportement local mesuré et règles natives restant inconnues. Aucun nouveau consommateur n'est inventé : les ancres existantes sont réutilisées et vérifiées.

## Preuves héritées revalidées

| Lot | Portée de l'exécution antérieure | Cas hérités |
| --- | --- | ---: |
| V483 | Acquisition, visibilité, cadence de recherche et aggro dans des scènes contrôlées |96|
| V484 | Portée, cadence, capture d'attaque, impact, interruptions et projectiles |116|
| V485 | Naissances, deux voies, reprise après stun/combat, seuil29/30 |80|
| V486 | Améliorations à la naissance, seuils temporels, plafond d'or, unité existante |64|

Les quatre reçus, leurs entrées, exécutables, outils, scripts, sorties et sources ont été réidentifiés. Les356 cas ne sont **pas rejoués** dans ce lot. Aucun build, jeu, serveur historique, rendu, audio ou test visuel exécuté. Les preuves conservent leurs conditions d'isolation : cibles et positions contrôlées, attaques inhibées selon le lot, sauts temporels, inhibiteurs contrôlés pour supers, unités inertes pour isoler les parcours.

Le suffixe de schéma v481 erroné dans le reçu runtime V485 reste documenté par son propre reçu d'association ; les chemins, hashes et observations V485 ne sont pas réécrits. Les autres limites historiques, dont les échecs corrigés précédemment, restent accessibles dans leurs rapports.

## Limites désormais visibles sur les fiches générales

SOURCE : target_info lit definition.radius pour la portée envers les NPC. Le rayon gameplay ne devient pas automatiquement un rayon de pathfinding ou de sélection. Le chemin local reste ponctuel, alors que les trois rayons natifs sont conservés séparément dans les sources. Le code calcule un niveau moyen de joueurs puis l'affecte à _spawn_level sans l'utiliser pour les statistiques du spawn dans ce corps ; aucune règle historique de niveau n'en est déduite.

Restent à qualifier sur les sources : defaults absents, producteur des données, sélection/montage effectif, choix des variantes d'attaque, arithmétique et ancrage des timers, collisions, bonus d'inhibiteur et partage des récompenses. Les JSON décodés d'un paquet communautaire ne constituent pas le serveur natif. La présence d'un champ et son égalité numérique ne prouvent pas tous ses usages.

AI : les règles de ciblage par distance, les attaques capturées, les déplacements sur la grille et les améliorations au spawn disposent de preuves locales bornées. Les priorités et helpers natifs, toutes les annulations, les interactions entre unités, le retour au combat, les collisions et un cycle ordinaire continu restent ouverts. Les fiches PRESENT et ACCEPT sont distinctes et ne sont pas validées par cette consolidation.

Seize questions propres aux fiches générales sont ajoutées. Les40 questions des enfants sont conservées avec leur propriétaire et leur condition de résolution. La réunion des preuves ne ferme aucune de ces inconnues.

## Vérifications réellement effectuées

- Identités de1354 fichiers directement revalidées ; ancres comparées aux lignes courantes.
- Cinq refus de composition : type d'agrégat inconnu, enfant dupliqué, enfant manquant, autre définition et identité de tâche incohérente.
- Dix-sept sélecteurs nominaux et dix-huit invalides vérifiés ; trois refus publics pour propriétaire incorrect, fausse résolution et condition vide.
- 42 214 instructions comparées :16 modifiées,42 198 identiques. Sorties des autres tâches, critères et dépendances inchangés.
- Publication et audit indépendant des quatre registres et des deux bases :17 fiches/base,42 606 états/notes et23 historiques conservés exactement ;42 589 autres entrées du catalogue inchangées. Intégrité SQLite et chemins réels Store.task/copy_text vérifiés.

La première préparation a été refusée avant création du répertoire de préparation ou modification des registres/bases : le collecteur attendait27 champs par définition au lieu des25 consignés enV250. Vérification explicite des huit comptes, correction à25 et200 au total, puis préparation réussie. Le collecteur fautif est conservé dans revision487_prepare_failure01.py. Aucun test de gameplay n'a échoué, car aucun n'a été lancé ici.

## Livraison et reprise

Nouveaux : docs/reference_minion_behavior_sources/minion-aggregate-v487.json, docs/fidelity_minion_aggregate_v487.json et ce rapport. Scripts, sauvegardes et contrôles : F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision487*.

Modifiés : fidelity_sources_4_20.json, fidelity_requirement_trace_4_20.json, completion_tasks_2026-10-20.json, fidelity_unknowns_4_20.json ; bases F:/OpenLeague/runtime/project-plan/plan.sqlite3 et C:/Users/loicd/AppData/Local/Programs/OpenLeague Plan/data/plan.sqlite3 ; coverage.json, completion_plan.json, resume_checkpoint.json, ai/CURRENT.md et ai/HANDOFF.md. Aucun code de jeu ni asset modifié, aucune case cochée.

Le sous-inventaire de travail passe à167 fiches à reprendre (WORLD139, MODE27, SYS1),349 associations partielles revues et24 exclusions dont12 audio. Correction de lecture : la liste « pending » héritée contenait les huit SOURCE malgré leurs nombreuses associationsV250 déjà présentes. Elle n'était donc pas une preuve que toutes ses lignes ne possédaient qu'un chargeur générique. Ici les16 fiches sont retirées de cette liste après consolidation effective. Ce comptage ne mesure pas l'achèvement global du jeu.

Suite : inspecter les consommateurs et sources des huit PRESENT-MODEL, puis textures et animations. Vérifier ce qui existe avant de conclure à un manque ; garder l'identité des assets, la géométrie, l'échelle, la lecture effective et la validation visuelle séparées. Goal actif.

Ajouts : 932 liens natifs, 745 liens consommateurs, 0 nouveaux consommateurs, 1 source et 16 questions ouvertes. 1354 fichiers directement épinglés. Graphe : 98649 sources, 2511 consommateurs, 25684 ouvertes, 5517 résolues avec historique.
