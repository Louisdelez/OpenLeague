# AUD-17.4-05-ATTACKMOVE-CHAMPONLY-01 — attaque-déplacement et champions uniquement

Lot SYS-01.2-02 : SYS-17.4-05 / OLF-ade7b0e7-dee1-5e67-93ad-61a4ec86b2f9. Audit documentaire clos seulement après relecture indépendante R1–R7. Fonctionnalité partielle, acceptation humaine non donnée, jeu et goal global non terminés.

## R1 — Périmètre et prérequis

Objectif : Gérer attaque-déplacement et sélection de champions uniquement. État a_faire, implementation_complete=false et acceptance_complete=false conservés. Inconnue OLU-2ab8c64d-283b-568c-a541-48d3d9a67c92 open. Lot D17-SYS-17-4 exige D09-SYS-09-4, toujours a_faire; audit ne clôture pas ce prérequis. Aucun critère normatif modifié. Lot précédent selfcast clos documentairement uniquement, preuves réutilisées.

## R2 — Sources historiques et contrat borné

- native_defaults : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\defaults\Input.ini ; SHA-256 930f1499991e9c4973e81086a26c944b7330058970c4227a614b897eae09fec1 ; 331champs identiques à la preuve retenue.

  L409 [GameEvents] evtPlayerAttackMoveClick=[Shift] [Button 2]

  L410 [GameEvents] evtPlayerAttackOnlyClick=[<Unbound>]

  L411 [GameEvents] evtPlayerAttackMove=[a],[x]

  L423 [GameEvents] evtChampionOnly=[`]

- supplied_deploy_override : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\input.ini ; SHA-256 aead4280d339159623dbe8f39784bde4b87a6b05afc6d95f2feccec7ba99073a ; 13champs identiques à la preuve retenue.

- user_configuration_not_historical_default : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\Config\input.ini ; SHA-256 fa16e719b04249006b3ab7c77f7810e728d3743faf82e86cb259b6cc96d0a531 ; 27champs identiques à la preuve retenue.

- native_defaults : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\defaults\Game.cfg ; SHA-256 02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e.

  L340 [Options] CategoryEvents1=evtCastSpell1 evtCastSpell2 evtCastSpell3 evtCastSpell4 evtCastAvatarSpell1 evtCastAvatarSpell2 evtSmartCastSpell1 evtSmartCastSpell2 evtSmartCastSpell3 evtSmartCastSpell4 evtSmartCastAvatarSpell1 evtSmartCastAvatarSpell2 evtSelfCastSpell1 evtSelfCastSpell2 evtSelfCastSpell3 evtSelfCastSpell4 evtSelfCastAvatarSpell1 evtSelfCastAvatarSpell2 evtSmartPlusSelfCastSpell1 evtSmartPlusSelfCastSpell2 evtSmartPlusSelfCastSpell3 evtSmartPlusSelfCastSpell4 evtSmartPlusSelfCastAvatarSpell1 evtSmartPlusSelfCastAvatarSpell2 evtLevelSpell1 evtLevelSpell2 evtLevelSpell3 evtLevelSpell4 evtChampionOnly evtUseItem7

  L346 [Options] CategoryEvents3=evtPlayerMoveClick evtPlayerAttackMoveClick evtPlayerAttackOnlyClick evtPlayerAttackMove evtPlayerHoldPosition evtPlayerStopPosition evtPetMoveClick

- user_configuration_not_historical_default : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\Config\game.cfg ; SHA-256 64d34912ea5411b47d6da0de44da374dd0a9e396fe96dc2b1d87ca76d562110e.

Quatre événements : Shift+[Button2], A/X, AttackOnlyClick non affecté et [`] ChampionOnly. Catégorie mouvement pour les trois premières, capacités pour ChampionOnly. Aucun override de ces quatre événements dans deploy/user Input.ini fourni. Aucune clé AttackMoveOnCursor/ToggleChampionOnly dans les deux Game.cfg nommés : constat borné, pas absence universelle. Aucun comportement moderne, maintien/bascule, origine de recherche ou interaction attaque-déplacement/champion-only déduit. AttackOnlyClick sur sol vide et distinction temporelle Click/AttackMove restent inconnus.

