# Jinx — sources du passif et consommateurs actuels, V582

Date UTC : 2026-10-26T03:34:36.134607+00:00. Projet : `F:/OpenLeague`. Tâche active : **SYS-01.2-02**, relier chaque exigence à une source native et à son consommateur actuel.

## Résultat et portée

Les trois fiches du passif de Jinx sont reliées à **15 ressources natives**, soit **45 associations**, et aux **24 points de code actuels** pertinents, soit **48 liens** pour le contrat et la simulation. Quatre sources de preuves sont ajoutées au registre. Les anciens liens, critères, statuts, trois inconnues propres et quatre dépendances sont conservés. Les lecteurs de sources ne deviennent pas des implémentations de gameplay.

Le moteur courant permet les attaques et éliminations ordinaires de Jinx. **Son accélération après élimination n’est pas observée dans les deux scénarios exécutés.** Les sources textuelles décrivent le déclenchement historique, mais les callbacks serveur et la courbe exacte de décroissance ne sont pas récupérés par cette inspection. Cette livraison documente et raccorde l’écart ; elle n’implémente pas le passif et ne termine ni Jinx ni le jeu.

## Référence et sources

Référence conservée : PUBLIC 4.20.0.315, EUW / en_GB, build littéral du 2014-11-17 à 17:46:45 ; fuseau et déploiement non établis. Le catalogue 4.20.1 reste distinct. Les fichiers proviennent de la solution native `lol_game_client_sln/releases/0.0.1.68/deploy` du client original sur D:. L’appartenance au manifeste, tailles et hashes sont consignés ; elle ne prouve pas l’ordre de montage de toutes les archives.

| Fichier | Source enregistrée |
|---|---|
| Jinx.inibin | OLS-80754f10-86e3-5e1b-93da-f5dae6f921ef |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptJinx.luaobj | OLS-61703bdc-02b7-58f6-bdd5-d258cd56e1a9 |
| CharScriptJinx.preload | OLS-4c3e2a06-ca97-5331-8772-1915805a0bf1 |
| JinxInhibitorMonitor.luaobj | OLS-8881c14c-64b6-5da2-892b-c340fb247de4 |
| JinxInhibitorMonitor.preload | OLS-04ffd869-c27e-5eca-a78b-ffa668043af0 |
| JinxPassiveKill.inibin | OLS-3fd68d96-cfec-58d6-9ae3-864ae4c1a536 |
| JinxPassiveKill.luaobj | OLS-1147ce01-7cfa-5940-8f4b-ebac3be83be6 |
| JinxPassiveKill.preload | OLS-c2faa550-9d46-5944-ae9b-b496fdd19b44 |
| JinxPassiveKillMarker.luaobj | OLS-7d7bce95-42cc-52ff-99ed-7a2c39e99da6 |
| JinxPassiveKillMarker.preload | OLS-5b7ee641-2eba-5d62-92fe-821f1c9f1d1a |
| JinxPassiveMarker.inibin | OLS-b8603e45-edb6-56f7-acf9-ae116b1145cd |
| JinxPassiveMarker.luaobj | OLS-a3deabde-e71f-53b9-981d-8295bb05073e |
| JinxRunCycleManager.luaobj | OLS-17fba967-17c6-5ba2-9925-dca0e8895a61 |
| Jinx.ddf | OLS-14783947-a904-5eee-9eea-1139ae17cdd8 |

Constats vérifiés :

