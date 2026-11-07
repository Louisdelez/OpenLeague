# AUD-17.3-09-LAUNCHER-RETURN-01 — Retour au launcher

Date UTC : 2026-10-31T00:41:50.431473+00:00. Parent SYS-17.3-09 ; OLF-26cffc70-8cf2-5c6a-8775-8aca7c3c4a4b ; inconnue OLU-cbd04839-332b-51d0-a885-00164122c607.

## R1 — Périmètre et décision

Audit documentaire du parent entier : retour normal, résultats, crash, reprise, host/joined, drain, statut, fenêtre et durée de vie du launcher. La clôture de cet audit est subordonnée à delivery-readback.json et ses sept rubriques. Implémentation partielle ; vérification partielle et héritée ; acceptation humaine non donnée. Aucune fonctionnalité ni jeu déclaré terminé.

Aucun critère normatif modifié. D17-SYS-17-3 requiert D20-SYS-20-3, lui-même encore a_faire et dépendant de D20-SYS-20-1. Cela reste un prérequis de qualification fonctionnelle, pas une acceptation accordée par cet audit. Ancien lien limité à sessions_joined.rs:56 conservé ; aucune case ou inconnue modifiée.

## R2 — Contrat historique et provenance

Référence jeu PUBLIC 4.20.0.315 EUW/en_GB ; build 2014-11-17 17:46:45, fuseau/déploiement non établis ; catalogue 4.20.1 distinct. Client AIR identifié dans reference_frontend_builds_4_20.json : projet lol_air_client release 0.0.1.119, version 4.20.14_11_18_18_52. Les sources décompilées sont statiques ; aucune exécution AIR originale.

ApplicationController.onGameCompleted appelle MasterGameController.gameCompleted et maximise le client, sauf branche replay protégée. onGameCrashedOrAbandoned maximise puis choisit lobby pour NO_GAME/GAME_OVER ou RECONNECT autrement. Les callbacks crash/abandon sont enregistrés explicitement. Master.gameCompleted ne se confond pas avec cleanup ; InGame distingue tutoriel, spectateur, crash et déconnexion.

Chaîne de restauration complète identifiée : ViewMediatorImpl.maximizeClient → ShellEvent.RESTORE → WindowGlue.handleMaximizeEvent → signal windowRestoreRequested → BaseShell.onWindowRestoreRequested.restore ; autre listener BaseShell.handleRestoreFromSystrayEvent rend visible, active et orderToFront. ViewMediator.as est une interface, pas la preuve de l’implémentation ; DummyViewMediator ne remplace pas ce consommateur.

- F:\OpenLeague\docs\reference_loading_return_sources\air\ApplicationController.as:552 — onGameCompleted ; SHA-256 14614012a94c79933e7af2f6ec50334d33d6ae2cb88c99873d480862dd7649b9.

- F:\OpenLeague\docs\reference_loading_return_sources\air\ApplicationController.as:937 — onGameCrashedOrAbandoned ; SHA-256 14614012a94c79933e7af2f6ec50334d33d6ae2cb88c99873d480862dd7649b9.

- F:\OpenLeague\docs\reference_loading_return_sources\air\ApplicationController.as:1084 — registerGameCrashCallbacks ; SHA-256 14614012a94c79933e7af2f6ec50334d33d6ae2cb88c99873d480862dd7649b9.

- F:\OpenLeague\docs\reference_loading_return_sources\air\MasterGameController.as:1825 — gameCompleted ; SHA-256 6cee283b81ad29909c1dd700b4896effcd0d63a36ed648358f70428139d9d348.

- F:\OpenLeague\docs\reference_loading_return_sources\air\MasterGameController.as:1793 — cleanupAfterGameCompleteOrAborted ; SHA-256 6cee283b81ad29909c1dd700b4896effcd0d63a36ed648358f70428139d9d348.

- F:\OpenLeague\docs\reference_loading_return_sources\air\InGameController.as:246 — handleGameEarlyTermination ; SHA-256 c71c817a60b579370febf6cf1352090ad1f3a44b98741581e8209103a3d45bf6.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\ViewMediatorImpl.as:207 — maximizeClient ; SHA-256 98523b447e4dbf34ea1ad4a4a65905057b88b14d62a9cd4ccf5d293f02dfcc7b.

- F:\OpenLeague\docs\reference_air_sources\review\mod__win__ClientWindow_dat\scripts\BaseShell.as:334 — handleRestoreFromSystrayEvent ; SHA-256 6f12e267b1dd834fe81587511089e17953df9fb30a7b1ea7fdece7c6f4d3aa43.

- F:\OpenLeague\docs\reference_air_sources\review\mod__win__ClientWindow_dat\scripts\BaseShell.as:394 — onWindowRestoreRequested ; SHA-256 6f12e267b1dd834fe81587511089e17953df9fb30a7b1ea7fdece7c6f4d3aa43.

- F:\OpenLeague\docs\reference_air_sources\review\mod__win__ClientWindow_dat\scripts\com\riotgames\platform\gameclient\init\WindowGlue.as:114 — restoreWindow ; SHA-256 c4b8e82d69eb2ee170b1ad78751197f48127421e224b09b5b47179e072133b03.

- F:\OpenLeague\docs\reference_air_sources\review\mod__win__ClientWindow_dat\scripts\com\riotgames\platform\gameclient\init\WindowGlue.as:119 — handleMaximizeEvent ; SHA-256 c4b8e82d69eb2ee170b1ad78751197f48127421e224b09b5b47179e072133b03.

