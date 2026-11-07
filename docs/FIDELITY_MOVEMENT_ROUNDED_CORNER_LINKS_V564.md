# SYS-01.2-02 — Déplacement : annulation au coin d’une cellule, V564

Date UTC : 2026-10-25T22:41:36.540071+00:00. Projet F:/OpenLeague. Référence PUBLIC 4.20.0.315 EUW/en_GB, build littéral 2014-11-17 17:46:45 ; fuseau et déploiement inconnus ; catalogue officiel 4.20.1 distinct.

## Résultat et portée

Le défaut local de déplacement est reproduit et relié au code qui le produit. Le chemin calculé accepte un segment diagonal ; les étapes f32 de déplacement dévient légèrement du segment et traversent une cellule bloquée. `prefix` refuse le mouvement, puis `advance_allied_motion` efface chemin, destination et ordre. Cette livraison établit la trace, elle ne corrige pas le gameplay.

Six fiches existantes enrichies : CHEMIN, BLOCAGE et parent MOUVEMENT de Diana et de Garen. SYS-01.2-02 référence ce lot. Trois points de code enregistrés et cinq points existants réutilisés. Sources natives, anciens consommateurs, statuts, dépendances, critères, cases, notes et historiques conservés. Les fiches de rayon ne sont pas déclarées fautives.

## Contrôles exécutés

Deux programmes utilisent réellement Simulation/Map10 et les commandes publiques Move/Buy. Aucun état de combat, position ou vitesse injecté. Six parcours simples réussissent ; la comparaison de huit configurations reproduit quatre annulations. Le succès de collecte ne signifie pas succès des parcours.

| Cas | Résultat observé | Tick |
|---|---|---|
| diana_blue | arrived | 790 |
| garen_blue | arrived | 790 |
| darius_blue | arrived | 801 |
| diana_blue_boots | arrived | 736 |
| diana_red | arrived | 802 |
| diana_blue_waypoint | arrived | 690 |
| diana_enemy_only | arrived | 790 |
| diana_ally_present | path_cancelled_before_arrival | 392 |
| diana_original_four | path_cancelled_before_arrival | 392 |
| garen_ally_present | path_cancelled_before_arrival | 392 |
| darius_ally_present | arrived | 811 |
| diana_boots_ally | arrived | 733 |
| diana_red_four | arrived | 797 |
| diana_waypoint_ally | path_cancelled_before_arrival | 396 |

Attendu pour le mouvement : atteindre la destination autorisée. Observé pour Diana/Garen avec allié : arrêt au tick 392 à (3305.112548828125,4214.109375), destination effacée. Waypoint Diana : arrêt au tick 396 à (3308.349365234375,5057.6083984375). Ennemi seul, Darius, bottes ou équipe opposée réussissent dans leurs cas respectifs. Ces comparaisons ne permettent pas d’attribuer isolément la cause au rayon ou à la vitesse.

Le diagnostic géométrique utilise une copie textuellement vérifiée des fonctions courantes, séparée du moteur. Il retrouve les mêmes bits f32, cellules et décisions que le parcours réel. Le segment entier entre deux points du chemin observé est accepté dans les quatre cas. Le petit segment du tick est refusé dans les quatre cas. Dans les segments entiers observés, les coordonnées de grille x vont de 64.50000061035156 à 65.50000061035156 : le passage x précède légèrement le passage z (tX≈0.49999938965, tZ=0.5), donc le côté libre est traversé en premier. Les sous-segments f32 inversent cet ordre et traversent le côté bloqué. Pour le premier coin, tZ=0.5987750690524799 < tX=0.5988193172606548 : entrée dans la cellule 982, flags=2, non marchable. Pour le waypoint, tZ=0.20068456134028997 < tX=0.20075882670828854 : cellule 6490, flags=2. Départ et arrivée sont dans des cellules marchables. Les indices f32/f64 des extrémités concordent ; leur désaccord n’est pas la cause observée.

Un nouvel ordre Move est accepté et produit un tick de mouvement autorisé après chaque annulation. Le trajet complet après cette reprise n’a pas été testé.

## Échecs de diagnostic conservés

`revision564_movement_segments_probe` : build0/run101 ; recherche erronée du point dans le chemin initial alors que le chemin observé avait changé. `revision564_movement_segments_probe_qualified` : build0/run101 ; comparaison JSON trop stricte d’un f64 de hauteur après lecture, alors que les coordonnées f32 et décisions concordaient. Le dernier programme vérifie les bits f32, indices, flags et décisions ; aucun epsilon de navigation n’a été introduit. Les deux anciens binaires, sources et journaux restent pinés. Ce sont des échecs d’instrumentation, distincts des annulations réellement observées.

## Binaires, ressources et consommateurs

- `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-current-movement-cancellation-probe.exe` : 6096384 octets, SHA256 `56b1077cbe076d6d99097be5a6b85bebba0c10656bff4fcffb1b705e2f81718d` ; build et exécution code 0.
- `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-current-movement-cohort-probe.exe` : 6100992 octets, SHA256 `e056ebf90c0f0e1eed102a502b19821a3c7af057f3f6c844cf472f65bbd94f3a` ; build et exécution code 0.
- `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-current-movement-segments-verified-probe.exe` : 2544128 octets, SHA256 `ee04d206c3d7c45def8cc46c01cfcdce2177affd346d158016fe61afd2b99575` ; build et exécution code 0.