- `Jinx.inibin` : `Passive1LuaName=JinxPassiveMarker`, icône `Jinx_Passive.dds`, vitesse 325. `PassLev1Desc1` et les six champs de niveaux du passif sont absents, sans substitution de valeur. La description est consultée par sa clé explicite, pas présentée comme une liaison depuis ce champ absent.
- Localisation en_GB, ligne 2115 : le buff Marker décrit un champion, une tour ou un inhibiteur endommagé dans les trois dernières secondes, puis tué/détruit ; bonus de 175 % de vitesse décroissant sur quatre secondes. La description ligne 4207 confirme les catégories et les trois secondes. Le buff Kill ligne 2114 décrit l’accélération. Les deux liaisons de buffs sont résolues exactement.
- Six fichiers Lua sont lus entièrement, avec initialisation littérale qualifiée et zéro prototype enfant. Cela qualifie leurs métadonnées, pas une exécution du serveur historique.
- Le Marker déclare `Bowmaster_Bullseye.dds` ; le Kill déclare `Jinx_Passive.dds` et `Jinx_Passive_Buff.troy`. Le moniteur d’inhibiteur déclare `JinxCatchMe` et `Jinx_Hidden.dds`. Ces identités différentes sont conservées sans correction automatique ni adoption des effets d’un autre sort.
- Quatre preloads décrivent la chaîne marker / run cycle / kill marker / inhibitor monitor / kill et les ressources liées. Le preload Kill référence aussi `root` et un effet on-kill ; cela ne prouve ni une immobilisation de gameplay ni un rendu effectif.
- Le DDF contient 72 lignes de contexte, dont 16 anciennes lignes Vi et aucune entrée `JinxPassive`. Les liens `totalattackdamage` du Q2 ne sont pas une formule de vitesse du passif. La vitesse d’attaque du minigun/Q et les effets sociaux Caitlyn/Vi restent distincts.
- Huit références communautaires sont identifiées et conservées séparément. Le `CharScriptJinx.cs` inspecté est une classe vide. Les scripts Q/W/E/R et les JSON de métadonnées ne sont pas qualifiés comme code du serveur Riot.

## Exécution du moteur actuel

Diagnostic Rust privé, compilé avec `cargo build --locked --offline`, lié au vrai `crates/core/src/lib.rs` non-test. Identités/checksums des dépendances alignés sur le lock racine. **1 158 entrées de code et ressources**, les registres avant publication et les preuves antérieures sont vérifiés par SHA-256. Les échecs et la correction de compteur Jax V580 restent dans la chaîne.

Exécutable : `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-jinx-passive-get-excited-probe.exe` ; taille 6056960 octets ; SHA-256 `73641609917d7aab84f0acc1650d89a0a7d4e54e30c8dbc933c70f3f1e1b1ea1`.

Deux simulations Map10 neuves, Jinx contre Annie : déplacement public jusqu’à la zone centrale, attaques publiques, deuxième élimination après réapparition naturelle d’Annie. Achat public de bottes 1001 dans le second cas. Aucun changement direct de vie, d’expérience, de niveau, de minuterie ou de position. Les gains d’expérience ordinaires restent observés, sans supposer un niveau inchangé après la deuxième élimination.

| Cas | Vitesse après kill | Impacts avec témoins | Kills | Or par kill | Refus | Ticks après kills |
|---|---:|---:|---:|---|---:|---:|
| base | 325 | 24 | 2 | [400.0, 300.0] | 17 | 360 |
| boots | 350 | 24 | 2 | [400.0, 300.0] | 17 | 360 |

Total : **48 baisses de vie avec projectiles source/cible témoins, quatre éliminations, 34 refus inchangés, 720 ticks après élimination et 20 pas mesurés**. À 30 ticks/s, chaque fenêtre post-kill de 180 ticks couvre six secondes. Cinq ticks de déplacement puis 175 ticks après Stop sont observés par élimination ; les positions sont contrôlées avec résidu inférieur à 0,005 unité. Les snapshots sont des preuves du diagnostic local, pas du transport réseau ou du rendu.

| Contrôle | Attendu du contrôle | Observé |
|---|---|---|
| Kill réel par Jinx | Événement avec bon tueur/victime et projectile témoin | Deux kills par cas, sans assistant |
| Récompenses ordinaires | Premier sang 400, kill suivant 300 ; or ambiant séparé | Conforme dans les deux cas |
| Bottes | Vitesse de base 325 + 25 | 350, conservée après les kills |
| Recherche d’accélération | Échantillonner le tick de mort et les 180 ticks suivants | Aucune hausse : 325 ou 350 |
| Refus publics | Joueur inconnu, attaque sur soi, slot invalide, Learn/Cast/CastAt QWER non implémentés, cible morte | 17 refus par cas ; snapshots inchangés |
| Nouvelle vie de la cible | Attendre la réapparition normale, puis recommencer | Deuxième événement distinct et récompense 300 |

Le succès technique du diagnostic signifie que cet écart est reproduit et borné. Il ne signifie pas que l’acceptation historique du passif réussit. La présence de projectiles témoins n’est pas étendue aux anciennes observations Draven partiellement non attribuées.

## Fonctions reliées