PE original identifié sans exécution : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe ; SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Configurations déclaratives seulement, pas handlers natifs ni priorité provider qualifiés.

## R3 — Consommateurs actuels

Main passe skill==Some(3) à picking::target : filtre imposé par le slot du sort, pas mode utilisateur. Le picker exclut alliés/morts, projette à hauteur de chaque acteur, emploie rayon de sélection, ajoute les unités seulement si !champions_only puis minimise distance au centre. Ce n’est pas une priorité d’acquisition native qualifiée. Catalogue actuel laisse quatre rayons NPC absents (TT_OrderInhibitor, OrderNexus, TT_ChaosInhibitor, ChaosNexus); fallback160 local dans picker, sans corriger ces sources.

Clic droit : cible ennemie sous curseur→Attack(target), sinon terrain→Move(point). Action ne contient pas d’ordre AttackMove. Move efface target, Attack assigne target et Stop efface ordre. advance_pursuit traite seulement p.target et advance_attacks exige une cible déjà définie : poursuite explicite et acquisition automatique sont distinctes. Pas de chemin utilisateur A/X, Shift attaque-déplacement ou [`] identifié dans commands/corpus. Les seules occurrences physiques A sont des tests de texte boutique et QWER; aucune branche de jeu en découle.

Le picker ne vérifie pas lui-même FoW : snapshot_for filtre joueurs/unités, snapshot_for_atomic le réutilise et session_host l’envoie; Attack refuse target not visible et protection/allié/mort. Snapshot debug omniscient ne qualifie pas le réseau. Pas de fuite ni de parité historique globale revendiquée.

- F:\OpenLeague\crates\client\src\spell_input.rs:4–54 — fixed spell keys and ordered local shortcut ; SHA-256 2f99cb617bfd218da8d8125fcf65fbfea34eb602391899547cf065c758eadccf.

- F:\OpenLeague\crates\client\src\main.rs:1381–1394 — current command gate and existing Alt pet ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:1439–1501 — current user command dispatch and fixed slot3 filter ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\picking.rs:16–85 — enemy champion/unit geometric picker ; SHA-256 8415d4f86ca72c31484f1a9bf3df3faa94fcfb7cda4c684cc0c0bc30295bb2cb.

- F:\OpenLeague\crates\core\src\lib.rs:279–301 — current wire action enum ; SHA-256 cb2af93a240737ed3f1d3ee31cf4ff916e730f402e7d0b128e7f29e5a3ed004d.

- F:\OpenLeague\crates\core\src\lib.rs:598–684 — authoritative command Move Attack Stop and refusals ; SHA-256 cb2af93a240737ed3f1d3ee31cf4ff916e730f402e7d0b128e7f29e5a3ed004d.

- F:\OpenLeague\crates\core\src\combat.rs:1–54 — pursuit requires already selected target ; SHA-256 52ad492f9e8e01ee44b922658c1610d1dcd96a17c5674b2b15d4deed6fadce8a.

- F:\OpenLeague\crates\core\src\attacks.rs:137–155 — attack validity gate ; SHA-256 f6532eebe422900006c2af22a3fab2f0618f38938f8e24fc012fba340f1325bc.

- F:\OpenLeague\crates\core\src\attacks.rs:277–306 — attack initiation requires existing target ; SHA-256 f6532eebe422900006c2af22a3fab2f0618f38938f8e24fc012fba340f1325bc.

- F:\OpenLeague\crates\core\src\collision.rs:34–78 — selection radii and valid actor-height ray ; SHA-256 2e75c4eebb5203adcf9652b9ee69fb33f7904ca0788ce783c72a750dfbb26882.

- F:\OpenLeague\crates\core\src\vision.rs:137–169 — per-viewer snapshot filters entities ; SHA-256 1b13d6ee8dbd0561a79cb12bc8a622e1d47890c54231b745d4bedf55f28ac9fe.

- F:\OpenLeague\crates\core\src\vision.rs:206–213 — atomic snapshot retains base visibility projection ; SHA-256 1b13d6ee8dbd0561a79cb12bc8a622e1d47890c54231b745d4bedf55f28ac9fe.

- F:\OpenLeague\crates\server\src\session_host.rs:158–166 — real session host uses viewer snapshot ; SHA-256 ae65f3a022f1d235751dba408ba1a8856398f9e47943ddd3302b4f1428bc0ba7.

Recherche bornée1168sources : \bAttackMove\b|\battack_move\b|evtPlayerAttack(?:Move|Only)|evtChampionOnly|\bchampions_only\b ; 4correspondances épinglées. Absence lexicale complétée par enum/dispatch/poursuite inspectés, pas call graph universel.

Recherche bornée1168sources : KeyCode::(?:KeyA|KeyX|Backquote|ShiftLeft|ShiftRight) ; 2correspondances épinglées. Absence lexicale complétée par enum/dispatch/poursuite inspectés, pas call graph universel.

## R4 — Attendu, observé et contrôles réellement exécutés

Neuf tests CPU réutilisés,10sources actuelles identiques au run identifié : deux picking, quatre attacks et trois ally_occupancy. Journaux terminaux code0; retours finaux conservés avec anciennes lignes en cours. Aucun test relancé, aucun binaire historique réexécuté. Les identités des binaires de test sont enregistrées depuis leur exécution, pas rehashées à leurs anciens chemins aujourd’hui.

- client_tests journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log SHA-256 e92d1d1fedc29ec650da5fb536364cb29c8bdf02991a0b6782dbd7d3ecef53e3 ; binaire enregistré {"path": "E:\\OpenLeague\\target\\debug\\deps\\openleague_client-170289a4dedad9dd.exe", "sha256": "e2b2227752fb2e4db34a4602284dc6ff7359c393914619d0b502edcefe9aaddd", "bytes": 350254080}.

- core_tests journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\core_tests.log SHA-256 4d1161dda40d4d56de33399840916146e12d3c321cc8024d91778986b1574c35 ; binaire enregistré {"path": "E:\\OpenLeague\\target\\debug\\deps\\openleague_core-21eb81eb13817108.exe", "sha256": "6e9c5b42549fcf8b434979709ce0e845d4faf554552e6c5c4f3e5251f6da1623", "bytes": 787776512}.

- picking::tests::target_uses_actor_height_and_native_radius_instead_of_fixed_plane — attendu ok, observé ok, hérité non rejoué.

- picking::tests::dead_allied_and_behind_camera_targets_are_excluded — attendu ok, observé ok, hérité non rejoué.

- attacks::tests::valid_move_cancels_windup_but_rejected_move_preserves_it — attendu ok, observé ok, hérité non rejoué.

- attacks::tests::uncancellable_windup_rejects_stop_move_and_target_change_atomically — attendu ok, observé ok, hérité non rejoué.

- attacks::tests::stop_cancels_windup_without_damage_but_not_already_launched_missile — attendu ok, observé ok, hérité non rejoué.

- attacks::tests::lost_vision_cancels_prelaunch_but_snapshot_never_leaks_hidden_projectiles — attendu ok, observé ok, hérité non rejoué.

- ally_occupancy::ordinary_tests::repeated_attack_keeps_pursuit_but_still_rejects_invalid_target — attendu ok, observé ok, hérité non rejoué.

- ally_occupancy::ordinary_tests::mobile_target_replans_at_deadline_when_endpoint_is_no_longer_in_range — attendu ok, observé ok, hérité non rejoué.

- ally_occupancy::ordinary_tests::new_invalid_move_preserves_old_order_and_private_cache — attendu ok, observé ok, hérité non rejoué.

### A1 — Bindings et catégories natifs

Attendu : Définir sources exactes et laisser inconnue la sémantique non montrée.

Observé : ShiftButton2→AttackMoveClick, A/X→AttackMove, AttackOnlyClick unbound, [`]→ChampionOnly; catégories Options relues. Aucun override fourni pour ces événements.