- F:\OpenLeague\docs\reference_air_sources\review\mod__win__ClientWindow_dat\scripts\com\riotgames\platform\gameclient\init\WindowGlue.as:128 — windowInit ; SHA-256 c4b8e82d69eb2ee170b1ad78751197f48127421e224b09b5b47179e072133b03.

- F:\OpenLeague\docs\reference_air_sources\review\mod__win__ClientWindow_dat\scripts\BaseShell.as:399 — restore signal registered ; SHA-256 6f12e267b1dd834fe81587511089e17953df9fb30a7b1ea7fdece7c6f4d3aa43.

- F:\OpenLeague\docs\reference_air_sources\review\mod__win__ClientWindow_dat\scripts\BaseShell.as:453 — Shell RESTORE listener ; SHA-256 6f12e267b1dd834fe81587511089e17953df9fb30a7b1ea7fdece7c6f4d3aa43.

Les quatre modules DAT et les sorties décompilées existantes sont vérifiés lorsqu’encore présents, sans nouvelle exportation. Entrées absentes éventuelles restent null dans le reçu ; elles ne sont pas déclarées revérifiées. Pont jeu→Maestro→AIR et ordre réel natif non qualifiés.

- mod/man/mod_man.dat ; SHA-256 114545665ba4c86273f2f49320f55ccdb3ffbb4938e6e45f19cd2ce0c9af0670 ; décompilation antérieure code 0 ; entrée physique présente : True.

- mod/win/ClientWindow.dat ; SHA-256 3b35a3cf373bedd58c676de4ca18632ba797894362268b46d31e5892cc933946 ; décompilation antérieure code 0 ; entrée physique présente : True.

- lib/ClientLibCommon.dat ; SHA-256 f5915bfc68556608cb6aba924b9773862c09dd9e52414dc488aa01621efee638 ; décompilation antérieure code 0 ; entrée physique présente : True.

- lib/ClientLibGame.dat ; SHA-256 72ec60851e9ab4570d0d02587327c65fab45e9f932beb52950accd9b98dd26f9 ; décompilation antérieure code 0 ; entrée physique présente : True.

## R3 — Consommateurs actuels

1 168 fichiers du corpus Rust/client/serveur/launcher et JS/HTML de premier niveau restent identiques. Le produit observé est launcher/, distinct de desktop/ et tools/project-plan/ gelés. session_departure.return_button exige résultat de même session, appartenance et clic armé/relâché ; AppExit sécurisé erroné préserve la réservation. session_connection.depart transmet le Leave courant une seule fois lorsque applicable.

Run.observe attend un exit réellement observé ; sortie normale demande drain par fermeture stdin possédée ; crash sécurisé conserve son serveur et clé. can_resume exige serveur possédé observé live et ancien client échoué ; can_abandon exige client absent/reaped. Échec spawn conserve ancien propriétaire ; nouveau client adopté avant bootstrap. JoinedRun possède seulement son client : server_owned=false, can_abandon=false, aucun repli nouveau Join. Fermeture du launcher joined refusée tant que le client est vivant ou non observé.

Sessions conserve ses données en mémoire ; pas de reprise persistante qualifiée après nouveau launcher. Le serveur ne sort qu’après drain, zéro client et sauvegarde du résultat si nécessaire ; les pairs externes ne sont pas tués. Poll processus local 250ms ; app.js actualise à 500ms, consomme can_* et sépare erreur actuelle/historique, launchPending et statusSerial empêchent les déverrouillages anciens. IPC rejeté désactive les actions ; invoke jamais résolu reste une limite.