| Point du code | Rôle et limite |
|---|---|
| crates/core/src/lib.rs:533 | initialization |
| crates/core/src/lib.rs:598 | public_actions |
| crates/core/src/progression.rs:68 | speed_reader_no_GetExcited |
| crates/core/src/progression.rs:46 | ordinary_level_growth |
| crates/core/src/progression.rs:150 | learn_boundary |
| crates/core/src/progression.rs:159 | unsupported_Jinx_ranks |
| crates/core/src/spells.rs:101 | unsupported_Jinx_cast |
| crates/core/src/annie_w.rs:29 | unsupported_Jinx_ground_cast |
| crates/core/src/lib.rs:685 | tick_order |
| crates/core/src/movement.rs:53 | base_items_no_GetExcited |
| crates/core/src/movement.rs:38 | no_kill_speed_modifier |
| crates/core/src/movement.rs:19 | local_policy_not_native_Jinx_curve |
| crates/core/src/shop.rs:215 | Boots_positive_control |
| crates/core/src/shop.rs:261 | public_purchase |
| crates/core/src/ally_occupancy.rs:635 | actual_public_movement |
| crates/core/src/lib.rs:744 | diagnostic_not_network_acceptance |
| crates/core/src/lifecycle.rs:33 | public_enemy_respawn_not_Jinx_buff_lifecycle |
| crates/core/src/attacks.rs:157 | actual_ranged_projectiles |
| crates/core/src/damage.rs:53 | actual_champion_death_dispatch |
| crates/core/src/champion_kills.rs:26 | ordinary15second_assist_window_not_Jinx3second_window |
| crates/core/src/champion_kills.rs:32 | ordinary_rewards_no_GetExcited |
| crates/core/src/champion_kills.rs:13 | ordinary_kill_level_growth_not_passive |
| crates/core/src/world.rs:355 | static_only_structure_death_no_Jinx_callback |
| crates/core/src/passive_gold.rs:16 | ordinary_gold_separated_from_kill_reward |

Les fonctions de contribution et récompense utilisent la fenêtre générique d’assistance de **15 secondes**, distincte du texte Jinx de **3 secondes**. Le pipeline de vitesse applique les modificateurs actuellement pris en charge sans bonus Get Excited. `world.rs::damage_unit` est une frontière inspectée statiquement pour les structures ; aucune destruction de tour/inhibiteur n’a été exercée dans ce diagnostic. Dix ressources locales de règles et profils sont liées séparément des sources natives.

## Manques et limites restant ouverts

1. Implémentation du déclenchement Get Excited dans le moteur et raccordement aux événements de dégâts/mort/destruction.
2. Forme exacte de décroissance du bonus, ordre de calcul avec objets/ralentissements/softcaps, arrondis, répétition et rafraîchissement.
3. Conditions aux limites des trois secondes, assistance récente ou expirée, dégâts annulés/absorbés, attribution des invocations et éliminations simultanées.
4. Tours et inhibiteurs ; exclusions des autres catégories à établir par contrat. Les cas actuels ne qualifient ni assistance ni structure.
5. Mort/réapparition de Jinx pendant le buff, déconnexion, nouvelle session et fin de partie. La réapparition observée ici concerne Annie.
6. HUD, icônes, course, VFX, son et synchronisation réseau. Les preloads et métadonnées ne suffisent pas à les accepter.
7. Absence de corps serveur historique dans les fichiers inspectés ; classe communautaire vide. Aucun asset 3D manquant n’est déduit de ce seul constat.

Le défaut de déplacement V564 et les autres inconnues du projet restent ouverts. Le présent audit ne résout pas les limites de BattleTraining ni celles d’autres champions.

## Incident de stockage et conservation

Le PREPARE initial est sorti avec le code 1 pendant la sauvegarde SQLite. F: avait zéro octet libre ; aucune publication du registre n’avait commencé. Le lot `revision582_Jinx`, son script, son log et son reçu sont conservés.

Trois essais de récupération ont ensuite été interrompus : compression signalant `[ERR]` malgré le code 0 de `compact`, relecture avec marge insuffisante, puis relecture cumulée après douze contrôles individuels réussis. Ces essais ne sont pas présentés comme des succès globaux. Leurs scripts et logs sont conservés.

La sauvegarde incomplète de 339 234 816 octets et son journal de 1 024 octets ont été conservés sur E: avec SHA-256 avant retrait de leurs copies temporaires sur F:. Deux sauvegardes historiques ont été temporairement copiées sur C:, vérifiées, puis rétablies sur F: à leurs chemins exacts. Les copies de secours restent conservées.