Limite : Ni timeline, maintien/bascule, mapping OS ni comportement moderne prouvés.

### A2 — Mode utilisateur champions uniquement

Attendu : Filtre commandé par entrée utilisateur indépendante du slot.

Observé : Main passe skill==Some(3) au picker; aucun état/touche utilisateur identifié dans commandes et recherche bornée.

Limite : Filtre bool existant conservé; slot3 ne prouve pas evtChampionOnly.

### A3 — Clic droit et ordre

Attendu : Distinguer attaque directe, déplacement et attaque-déplacement.

Observé : Sous curseur, ennemi→Attack(target), sinon raycast_floor→Move(point). Move efface cible, Attack assigne cible; Action n’expose pas attaque-déplacement.

Limite : Pas d’intention A/X ou Shift ni acquisition automatique identifiée par ces consumers.

### A4 — Poursuite

Attendu : Conserver poursuite de cible explicite sans l’appeler acquisition.

Observé : advance_pursuit itère p.target, contrôle vie/équipe/vision et repath; advance_attacks exige p.target. Deux tests répétition/poursuite retenus.

Limite : Chercher cible en chemin, priorité d’acquisition et reprise destination restent ouverts.

### A5 — Refus atomiques

Attendu : Ordre refusé conserve windup/ordre; arrêt ne supprime pas missile lancé.