Ressources courantes : `assets/maps/tt_navigation_grid.json`, `assets/maps/tt_navigation_grid.cells.bin`, profils de collision et définitions de champions déjà pinés parmi 1158 entrées. Les scripts vérifient aussi Cargo.lock, la dépendance non-test openleague_core et les anciens artefacts. Aucun client ou serveur historique exécuté. Les trois reçus OBSERVATIONS et INPUTS_BEFORE enregistrent tailles et SHA256 ; le reçu d’intégration vérifie les sources natives déjà liées aux six exigences. Une vitesse ou un rayon natif ne prouve pas l’algorithme historique de cheminement.

- `OLC-2cbdef7f-bdd4-5a9f-ac06-79c58d6c65f1` → `crates/core/src/ally_occupancy.rs:526` : `fn fit_step(`.
- `OLC-02ed4637-294a-5e0a-b470-a62e0b03cb6e` → `crates/core/src/ally_occupancy.rs:544` : `fn prefix(`.
- `OLC-73ebfee2-8ce9-5c30-b40b-bc5666b7ae3a` → `crates/core/src/pillar_navigation.rs:88` : `fn terrain_segment(`.
- `OLC-3d7c5e5c-eb3c-586f-9218-52249a2b62c1` → `crates/core/src/ally_occupancy.rs:610` : `fn occupancy_replan(`.
- `OLC-ef7d6db7-3803-545e-88ff-4442d6890c57` → `crates/core/src/ally_occupancy.rs:757` : `if terrain_blocked {`.
- `OLC-4d6e5e1c-614d-5686-9373-960b07097a98` → `crates/core/src/ally_occupancy.rs:175` : `fn edge(&self, a: Point, b: Point)`.
- `OLC-2277cf85-2481-5895-a345-973308b65975` → `crates/core/src/ally_occupancy.rs:281` : `pub(crate) fn route(`.
- `OLC-d0ece054-aa33-5660-bb20-7c81f541d78a` → `crates/core/src/pillar_navigation.rs:166` : `pub(crate) fn segment_allowed(`.

## Validation de livraison

Prepare/check/publish/audit : code0. 66 associations volontairement invalides refusées ; trois graphes invalides refusés. Lecture réelle Store.task/copy_text/summary et résolution des traces vérifiées. Deux bases SQLite mises à jour : sept destinataires, 42600 autres lignes de catalogue, 42607 états manuels et 23 événements historiques conservés exactement ; intégrité et sync idempotente vérifiées.

Identifiants, hiérarchie et registre d’inconnues inchangés en octets. Graphe : 42215 exigences,98932 sources,3184 consommateurs ; revue fraîche des 3184 ancres et fichiers courants, zéro divergence. Cette revue ne rehash pas toutes les 98932 sources. Aucun pourcentage de jeu terminé déduit de ces nombres.

## Limites et travail restant

- Corriger séparément la cohérence entre route diagonale et pas représentables, sans autoriser le passage à travers les cellules bloquées ; rejouer ces parcours et élargir les vitesses, orientations, obstacles et équipes.
- Vérifier la reprise jusqu’à destination, la congestion dynamique, les ordres d’attaque, les décès/contrôles et la synchronisation réseau ; non qualifiés ici.
- Comparer à une preuve historique 4.20 de navigation et de collision. L’algorithme natif n’est pas établi par les valeurs du client.
- Ni rendu Blender, textures, audio, animations ni gameplay complet de champion validés. Aucun manque d’asset établi par ce défaut de mouvement. Les lacunes Battle Training restent locales et ouvertes.

## Fichiers modifiés

Les registres `completion_tasks_2026-10-20.json`, `fidelity_requirement_trace_4_20.json`, `fidelity_sources_4_20.json` ; reçu `reference_requirement_trace_sources/movement-rounded-corner-links-v564.json` ; preuve `fidelity_movement_rounded_corner_links_v564.json` ; ce rapport ; couverture, plan et checkpoint complétés ; CURRENT/HANDOFF actualisés avec sauvegardes ; les deux bases de plan. Aucun code gameplay ni asset modifié.

Continuer SYS-01.2-02 depuis revision565_trace_review/REVIEW.json. V564 rattache les annulations de déplacement aux six fiches CHEMIN/BLOCAGE/MOUVEMENT de Diana et Garen, avec sources natives et anciens liens conservés.14 parcours publics:10 arrivées,4 annulations. Causes locales reproduites:segment diagonal accepté entre centres, sous-segment f32 traverse une cellule bloquée (982 ou6490), puis clear_order. Ne pas confondre ce diagnostic avec correction, manque de textures, défaut de rayon ou comportement du serveur natif. Retry:un tick réussi seulement. Deux diagnostics échoués conservés;segments_probe_verified utilise les coordonnées f32 exactes et le couple de points observé, pas le chemin initial. Aucun statut/case/inconnu fermé. Préserver la chaîne INPUTS_BEFORE.previous_artifacts des trois probes V564 et celle de nearby V563. Reprendre les exigences restantes des champions à chargeur seul, notamment le prochain passif non qualifié, après inspection des sources et consommateurs réels. La correction gameplay du coin et sa matrice de régression restent une tâche distincte du présent objectif de traçabilité; goal actif.