La cause principale identifiée est le cache Rust incrémental `F:/OpenLeague/target/debug/incremental` : 69 947 fichiers, 175 999 930 310 octets. Après vérification de son chemin, de l’absence de liens de redirection, de compilation active et de source enregistrée, seul ce cache régénérable ignoré par Git a été supprimé. Sources, assets, exécutables et preuves n’ont pas été supprimés. Les prochaines compilations pourront recréer ce cache.

Une relecture finale indépendante a confirmé les mêmes SHA-256 pour les douze sauvegardes historiques et leurs chemins rétablis. L’espace libre était alors de 173 090 668 544 octets. Aucun nettoyage supplémentaire de JSON n’a été exécuté. Preuves : `E:/mapslol3v3/revision582_storage_recovery/RESULT.json`, `CACHE_CLEANUP_RESULT.json`, `TEMPORARY_OFFLOAD.json`, `INCOMPLETE_BACKUP_RELOCATION.json`.

## Publication et contrôles

Le nouveau lot `revision582_Jinx_qualified` conserve l’échec précédent et exécute dans l’ordre **PREPARE, CHECK, PUBLISH, AUDIT**, chacun avec retour 0. Les candidats sont vérifiés avant la publication.

- 72 mutations invalides d’association et quatre mutations invalides du graphe sont refusées.
- Trois fragments de consignes modifiés, 42 212 inchangés ; anciens objets hors périmètre conservés.
- Deux bases locales : quatre lignes destinataires mises à jour dans leurs données/consignes, 42 603 autres lignes conservées, **42 607 états manuels et 23 lignes d’historique inchangés** ; synchronisation idempotente.
- Identités, hiérarchie et registre d’inconnues inchangés octet pour octet. Compteurs d’inconnues et dépendances dérivés des tableaux réels.
- Graphe : 99 005 sources, 3 592 consommateurs, 42 215 exigences, 26 189 inconnues ouvertes et 5 517 résolues déjà recensées. Revue globale : 3 592 ancres exactes, zéro divergence courante. La validation structurelle ne prétend pas re-hacher les 99 005 sources ; les entrées sélectionnées sont vérifiées séparément.

Fichiers de livraison : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`, `docs/reference_requirement_trace_sources/jinx-passive-get_excited-links-v582.json`, `docs/fidelity_jinx_passive_get_excited_links_v582.json`, ce rapport, les documents `coverage.json`, `completion_plan.json`, `resume_checkpoint.json` et les notes `docs/ai/CURRENT.md` / `HANDOFF.md`. Les deux bases de suivi sont synchronisées sans acceptation automatique. Aucun code de gameplay ni asset n’est modifié.

Détails reproductibles : `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20/revision582_Jinx_discovery`, `revision582_Jinx_passive_probe`, `revision582_Jinx_inspection_verified`, `revision582_Jinx_qualified`, et revue `revision583_trace_review/REVIEW.json`. Les scripts, hashes, résultats attendus/observés et journaux réels sont inclus dans les reçus.

## Reprise du goal actif

Continuer SYS-01.2-02 depuis revision583_trace_review/REVIEW.json. Jinx V582 publié et audité : 15 sources natives, 45 associations, 24 points/48 liens; 2 cas publics, 48 impacts avec projectiles témoins, 4 kills, 34 refus sans mutation, 720 ticks et 20 pas mesurés. Vitesse325/350 inchangée malgré kills; récompenses400/300 distinctes. Texte175% décroissant4s après contribution3s; courbe, assistance, structures et cycle de vie ouverts. Six Lua littéraux, deux buffs liés, quatre preloads, DDF72dont16Vi, huit communautaires; CharScript vide. Préserver l’échec initial PREPARE pendant saturation de F:, les trois essais de récupération interrompus, la relocalisation exacte de la sauvegarde incomplète sur E:, et les reçus de compression de12bases et du nettoyage du cache incrémental de176Go avec chemins historiques rétablis. Surveiller l’espace F: avant toute nouvelle copie; ne pas effacer de preuve. ChaîneJaxV580 et défaut déplacementV564 ouverts. Poursuivre un autre passif après inspection réelle, par exemple Karma. Aucun statut/case/inconnu fermé; goal actif.