Observé : Quatre tests attacks et un invalid_move réutilisés couvrent cancel/invalid/windup incancellable/vision/Stop selon source.

Limite : Ce sont règles locales actuelles, pas preuve du serveur Riot ni d’un nouvel ordre attaque-déplacement.

### A6 — Choix sous curseur

Attendu : Préserver hauteur/rayon et exclure morts/alliés/rayons arrière.

Observé : Deux tests picking réussis avec bool true; helper exclut units lorsque true, sinon les ajoute et choisit distance au centre la plus petite.

Limite : Pas de test hérité de superposition champion/unit avec true/false; géométrie ne prouve pas priorité native. Quatre rayons NPC absents au catalogue, fallback160 local.

### A7 — Visibilité

Attendu : Aucun accès/acquisition à cible cachée.

Observé : snapshot_for filtre joueurs/unités, session_host utilise snapshot_for_atomic; Attack refuse target not visible. Picker travaille sur le snapshot reçu.

Limite : snapshot debug omniscient n’est pas preuve réseau; pas de qualification de tous les champs ou catégories natives.

### A8 — Combinaisons et inspection

Attendu : Qualifier interaction attack-move/champion-only, annulation, focus/chat et sélection inspection séparément.

Observé : Gates commandes existants; travaux focus, preview et inspection déjà décrits, réutilisés sans duplication.

Limite : Aucun test ou handler ne détermine interaction native; pas de toggle ni acquisition filtrée présumés.

222contrôles documentaires producteur réussis : identités, configurations, corpus/consommateurs et journaux. Non exécutés : compilation/tests Rust, jeu, REA, PE natif, GUI/OS/clavier, SQL/base, GPU/réseau. Deux tests picking avec bool true ne prouvent pas le mode utilisateur ni les collisions de sélection champion/sbire avec filtre activé/désactivé. Trois erreurs de découverte de chemin ont été corrigées par rg --files : combat_tests.rs absent, wildcard ally_occupancy* invalide et reference_input_commands.py absent; aucune conclusion d’absence fonctionnelle tirée de ces erreurs.

## R5 — Écarts et conditions de reprise