Recherche bornée reproductible : \bset_focus\b|\bunminimize\b|\.show\s*\(|\.hide\s*\(|\brestore\b|\bfocus\s*\( dans 9 fichiers Rust launcher + app.js ; zéro correspondance. Aucun appel explicite local de restauration/focus identifié ; ce constat ne démontre pas un échec Windows, qui peut rendre spontanément le premier plan. Le cas launcher réduit/masqué reste à qualifier.

- F:\OpenLeague\crates\client\src\session_departure.rs:1 — client normal/error departure and visible return ; SHA-256 6cc8e1889fec2d6d2af8ae5f334126410ed5af2ef48b32f005c419617a3fdfe9.

- F:\OpenLeague\crates\client\src\session_connection.rs:280 — actual transport departure ; SHA-256 fdd81b790bca52dd4e20ca5d34e81d78136f3958ab7028f5ca193d078fb9acd1.

- F:\OpenLeague\launcher\src-tauri\src\main.rs:1 — actual Tauri IPC and close wiring ; SHA-256 d132e610f9810e1b2bd9d35edd15ccb12d41f6fa8f66a8c59b232f5e6a5e1074.

- F:\OpenLeague\launcher\src-tauri\src\sessions.rs:1 — actual owned child observation recovery and drain ; SHA-256 54bc7a2a66296cdf2cededcca19d1846287c5108974efda2a0151b17503da7f6.

- F:\OpenLeague\launcher\src-tauri\src\sessions_joined.rs:1 — actual joined child authority and recovery ; SHA-256 b7c44064076cab4a4ec3274e07a6fe28fe5f33477ac088a4eb82f24d2a89b60c.

- F:\OpenLeague\launcher\src-tauri\src\sessions_output.rs:300 — actual logged child observation ; SHA-256 771407092830a4e780427b3dc89bc63e4b699eef06c5aee6aa00dd29bb8de011.

- F:\OpenLeague\launcher\web\app.js:1 — current status/action consumer ; SHA-256 f4f58340d72d2bedbf94b88a847a537c2ea7d76594f053d6a5dc4eba1cf64ad6.

- F:\OpenLeague\crates\server\src\owned_session.rs:1 — server ownership EOF and completion gate ; SHA-256 f8166aac8cd04e02fd35d981f859883e18e462f00a066e683efb12ed29304415.

- F:\OpenLeague\crates\server\src\main.rs:205 — server persist/retry and stop consumer ; SHA-256 befc3f71ac9959061e18c5c63d8912887d7be2485ef05a27253b1ac6aef97512.

## R4 — Attendu, observé et vérifications

36 tests Rust ciblés déjà réussis sont réutilisés : 3 session_departure, 11 joined, 7 recovery, 8 status, 6 ownership/supervisor et 1 vrai enfant à sortie/logs. Un fixture ignored est explicitement exclu. Onze fichiers sources ciblés correspondent exactement au manifeste du run avancé. Ce rapprochement lève la limite de source Rust différente du reçu ancien pour ces fichiers seulement ; il ne qualifie pas le graphe entier ni un exécutable GUI actuel.

Tests client_tests ; journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log ; code0 terminal ; binaire enregistré {'path': 'E:\\OpenLeague\\target\\debug\\deps\\openleague_client-170289a4dedad9dd.exe', 'sha256': 'e2b2227752fb2e4db34a4602284dc6ff7359c393914619d0b502edcefe9aaddd', 'bytes': 350254080}.

- session_departure::tests::return_requires_visible_results_and_armed_release_inside_button : attendu ok, observé ok (hérité, non rejoué).

- session_departure::tests::error_exit_preserves_secure_reservation_but_retains_legacy_departure : attendu ok, observé ok (hérité, non rejoué).

- session_departure::tests::exit_sends_current_identity_once_and_checks_overflow : attendu ok, observé ok (hérité, non rejoué).

Tests launcher_tests ; journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\launcher_tests.log ; code0 terminal ; binaire enregistré {'path': 'E:\\OpenLeague\\launcher\\src-tauri\\target\\debug\\deps\\openleague_launcher-fe1ba6052869eb77.exe', 'sha256': '2a7736bff4cdcdbf5cc7b439c2fa5852255eafc854de39827fa4ad84475c4025', 'bytes': 2131968}.

- sessions::joined::tests::joined_observation_error_keeps_handle_blocks_close_and_prevents_duplicate_spawn : attendu ok, observé ok (hérité, non rejoué).

- sessions::joined::tests::joined_initial_bootstrap_error_stays_visible_until_success_not_live_observation : attendu ok, observé ok (hérité, non rejoué).

- sessions::joined::tests::joined_launcher_release_retains_live_or_unobserved_child_until_exit : attendu ok, observé ok (hérité, non rejoué).

- sessions::joined::tests::joined_normal_exit_retires_only_client_without_server_authority : attendu ok, observé ok (hérité, non rejoué).

- sessions::joined::tests::joined_live_close_notice_is_public_and_does_not_discard_client : attendu ok, observé ok (hérité, non rejoué).

- sessions::joined::tests::joined_resume_spawn_failure_preserves_old_exit_and_capability : attendu ok, observé ok (hérité, non rejoué).

- sessions::joined::tests::joined_private_command_targets_only_client_without_secret_arguments : attendu ok, observé ok (hérité, non rejoué).

- sessions::joined::tests::joined_supervisor_interruption_remains_current_after_recovery : attendu ok, observé ok (hérité, non rejoué).

- sessions::joined::tests::joined_crash_keeps_private_identity_and_warns_about_launcher_closure : attendu ok, observé ok (hérité, non rejoué).

- sessions::joined::tests::joined_successful_recovery_clears_current_error_only_then_normal_exit_retires : attendu ok, observé ok (hérité, non rejoué).

- sessions::joined::tests::joined_resume_bootstrap_failure_adopts_replacement_before_failure : attendu ok, observé ok (hérité, non rejoué).

- sessions::recovery_tests::bootstrap_writer_is_dropped_even_on_partial_failure_and_error_has_no_payload : attendu ok, observé ok (hérité, non rejoué).

- sessions::recovery_tests::dead_server_never_allows_resume_into_an_external_or_replacement_server : attendu ok, observé ok (hérité, non rejoué).

- sessions::recovery_tests::failed_observation_retains_live_client_and_never_authorizes_a_second_process : attendu ok, observé ok (hérité, non rejoué).

- sessions::recovery_tests::failed_client_keeps_only_its_owned_server_and_credential_until_explicit_abandon : attendu ok, observé ok (hérité, non rejoué).

- sessions::recovery_tests::normal_close_keeps_existing_drain_contract_and_does_not_offer_resume : attendu ok, observé ok (hérité, non rejoué).

- sessions::recovery_tests::server_observation_error_blocks_restart_until_owned_live_child_is_observed : attendu ok, observé ok (hérité, non rejoué).

- sessions::recovery_tests::private_pipe_changes_only_recovery_mode_and_never_appears_in_argv_or_environment : attendu ok, observé ok (hérité, non rejoué).

- sessions::status_tests::early_normal_server_exit_remains_current_until_live_client_retires : attendu ok, observé ok (hérité, non rejoué).

- sessions::status_tests::failed_server_exit_is_not_hidden_by_a_successful_client_bootstrap : attendu ok, observé ok (hérité, non rejoué).

- sessions::status_tests::identical_observation_fault_becomes_current_again_after_successful_retry : attendu ok, observé ok (hérité, non rejoué).

- sessions::status_tests::launch_error_requires_successful_bootstrap_not_just_a_live_process : attendu ok, observé ok (hérité, non rejoué).

- sessions::status_tests::repeated_exit_code_on_replacement_is_current_even_with_deduplicated_history : attendu ok, observé ok (hérité, non rejoué).

- sessions::status_tests::successful_observation_clears_current_faults_only_and_keeps_both_owners : attendu ok, observé ok (hérité, non rejoué).

- sessions::status_tests::resumed_client_and_normal_retirement_do_not_repeat_historical_crash : attendu ok, observé ok (hérité, non rejoué).

- sessions::status_tests::supervisor_interruption_remains_current_after_bootstrap_and_observation : attendu ok, observé ok (hérité, non rejoué).

- sessions::tests::early_server_exit_keeps_live_client_and_reports_error : attendu ok, observé ok (hérité, non rejoué).

- sessions::tests::failed_client_spawn_drains_server_and_preserves_primary_error : attendu ok, observé ok (hérité, non rejoué).

- sessions::tests::observation_error_retains_owner_and_history_until_retry_retires_it : attendu ok, observé ok (hérité, non rejoué).

- sessions::tests::server_observation_failure_never_releases_pending_owner : attendu ok, observé ok (hérité, non rejoué).

- sessions::tests::session_waits_for_server_after_client_and_closes_only_one_pipe : attendu ok, observé ok (hérité, non rejoué).

- sessions::tests::real_owned_server_eof_leaves_other_child_untouched : attendu ok, observé ok (hérité, non rejoué).

- sessions::output::tests::ordinary_child_flood_keeps_private_stdin_exit_and_new_attempt_logs_distinct : attendu ok, observé ok (hérité, non rejoué).

40 contrôles JavaScript hérités : recovery12, status11, join17 ; app.js actuel identique. DOM/Tauri/statut/erreurs injectés ; aucun enfant/fenêtre réel dans ces tests. Pour js_join, separate_receipt vaut null : résultat inline dans la qualification, aucun reçu distinct inventé.

Parcours GUI normal conservé du 11 octobre : vrai launcher, un Garen inactif, défaite autoritaire ordinaire, résultats, retour, seconde partie et fermeture native ; zéro processus final. Les observations de retour et captures sont vérifiées avec identités historiques. Ancien bouton partiellement couvert conservé, disposition ultérieure dans audit 08 ; pas acceptation graphique actuelle.

Parcours GUI crash conservé : run_002 v3 réussi, deux terminaisons explicites code71 (pas fermetures normales), reprise même identité sous pause, commande GUI puis abandon/drain. Serveur0, clients71/71, zéro handle/lecteur/pipe propre résiduel. Trois tentatives antérieures échouées restent référencées ; aucune sélection silencieuse effaçant leurs limites. Un GUI et pairs auxiliaires ; pas six clients graphiques, pas fidélité réseau native.

- Binaire historique normal/client: E:\OpenLeague\target\debug\openleague-client.exe ; SHA-256 50279e5289a9920539dc47033eaa75b305312566281b9d695add2daf908d7a6d ; non réexécuté et identité historique conservée.

- Binaire historique normal/server: E:\OpenLeague\target\debug\openleague-server.exe ; SHA-256 2ec3fa52b2337de1aca1ccdef5d1454b49546f652a4246d6bc41f01cf5279040 ; non réexécuté et identité historique conservée.

- Binaire historique normal/launcher: E:\OpenLeague\launcher\src-tauri\target\debug\openleague-launcher.exe ; SHA-256 cee4f019b5a0815dbb694a9d55e9bddd020c2c5715a5195ce8e7d17fe9ad9945 ; non réexécuté et identité historique conservée.

- Binaire historique crash/client: E:\OpenLeague\target\debug\openleague-client.exe ; SHA-256 a1521e1a2513757c03bda5b21165618a70a0797e9b1c80faeebf4d6b26396006 ; non réexécuté et identité historique conservée.

- Binaire historique crash/server: E:\OpenLeague\target\debug\openleague-server.exe ; SHA-256 70efc8743ca99b53ed44ed9cdc0c0801a6f5f5fd96385f6521c2d4c724e1027f ; non réexécuté et identité historique conservée.

- Binaire historique crash/launcher: E:\OpenLeague\launcher\src-tauri\target\debug\openleague-launcher.exe ; SHA-256 e95de30522f076726b3753fdc9cc9297003ff735228929b294e1c4a7e5f7b9c3 ; non réexécuté et identité historique conservée.

Trois captures réellement relues maintenant avec view_image :

- E:\mapslol3v3\reconnect_launcher_runtime_v3\run_002\07_resume_offered.png ; SHA-256 0b679d68d19ae00cc177e165614851c8b38b19f2d3d77af05e2137ae4ec51790 ; Launcher Garen; Reprendre la partie and Abandonner la partie conservée; client interrompu, code Some(71). A screenshot shows wording, not enabled-state semantics or current F binaries.

- E:\mapslol3v3\reconnect_launcher_runtime_v3\run_002\14_idle_after_abandon.png ; SHA-256 8c9cb54968f788dc45e8ee176fb5f16476db8c37310cfdee609409e81b92255a ; Session terminée, une nouvelle partie peut être ouverte; code Some(71) remains on same line. Do not call this a clean error-free status; last failed client exit is still recorded.

- E:\mapslol3v3\session_lifecycle_game\launcher_after_second_session.png ; SHA-256 4e93d076e6a5a69aa1ca15cc87eb605187a4e00951882d975b09ed06b38a27c6 ; Launcher visible, Garen, Ouvrir la partie locale; Session terminée. Une nouvelle partie peut être ouverte. Historical visible normal return; not minimized/hidden/forced-launcher-loss qualification.

Après abandon, la capture garde Some(71) du dernier client échoué ; ne pas appeler cela une erreur historique obsolète après remplacement réussi. Le retour normal de seconde partie montre le message sans erreur.

### RET-01 — Résultats puis retour normal

Attendu : Bouton visible pour le résultat de sa propre session; appui puis relâchement dedans, une sortie et Leave; nouveau lancement après retraite des propriétaires.

Observé : session_departure trois tests exacts; ancien vrai parcours premier résultat → launcher → seconde partie → fermeture native, zéro processus final.

Preuves : session_departure.rs, 36 Rust tests, normal_gui_session. Limite : Ancien binaire et ancien chevauchement du bouton conservés; nouvelle disposition traitée dans audit 08. Pas acceptation graphique actuelle.

### RET-02 — Fermeture normale host

Attendu : Observer le code de sortie réel puis demander drain de son serveur, sans tuer un pair externe.

Observé : Run.observe appelle drain à la sortie réussie; EOF est unique; can_stop attend zéro client et résultat sauvegardé. Tests normal_close et real_owned_server_eof retenus.

Preuves : sessions.rs, owned_session.rs, normal GUI. Limite : La boucle attend les pairs/sauvegarde; délai 250ms/500ms est un intervalle local, pas un SLA ni une règle Riot.

### RET-03 — Crash sécurisé host

Attendu : Ne pas envoyer Leave sur AppExit erreur; conserver son serveur/clé et permettre reprise uniquement après sortie échouée observée.

Observé : Tests d’erreur sécurisée, observation, serveur mort et reprise exacts; ancien vrai crash71, reprise sous pause puis abandon et serveur0.

Preuves : session_departure.rs, sessions.rs, crash receipt. Limite : Terminaisons71 sont deux fautes explicites; pas preuve de fermeture normale ni tous crashs matériels/Windows.

### RET-04 — Sortie normale/crash joined

Attendu : Aucune autorité serveur; sortie normale libère seulement le client; crash conserve la reprise privée; pas de Join de remplacement.

Observé : JoinedRun server_owned=false, can_abandon=false, observed failed exit; onze tests exacts dont perte bootstrap, échec spawn, blocage fermeture et reprise.

Preuves : sessions_joined.rs, joined tests. Limite : Pas de capture actuelle de ce parcours joined; fermeture forcée du launcher et réservation serveur séparées.

### RET-05 — Observation de processus indisponible

Attendu : Conserver propriétaire; aucun double lancement avant observation valable.

Observé : Owned.observe garde le handle/erreur actuelle; tests failed_observation, observation_error et joined_observation_error passent dans preuves conservées.

Preuves : sessions.rs, status_tests, joined tests. Limite : Observations simulées pour ces erreurs; pas nouvelle injection OS.

### RET-06 — Échec spawn ou bootstrap de reprise

Attendu : Garder ancien enfant jusqu’au spawn; adopter immédiatement nouveau propriétaire avant bootstrap; erreur visible et pas de seconde partie.

Observé : restart_with et Sessions.resume; tests échec spawn/bootstrap et suite JS contrôlée.

Preuves : sessions.rs, sessions_joined.rs, 40 JS controls. Limite : Harness JS injecte DOM, Tauri, statut, erreurs; ne prouve pas IPC réel courant.

### RET-07 — Statut IPC défaillant/concurrent

Attendu : Toutes actions fermées sur erreur; réponse ancienne ne déverrouille pas une action en cours.

Observé : launchPending, statusSerial, disableActions et message indisponible; 40 contrôles JS sur app.js identique.

Preuves : app.js, 40 JS controls. Limite : Invoke qui ne se résout jamais: statusPending peut rester vrai, absence de timeout/budget; correction existante à reprendre.

### RET-08 — Erreur courante et historique

Attendu : Reprise réussie ne répète pas une ancienne sortie; même code sur nouvel enfant reste courant; préserver historique.

Observé : Huit tests status exacts et onze JS; capture après abandon garde Some(71) pour le dernier client échoué, capture fermeture normale affiche session terminée sans erreur.

Preuves : session_status_tests.rs, js_status, 3 reviewed images. Limite : Ne pas inventer une correction de message stale à partir du seul code71 après abandon.

### RET-09 — Fenêtre réduite/masquée et focus

Attendu : Identifier contrat AIR RESTORE puis qualifier politique locale de visibilité/restauration après sortie, sans affirmation sur le focus Windows non observé.

Observé : AIR ViewMediatorImpl → ShellEvent.RESTORE → WindowGlue signal/restore → BaseShell visible/activate/orderToFront. Aucun appel explicite équivalent dans recherche Rust launcher + app.js.

Preuves : 14 native method fragments, window query. Limite : Fenêtre minimisée, tray, autre application au premier plan non testés; aucun échec OS déduit de la seule absence d’appel.

### RET-10 — Raison native de sortie et modes spéciaux

Attendu : Distinguer gameCompleted, crash/abandon, GAME_OVER/NO_GAME, lobby/reconnect, replay, tutoriel et spectateur.

Observé : Callbacks AIR et contrôleurs nommés identifiés; retour local classé par AppExit/exit code et propriétaire, contrat de gameplay local distinct.

Preuves : native callbacks, Run.status, JoinedRun.status. Limite : Pont original jeu/Maestro/AIR, ordonnancement réel et fidélité serveur non exécutés; ne pas assimiler Exit0 à gameCompleted natif.

### RET-11 — Launcher fermé/absent/recréé

Attendu : Délimiter vie du superviseur, handle possédé et conservation de clé; ne pas annoncer restauration persistante.

Observé : Sessions en mémoire; fermeture joined bloquée si enfant live/non observé; détachement observé maintient propriétaire jusqu’à sortie; côté host demande drain.

Preuves : main.rs, Sessions.new, JoinedRun, SYS-03.4-06, SYS-19.4-07. Limite : Kill OS forcé, crash launcher ou lancement client direct sans launcher: pas de parcours de restauration persistante qualifié.

### RET-12 — Réconciliation du lot écrans et états

Attendu : Couvrir chaque parent une seule fois, en gardant documentaire distinct d’implémentation.

Observé : Huit parents précédents contrôlés avec leur main/report/reader; présent parent est le neuvième, clôture seulement après relecture indépendante.

Preuves : package coverage. Limite : D20-SYS-20-3 et jeu complet restent ouverts; aucun pourcentage du jeu ni mise à jour de case.

Contrôles de ce lot : 321 vérifications documentaires producteur réussies (identités, code, assertions de portée, preuves et conservation). Ce nombre ne compte pas comme nouveaux tests fonctionnels. Relecture indépendante à exécuter après ce rapport. Non exécutés maintenant : Cargo, JavaScript, jeux, AIR, Maestro, GPU, sockets, crash injecté, parcours GUI, installation, migration, restart ou base.

## R5 — Écarts ouverts et conditions de reprise

Restent ouverts : restauration visibilité/focus en conditions Windows, route exacte par raison/mode, GUI actuelle host et joined, IPC sans réponse, durée de vie après disparition du launcher et pont historique Maestro. L’inconnue OLU-cbd04839-332b-51d0-a885-00164122c607 demeure open dans le registre gelé. Les éléments nécessaires sont nommés dans les six corrections ci-dessous ; aucune recherche large ne doit être répétée sans ces nouvelles entrées.

La limite de version de LOAD-ERROR-CURRENT-BACKEND-VERIFY-01 est levée pour les onze sources ciblées grâce au run avancé. Le solde exécutable/dépendances/GUI reste ouvert dans les fiches host/joined ; cette évolution documentaire ne réécrit pas l’ancien audit et ne déclare aucune correction produit réalisée.

## R6 — Corrections atomiques, réutilisées ou proposées

Aucun écart fonctionnel corrigé. Les trois fiches LOAD-ERROR-* sont réutilisées, sans doublon ; trois objectifs nouveaux proposés pour fenêtres, raisons et durée de vie. Statut proposed_not_applied ou existing_correction_reused_not_applied. Les tâches du plan restent inchangées.

### RETURN-WINDOW-RESTORE-01

Objectif : Qualifier puis assurer la restauration visible du launcher à la sortie du client.

Tâches existantes : SYS-18.5-09, SYS-23.5-02. Sources : ViewMediatorImpl.maximizeClient, BaseShell.handleRestoreFromSystrayEvent, WindowGlue.handleMaximizeEvent, launcher/src-tauri/src/main.rs, launcher/src-tauri/src/sessions.rs.

Prérequis/dépendances : Contrat natif statique présent; ordre réel Maestro reste non qualifié..

Travail : Définir déclenchement normal/crash et politique de premier plan à partir du contrat AIR, limites Windows explicites. ; Tester launcher visible, réduit, masqué/tray si supporté et autre application active; conserver les actions de reprise, sans nouveau processus.

Critères de fin : Captures/états de fenêtre et horodatages de sortie pour chaque cas applicable, version et binaires identifiés. ; Aucun double lancement; refus ou restriction Windows affiché/documenté; aucun emprunt d’autorité au serveur joined.

Entrée/condition de reprise : Autorisation distincte de correction produit et qualification UI; binaires/source actuels et cas réduit/masqué reproductible.

État : proposed_not_applied.

### RETURN-REASON-ROUTE-01

Objectif : Qualifier les routes de retour par raison de sortie, sans réduire la sémantique native au code de processus.

Tâches existantes : SYS-18.5-09, SYS-23.3-02. Sources : ApplicationController.onGameCompleted, ApplicationController.onGameCrashedOrAbandoned, MasterGameController.gameCompleted, InGameController.handleGameEarlyTermination, sessions.rs, sessions_joined.rs.

Prérequis/dépendances : D20-SYS-20-3 ; Audit SYS-17.3-08 résultats.

Travail : Tracer fin normale, abandon, crash avant/après GAME_OVER et reprise; isoler spectateur/replay/tutoriel selon périmètre applicable. ; Pour fidélité historique, relier les notifications jeu→Maestro→AIR à ces callbacks ou conserver explicitement chaque branche non retrouvée.

Critères de fin : Matrice raison/état/route, observations nominales et refus par branche supportée, source historique ou politique locale marquée. ; Aucune perte de clé ni nouvelle session lors d’une reprise; exceptions natives gardées distinctes.

Entrée/condition de reprise : Nouvelle trace ou entrée nommée du pont Maestro pour qualification historique; pour parcours local, exécution autorisée et binaires identifiés.

État : proposed_not_applied.

### LOAD-ERROR-OWNED-RETURN-01

Objectif : Reprendre la fiche existante pour qualifier le parcours host de retour sur versions courantes.

Tâches existantes : SYS-23.3-04, SYS-23.5-02. Sources : AUD-17.3-03-LOADING-ERROR-RETURN-01, sessions.rs, session_departure.rs, owned_session.rs.

Prérequis/dépendances : D20-SYS-20-3 ; RETURN-WINDOW-RESTORE-01.

Travail : Réutiliser 36 tests ciblés et ancien vrai parcours; ne pas les rejouer sans changement. ; Compléter seulement les cas actuels non couverts: fermeture réduite/masquée, erreur critique, attente des pairs et sauvegarde.

Critères de fin : Un parcours GUI courant normal et crash/reprise/abandon avec conservation identité, erreurs pertinentes et zéro ressource propre résiduelle. ; Pairs externes non arrêtés et propriétaire serveur jamais remplacé.

Entrée/condition de reprise : Autorisation de qualification produit, build actuel identifié et cas manquant discriminant; la limite ancienne de sources Rust différentes est levée pour les 11 fichiers ciblés, pas pour tout le binaire.

État : existing_correction_reused_not_applied.

### LOAD-ERROR-JOINED-RETURN-01

Objectif : Reprendre la fiche existante pour qualifier le retour joined sans autorité serveur.

Tâches existantes : SYS-23.3-04, SYS-19.4-07. Sources : AUD-17.3-03-LOADING-ERROR-RETURN-01, sessions_joined.rs, main.rs.

Prérequis/dépendances : D20-SYS-20-3 ; RETURN-WINDOW-RESTORE-01.

Travail : Réutiliser les onze tests joined exacts; compléter observation GUI réelle du retour normal et de la reprise après crash. ; Vérifier fermeture normale et demandes de fermeture launcher pendant enfant live, observation inconnue et après échec.

Critères de fin : Retour visible et reprise même identité, aucun abandon host ni seconde admission, avertissement de perte de reprise exact. ; Conservation du serveur hôte et absence de processus abandonné démontrées dans le périmètre observé.

Entrée/condition de reprise : Deux launchers locaux autorisés et identifiés, hôte indépendant; ne pas répéter recherche sans nouveau cas ou source.

État : existing_correction_reused_not_applied.

### LOAD-ERROR-STATUS-UNAVAILABLE-01

Objectif : Reprendre la fiche existante pour rendre explicite un statut IPC sans réponse.

Tâches existantes : SYS-18.5-09. Sources : AUD-17.3-03-LOADING-ERROR-RETURN-01, launcher/web/app.js, main.rs.

Prérequis/dépendances : Contrat IPC actuel identifié.

Travail : Qualifier rejet, réponse ancienne, action en cours et invoke jamais résolu. ; Définir budget/retour visible sans libérer de propriétaire ni autoriser un autre client à tort.

Critères de fin : Erreur ou attente bornée visible; chaque action dépend d’un état observé actuel; aucun double processus. ; Contrôles JS ciblés et un cas IPC réel qualifient le comportement ajouté.

Entrée/condition de reprise : Autorisation produit et anomalie sans réponse reproductible; les 40 anciens contrôles restent réutilisables pour leurs cas.

État : existing_correction_reused_not_applied.

### RETURN-LAUNCHER-LIFETIME-01

Objectif : Qualifier la frontière de reprise quand le launcher disparaît ou est absent.

Tâches existantes : SYS-03.4-06, SYS-19.4-07, SYS-23.5-02. Sources : Sessions.new, JoinedRun.launcher_detached, main.rs, owned_session.rs.

Prérequis/dépendances : D20-SYS-20-3 ; Autorité host/joined conservée.

Travail : Distinguer fermeture demandée, crash/kill forcé du launcher, client direct et nouveau processus launcher. ; Définir diagnostic/limite de réservation et reprise; ne pas annoncer une persistance de clés inexistante.

Critères de fin : Chaque cas montre propriétaire, serveur, client, message et ressources finales; aucune recherche par PID d’un processus non possédé. ; Reprise supportée démontrée ou refus/limite explicite conservé; aucune clé privée exposée dans UI/arguments/journaux.

Entrée/condition de reprise : Scénario produit autorisé et environnement isolé avec handles possédés; reprise historique complète exige trace originale nouvelle.

État : proposed_not_applied.

Tâches réellement inspectées :

- SYS-03.4-06 / OLF-2ba712c0-fb2f-5020-9489-9d77a2681334 — Créer un diagnostic des sessions et processus orphelins ; état conservé a_faire.

- SYS-08.4-05 / OLF-5a59aa84-1bf7-592f-92bc-582012d9f8eb — Conserver les pages sélectionnées après retour au launcher ; état conservé a_faire.

- SYS-18.5-09 / OLF-1d488ac7-2749-5775-9105-ede9922c1e0d — Afficher un crash et permettre le retour au launcher ; état conservé a_faire.

- SYS-19.4-07 / OLF-5931681d-1d98-5540-b988-a55a35659974 — Nettoyer les sessions orphelines après crash de service ; état conservé a_faire.

- SYS-23.3-02 / OLF-2c834c6e-1739-5fe6-aa5b-6d213cf0bf86 — Jouer l’abandon et son retour au launcher ; état conservé a_faire.

- SYS-23.3-04 / OLF-be33e195-7ed9-5781-9c0b-e6a30f211557 — Jouer un crash de client et la reprise d’une partie active ; état conservé a_faire.

- SYS-23.5-02 / OLF-2730ea63-1c4d-5f21-a3b2-524b8aa2e482 — Répéter les cycles launcher, chargement, partie et retour ; état conservé a_faire.

## R7 — Livraison, cohérence et conservation

Nouveaux fichiers uniquement : audit-unit.json, verify_launcher_return.py (tentative1 échouée conservée), producer-attempt-1-failed.json, verify_launcher_return_v2.py, launcher-return-proof.json, ce rapport, verify_delivery.py et delivery-readback.json dans le dossier de ce lot. Le producteur ne préclôture pas : audit_scope_closed=false avant relecture indépendante. Les fichiers de préparation locaux ne sont pas du code produit.

Première tentative producteur : arrêt KeyError:record pendant la réconciliation des formats anciens, aucun reçu principal ni rapport créé ; script et échec conservés. V2 lit les deux schémas historiques sans modifier les acquis.

19 fichiers logiciels gelés et six documents de contexte/méthode, cinq registres normatifs et état Git suivi sont vérifiés inchangés. Aucune base ouverte, application de suivi lancée, migration/installation ou modification de goal/critères/registre. Les anciens reçus et échecs restent intacts.

Réconciliation D17-SYS-17-3 : huit audits parents précédents avec leurs sept rubriques et fichiers revérifiés ; présent parent neuvième, clôture différée au lecteur indépendant. Règle : un parent documentaire parmi les neuf task_ids du lot, sans addition des fragments ou tests. Ce n’est pas un pourcentage du jeu ; aucune clôture fonctionnelle du lot D17 ni du goal global.

- SYS-17.3-01 — AUD-17.3-01-LOADING-PRESENTATION-01 ; sept rubriques pass, audit documentaire clos ; fonctionnalité non complète ; lecteur F:\OpenLeague-work\audit-units\AUD-17.3-01-LOADING-PRESENTATION-01\delivery-readback.json.

- SYS-17.3-02 — AUD-17.3-02-PLAYER-LOADING-PROGRESS-01 ; sept rubriques pass, audit documentaire clos ; fonctionnalité non complète ; lecteur F:\OpenLeague-work\audit-units\AUD-17.3-02-PLAYER-LOADING-PROGRESS-01\delivery-readback.json.

- SYS-17.3-03 — AUD-17.3-03-LOADING-ERROR-RETURN-01 ; sept rubriques pass, audit documentaire clos ; fonctionnalité non complète ; lecteur F:\OpenLeague-work\audit-units\AUD-17.3-03-LOADING-ERROR-RETURN-01\delivery-readback.json.

- SYS-17.3-04 — AUD-17.3-04-DEATH-SCREEN-01 ; sept rubriques pass, audit documentaire clos ; fonctionnalité non complète ; lecteur F:\OpenLeague-work\audit-units\AUD-17.3-04-DEATH-SCREEN-01\delivery-readback.json.

- SYS-17.3-05 — AUD-17.3-05-PAUSE-MODE-PRESENTATION-01 ; sept rubriques pass, audit documentaire clos ; fonctionnalité non complète ; lecteur F:\OpenLeague-work\audit-units\AUD-17.3-05-PAUSE-MODE-PRESENTATION-01\delivery-readback.json.

- SYS-17.3-06 — AUD-17.3-06-TEAM-VOTE-01 ; sept rubriques pass, audit documentaire clos ; fonctionnalité non complète ; lecteur F:\OpenLeague-work\audit-units\AUD-17.3-06-TEAM-VOTE-01\delivery-readback.json.

- SYS-17.3-07 — AUD-17.3-07-CONNECTION-STATUS-01 ; sept rubriques pass, audit documentaire clos ; fonctionnalité non complète ; lecteur F:\OpenLeague-work\audit-units\AUD-17.3-07-CONNECTION-STATUS-01\delivery-readback.json.

- SYS-17.3-08 — AUD-17.3-08-MATCH-RESULTS-01 ; sept rubriques pass, audit documentaire clos ; fonctionnalité non complète ; lecteur F:\OpenLeague-work\audit-units\AUD-17.3-08-MATCH-RESULTS-01\delivery-readback.json.

Erratum du vote V6-fin conservé : F:\OpenLeague-work\audit-units\AUD-17.3-07-CONNECTION-STATUS-01\team-vote-task-reference-erratum.json SHA-256 4e49f8861ea5892b4030c69c06f3b7f40e2d8c0d9839033287ba86679bec665d ; dépendance résultats SYS-17.3-08, sans altérer le reçu 06.

Preuve principale : F:\OpenLeague-work\audit-units\AUD-17.3-09-LAUNCHER-RETURN-01\launcher-return-proof.json SHA-256 381740d5ed8c4276f3f2d76dc3018c4f7ca8a9f9cbce9b8e126361b8b6b2f594. Relecture attendue : F:\OpenLeague-work\audit-units\AUD-17.3-09-LAUNCHER-RETURN-01\delivery-readback.json.