Restent ouverts : intentions A/X/Shift, ordre attaque-déplacement/acquisition/reprise, état utilisateur champion-only, filtres/action/sol vide, interaction des mécanismes et vrais parcours clavier. Entrée native requise : callback/xref/trace nommé reliant evtPlayerAttackMoveClick/OnlyClick/Move/evtChampionOnly à ordre/cible/état. Pas de réimport PE ou scan de sources inchangés sans piste nouvelle. Maintien/bascule, priorité, rayon et origine de recherche ne sont pas décidés. Les effets/target inspection restent un autre mécanisme (TARGET-01-SELECTION). Inconnue OLU-2ab8c64d-283b-568c-a541-48d3d9a67c92 toujours open.

## R6 — Corrections proposées, non appliquées

Aucun écart fonctionnel corrigé. Sept définitions existantes réutilisées :

- BIND-LOAD-01 — Common input configuration/editor; do not create another persistence subsystem.

- BIND-SAVE-01 — Common input configuration/editor; do not create another persistence subsystem.

- BIND-EDIT-CONFLICTS-01 — Common input configuration/editor; do not create another persistence subsystem.

- PREVIEW-INTENT-01 — Reuse pending intent/confirmation boundaries only where native attack-move policy is qualified; spell preview is not automatically attack radius.

- PREVIEW-CONFIRM-CANCEL-01 — Reuse pending intent/confirmation boundaries only where native attack-move policy is qualified; spell preview is not automatically attack radius.

- SELF-FOCUS-CONFLICT-01 — Reuse focus/capture conflict work for all targeting inputs; not imply self resolver implements attack-move.

- TARGET-01-SELECTION — Keep inspection selection identity separate from combat targeting; champion-only attack input does not implement target information inspection.

Sept objectifs complémentaires, chacun avec reprise et critères proposés; ils ne changent aucun critère normatif, tâche ou case du Plan :

### ATTACKMOVE-INPUT-01 — Relier les entrées attaque-déplacement aux intentions locales.

Tâches existantes : SYS-17.4-01, SYS-17.4-03, SYS-17.4-04

Travail : Qualifier A/X et Shift+Button2 : activation, confirmation/annulation et comportement en cas de plusieurs entrées. ; Respecter bindings chargés et captures UI; distinguer AttackMoveClick, AttackMove et AttackOnlyClick sans déduire leur timing du nom.

Critères de fin proposés : Entrée qualifiée produit exactement une intention/commande attendue, aucun Move/Attack parasite sur annulation/focus/repeat. ; Aperçu/curseur et étape éventuelle de confirmation suivent le contrat sourcé, pas un comportement moderne importé.

Condition de reprise : Autorisation produit distincte et handler/trace natif ou contrat local explicite accepté.

Dépendances : BIND-LOAD-01, CONTROL-NATIVE-ACTION-01, PREVIEW-INTENT-01, SELF-FOCUS-CONFLICT-01. État proposed_not_applied.

### ATTACKMOVE-ORDER-01 — Conserver un ordre attaque-déplacement autoritaire distinct de Move/Attack.

Tâches existantes : SYS-17.4-05

Travail : Identifier contrat d’ordre minimal, destination, acquisition et reprise; ne pas simuler la fonctionnalité par clic droit ordinaire. ; Préserver commandes Move/Attack/Stop et politiques de windup, contrôle, fin, session, répétition et interruption.

Critères de fin proposés : Sans cible admissible, transition/destination conformes au contrat; avec cible, ordre reprend ou finit selon règle identifiée. ; Refus invalide/inatteignable/contrôle conserve état antérieur; aucun double coût, reset de cadence ou projectile supprimé artificiellement.

Condition de reprise : Autorisation produit, contrat d’ordre et décision d’acquisition disponibles.

Dépendances : ATTACKMOVE-INPUT-01, ATTACKMOVE-ACQUIRE-01. État proposed_not_applied.

### ATTACKMOVE-ACQUIRE-01 — Qualifier et implémenter la sélection automatique d’attaque-déplacement.

Tâches existantes : SYS-04.6-01, SYS-04.6-02

Travail : Déterminer origine et rayon de recherche, priorité/égalité, types admissibles et reacquisition depuis source/trace nommée. ; Séparer sélection géométrique sous curseur et recherche de cible; réutiliser validation équipe/santé/protection/visibilité et portée serveur.

Critères de fin proposés : Cibles concurrentes champion/sbire/monstre/structure/invocation et absence de cible comparées au contrat déclaré. ; Cas caché, mort, allié, protégé, hors portée/recherche et déplacement de cible refusés/reconciliés sans fuite ni priorité inventée.

Condition de reprise : Nouvelle entrée native nommée sur acquisition/ordres ou règle locale explicitement marquée et acceptée; autorisation produit.

Dépendances : CONTROL-NATIVE-ACTION-01. État proposed_not_applied.

### CHAMPONLY-INPUT-01 — Relier evtChampionOnly à un état d’entrée utilisateur qualifié.

Tâches existantes : SYS-17.4-01, SYS-17.4-04, SYS-22.3-01, SYS-22.3-02

Travail : Qualifier la touche [`], disposition physique, maintien/bascule et remise à zéro; ne pas déduire une option toggle moderne. ; Réutiliser bindings/configuration et priorité ordonnée des modificateurs avec captures de texte/fenêtre/session.

Critères de fin proposés : Activer/désactiver l’état indépendamment de slot3; perte focus et changement session ne laissent aucun filtre bloqué. ; Cas clavier réel AZERTY/QWERTY et textes/captures documentés; test injecté identifié séparément.

Condition de reprise : Autorisation produit; callback/priorité/maintien du client original ou contrat local explicite disponible.

Dépendances : BIND-LOAD-01, BIND-EDIT-CONFLICTS-01, SELF-FOCUS-CONFLICT-01, CONTROL-NATIVE-ACTION-01. État proposed_not_applied.

### CHAMPONLY-ROUTE-01 — Appliquer le filtre utilisateur aux commandes et types de cible qualifiés.

Tâches existantes : SYS-04.6-01, SYS-04.6-02, SYS-17.1-07

Travail : Réutiliser le vrai paramètre champions_only; distinguer filtres imposés par sort et mode utilisateur. ; Qualifier si le filtre affecte clic direct, sorts, terrain vide et attaque-déplacement; ne pas décider cette interaction depuis le bool seul. ; Conserver sélection d’inspection et règles propres des sorts ciblant alliés/ennemis.

Critères de fin proposés : Superposition champion+sbire/monstre/structure/invocation testée filtre activé/désactivé; cible conforme et refus explicite. ; Sol vide et combinaison attaque-déplacement suivent preuve/contrat; protection et visibilité restent contrôlées côté serveur.

Condition de reprise : Autorisation produit, état utilisateur et sémantique native des actions concernées disponibles.

Dépendances : CHAMPONLY-INPUT-01, CONTROL-NATIVE-ACTION-01, TARGET-01-SELECTION. État proposed_not_applied.

### CONTROL-NATIVE-ACTION-01 — Qualifier les handlers historiques d’attaque-déplacement et champion-only.

Tâches existantes : SYS-17.4-05

Travail : Suivre les quatre événements natifs depuis bindings vers callback, type d’ordre, résolution et acquisition. ; Identifier confirmation A/X, ShiftButton2, comportement AttackOnlyClick vide et maintien/bascule evtChampionOnly; déterminer interaction des deux mécanismes.

Critères de fin proposés : Chaîne source→événement→ordre/état documentée par handler/xref/trace nommé; hypothèses et décisions locales distinctes. ; Priorité/reprise/origine de recherche et inconnues restantes explicites; pas d’analyse PE entière répétée sans entrée discriminante.

Condition de reprise : Nouveau callback/xref/trace précis du PE original déjà épinglé; ne pas répéter configurations ou scan inchangés.

Dépendances : Nouvelle entrée native discriminante. État proposed_not_applied.

### CONTROL-QUALIFY-01 — Vérifier réellement attaque-déplacement et filtre utilisateur.

Tâches existantes : SYS-17.4-05, SYS-22.3-01, SYS-22.3-02, SYS-17.4-08

Travail : Identifier binaires/source/assets; capturer A/X et ShiftButton2, changement de filtre et actions serveur. ; Réutiliser neuf tests composants; ajouter seulement les cas manquants d’ordres/acquisition/filtre et parcours réel.

Critères de fin proposés : Parcours deux commandes et interaction montrent cibles/destination/chronologie attendues; annulation/focus/chat/fin refusent sans mutation. ; Captures réelles et cas limites sont séparés des tests CPU; aucune qualification de tout le combat ou du jeu.

Condition de reprise : Autorisation produit; mécanismes et règles discriminantes implémentés et disponibles.

Dépendances : ATTACKMOVE-ORDER-01, CHAMPONLY-ROUTE-01, SELF-FOCUS-CONFLICT-01. État proposed_not_applied.

Tâches réutilisées, titre et état relus :

- SYS-17.4-01 / OLF-c010ba18-c9b6-59ab-b3a5-5b933320684a — Persister les raccourcis de capacités et d’objets : a_faire

- SYS-17.4-02 / OLF-4e001528-e50b-579e-ae58-e6eb088040f5 — Persister les modes de lancement normal et rapide : a_faire

- SYS-17.4-03 / OLF-dfcf608b-5420-5a99-9456-47574b64d7f5 — Afficher les indicateurs de portée avant confirmation : a_faire

- SYS-17.4-04 / OLF-7d5673b3-8e78-5446-831f-05ffd51d5849 — Gérer le lancement sur soi et les modificateurs de ciblage : a_faire

- SYS-17.4-08 / OLF-f51fd482-c241-572e-a85e-10ecbe4003f3 — Empêcher les saisies de chat de déclencher des commandes de combat : a_faire

- SYS-17.1-07 / OLF-fae17085-a8e6-5088-b3b5-8f83998772e7 — Afficher la cible sélectionnée et ses informations publiques : a_faire

- SYS-04.6-01 / OLF-b4b63c0d-2b5a-5a76-b054-952302efb33b — Valider les filtres allié, ennemi, neutre et soi-même : a_faire

- SYS-04.6-02 / OLF-2c3307f8-7f3d-5b52-881f-9af92ce7b07b — Valider les cibles champion, sbire, monstre, structure et invocation : a_faire

- SYS-09.4-07 / OLF-2fce7673-9d42-5799-833b-f72e89a9071a — Tester les commandes dans les bases, voies, jungle et passages étroits : a_faire

- SYS-22.3-01 / OLF-0098ca59-c07c-5c08-8536-f625cd4b3108 — Qualifier les touches par défaut sur clavier AZERTY : a_faire

- SYS-22.3-02 / OLF-e4793690-95a5-5851-9597-a954b69c6d72 — Qualifier les touches par défaut sur clavier QWERTY : a_faire

- SYS-22.3-03 / OLF-15336c59-7be4-5185-bc82-df51d624e3ec — Remapper une touche et gérer les conflits de raccourcis : a_faire

## R7 — Livraison et conservation

Nouveaux fichiers uniquement : audit-unit.json, verify_controls.py, attackmove-champonly-proof.json, ce rapport, verify_delivery.py et delivery-readback.json. Producteur audit_scope_closed=false; seule relecture R1–R7 clôture le parent documentaire. Fonctionnalité et goal global restent ouverts.

19fichiers logiciels gelés +6documents de contexte/méthode, cinq registres normatifs et Git suivi vérifiés inchangés. Aucun goal/critère normatif, produit, tracker/interface ou base modifié; aucune base ouverte, installation, migration, redémarrage, suppression ou écrasement. Anciens reçus et tentatives échouées conservés. Preuve principale F:\OpenLeague-work\audit-units\AUD-17.4-05-ATTACKMOVE-CHAMPONLY-01\attackmove-champonly-proof.json SHA-256 502f19ca065d7ed2ff29c4e196141cf7dd90a4037ca963f53afea2f5f6f36e81 ; relecture F:\OpenLeague-work\audit-units\AUD-17.4-05-ATTACKMOVE-CHAMPONLY-01\delivery-readback.json.
