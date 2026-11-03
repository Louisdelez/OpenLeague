# AUD-17.4-06-CAMERA-COMMAND-PERSISTENCE-01 — persistance des commandes caméra

SYS-17.4-06 / OLF-610203c3-0359-5552-b384-9ae5b501a757 sous SYS-01.2-02. Audit documentaire clos seulement après relecture R1–R7; fonctionnalité partielle, jeu/goal global non terminés, acceptation humaine non donnée.

## R1 — Périmètre et prérequis

Objectif : Persister les commandes de caméra. État a_faire et implementation_complete=false/acceptance_complete=false conservés; inconnue OLU-8bb2818d-7703-5c2c-a6b1-c1aca5998a57 open. D17-SYS-17-4 exige D09-SYS-09-4, toujours a_faire. Audit des bindings et de lecture/application/écriture/relecture, pas reconstruction de caméra-math. Aucun critère normatif modifié; lot précédent attaque-déplacement clos uniquement pour l’audit.

## R2 — Sources et contrats bornés

- native_defaults : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\defaults\Input.ini ; SHA-256 930f1499991e9c4973e81086a26c944b7330058970c4227a614b897eae09fec1

- supplied_deploy_override : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\input.ini ; SHA-256 aead4280d339159623dbe8f39784bde4b87a6b05afc6d95f2feccec7ba99073a

- user_configuration_not_historical_default : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\Config\input.ini ; SHA-256 fa16e719b04249006b3ab7c77f7810e728d3743faf82e86cb259b6cc96d0a531

- Game.cfg D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\defaults\Game.cfg ; SHA-256 02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e

- Game.cfg D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\Config\game.cfg ; SHA-256 64d34912ea5411b47d6da0de44da374dd0a9e396fe96dc2b1d87ca76d562110e

- Game.cfg F:\OpenLeague\data\4.20\configuration\defaults\Game.cfg ; SHA-256 02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e

Baseline locale identique à Game.cfg natif. Catégorie Options/CategoryEvents5 :13commandes; ReplayOptions/CategoryEvents1 :20déclarations; sept événements HUD/debug/cheat supplémentaires, union32. Dix evtSelectPlayer1..10 sont déclarés dans replay mais sans entrée dans les trois Input.ini nommés. Absence déclarative distincte de [<Unbound>], pas absence globale native ni touches1..0 présumées. Contextes ne prouvent ni activation/permissions ni callbacks.

- evtCameraSnap ; ordinary_category5,replay_category1 ; L381 [GameEvents] [Space] ; Space → local CameraFocus target

- evtSelectSelf ; ordinary_category5 ; L382 [GameEvents] [F1] ; not_identified_for_ordinary_input

- evtSelectAlly1 ; ordinary_category5 ; L383 [GameEvents] [F2] ; not_identified_for_ordinary_input

- evtSelectAlly2 ; ordinary_category5 ; L384 [GameEvents] [F3] ; not_identified_for_ordinary_input

- evtSelectAlly3 ; ordinary_category5 ; L385 [GameEvents] [F4] ; not_identified_for_ordinary_input

- evtSelectAlly4 ; ordinary_category5 ; L386 [GameEvents] [F5] ; not_identified_for_ordinary_input

- evtCameraLockToggle ; ordinary_category5,replay_category1 ; L380 [GameEvents] [y] ; KeyY → Setting.request/consume; current-process shared lock

- evtScrollUp ; ordinary_category5,replay_category1 ; L388 [GameEvents] [Up Arrow] ; ArrowUp → Controls.apply

- evtScrollDown ; ordinary_category5,replay_category1 ; L389 [GameEvents] [Down Arrow] ; ArrowDown → Controls.apply

- evtScrollLeft ; ordinary_category5,replay_category1 ; L390 [GameEvents] [Left Arrow] ; ArrowLeft → Controls.apply

- evtScrollRight ; ordinary_category5,replay_category1 ; L391 [GameEvents] [Right Arrow] ; ArrowRight → Controls.apply

- evtOnUIMouse4Pan ; ordinary_category5,replay_category1 ; L425 [GameEvents] [Button 3] ; not_identified_for_ordinary_input

- evtDragScrollLock ; ordinary_category5,replay_category1 ; L426 [GameEvents] [Ctrl] [Shift] [s] ; not_identified_for_ordinary_input

- evtEnableDirectedCamera ; replay_category1 ; L460 [GameEvents] [d] ; nonordinary_context_route_not_qualified

- evtDisableDirectedCamera ; replay_category1 ; L461 [GameEvents] [s] ; nonordinary_context_route_not_qualified

- evtSelectPlayer1 ; replay_category1 ; declared_without_entry_in_named_Input_configs ; nonordinary_context_route_not_qualified

- evtSelectPlayer2 ; replay_category1 ; declared_without_entry_in_named_Input_configs ; nonordinary_context_route_not_qualified

- evtSelectPlayer3 ; replay_category1 ; declared_without_entry_in_named_Input_configs ; nonordinary_context_route_not_qualified

- evtSelectPlayer4 ; replay_category1 ; declared_without_entry_in_named_Input_configs ; nonordinary_context_route_not_qualified

- evtSelectPlayer5 ; replay_category1 ; declared_without_entry_in_named_Input_configs ; nonordinary_context_route_not_qualified

- evtSelectPlayer6 ; replay_category1 ; declared_without_entry_in_named_Input_configs ; nonordinary_context_route_not_qualified

- evtSelectPlayer7 ; replay_category1 ; declared_without_entry_in_named_Input_configs ; nonordinary_context_route_not_qualified

- evtSelectPlayer8 ; replay_category1 ; declared_without_entry_in_named_Input_configs ; nonordinary_context_route_not_qualified

- evtSelectPlayer9 ; replay_category1 ; declared_without_entry_in_named_Input_configs ; nonordinary_context_route_not_qualified

- evtSelectPlayer10 ; replay_category1 ; declared_without_entry_in_named_Input_configs ; nonordinary_context_route_not_qualified

- evtShowCameraSliders ; additional_GameEvents ; L496 [GameEvents] [Shift][m] ; nonordinary_context_route_not_qualified

- evtOrbitCamera ; additional_HUDEvents ; L529 [HUDEvents] [Ctrl][Shift][Button 1] ; nonordinary_context_route_not_qualified

- evtResetCamera ; additional_HUDEvents ; L530 [HUDEvents] [Ctrl][Space] ; nonordinary_context_route_not_qualified

- evtToggleDirectedCameraDebug ; additional_HUDEvents ; L537 [HUDEvents] [Alt] [d] ; nonordinary_context_route_not_qualified

- evtCheatFPSCamera ; additional_CheatEvents ; L622 [CheatEvents] [Ctrl][F4], [Ctrl][Fn][F4] ; nonordinary_context_route_not_qualified

- evtCheatTopDownCamera ; additional_CheatEvents ; L626 [CheatEvents] [Ctrl][F5], [Ctrl][Fn][F5] ; nonordinary_context_route_not_qualified

- evtCheatAttachCamera ; additional_CheatEvents ; L641 [CheatEvents] [Alt][Ctrl][I] ; nonordinary_context_route_not_qualified

Champs Game.cfg contextuels : [General]SnapCameraOnRespawn=1, [HUD]MapScrollSpeed=0.5000, [HUD]MiddleMouseScrollSpeed=0.5000, [HUD]ScrollSmoothingEnabled=0, [HUD]ReplayMiddleMouseScrollSpeed=0.5000, [HUD]ReplayScrollSmoothingEnabled=1, [HUD]FlipCameraOnChaosSide=0, [HUD]LockCamera=0, [CameraSmoothing]CameraZoomEaseTime=0.2, [CameraSmoothing]CameraZoomMinSpeed=3.0. Leur présence n’impose pas de persister gestes, CameraFocus/zoom instantané, pid/session/révision ou lease. Aucun remap/applique complet déduit du parser. PE original SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862, non exécuté.

Trois helpers AIR hérités (set/save) relus :

- KeyBindingController.save F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\Keybinding\KeyBindingController.as:324 SHA-256 20c9ee99262de2d9238643788acb784e40f729d953fc977938cf6de5e80a97f7

- GameCfgStack.setValue F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibCommon_dat\scripts\com\riotgames\platform\common\utils\file\GameCfgStack.as:28 SHA-256 7c5918ff035828cc1da5cbd77661cdc1d36b103bdce221e3f88a55eb896e6868

- GameIniFile.save F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibCommon_dat\scripts\com\riotgames\platform\common\utils\file\GameIniFile.as:74 SHA-256 d88e5c163c42af16ba90ddd594c0a0d52287c33f0237ff5270fb92ea73e3bf40

Ils démontrent des helpers génériques, pas callback caméra ni writer Rust actuel. Ancienne provenance/version dans le parent binding épinglé, aucune exécution AIR/SQL ou validation de flag/frontend/provider effectif.

## R3 — Consommateurs réels

La lecture au démarrage existe : main load_using→Loaded.text (user avant baseline)→camera_lock.setup lit HUD/LockCamera et accepte strictement0/1. L’ancienne association « shared memory, persistance non identifiée » est précisée : le manque n’est pas tout le lecteur, mais le writeback des préférences/commandes et l’application de bindings reconfigurés. Le loader peut créer un répertoire et renommer une configuration; il n’est pas invoqué ici.

Setting.consume change locked/revision en mémoire; default_locked vient du setup. Nouveau owner/session/epoch remet locked=default_locked; restauration de lease est conditionnelle et préserve une modification humaine plus récente. Y, bouton HUD et minimap utilisent ce même consumer. Aucun writer identifié dans consume/drive/UI/minimap inspectés; mémoire, retour de focus ou restauration observateur ne prouvent pas sauvegarde interprocessus.

Ordinary Controls traite seulement Y, Espace et quatre flèches, vitesse locale150. Sept commandes ordinaires sans route qualifiée ont chacune une correction. F3 natif SelectAlly2 est actuellement diagnostic labels; CtrlShiftS DragScrollLock peut atteindre Action::Stop par KeyS sans garde Ctrl/Shift. Constats de flux source, pas tests clavier effectués. Zoom molette est transitoire et respecte wheel gate; pas un writer ni un remap.

- F:\OpenLeague\crates\client\src\main.rs:604–610 — normal startup actually loads settings ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620

- F:\OpenLeague\crates\client\src\main.rs:708–709 — ordinary camera and shared UI plugins wired ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620

- F:\OpenLeague\crates\client\src\main.rs:800–805 — actual Loaded resource insertion ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620

- F:\OpenLeague\crates\client\src\native_user_settings.rs:33–75 — real settings selection parser and migration risk ; SHA-256 f13aa64b4349d6bb250a888e147e2bec8f0422b98a4e61a3dd22c2837b6f7e1c

- F:\OpenLeague\crates\client\src\native_game_cfg_text.rs:51–72 — generic user-before-baseline reader ; SHA-256 54b4d9df1bc56d78a07eb51f0fe15128e1d702a2e19d1acf17d46f02d89857b1

- F:\OpenLeague\crates\client\src\camera_lock.rs:55–104 — shared memory setting and owner reset ; SHA-256 ffe68936534a47ff685f80d0b48fc068ed6cd8db8b0f648447a916d0d04bb6d6

- F:\OpenLeague\crates\client\src\camera_lock.rs:110–155 — accepted lock change and conditional lease restoration ; SHA-256 ffe68936534a47ff685f80d0b48fc068ed6cd8db8b0f648447a916d0d04bb6d6

- F:\OpenLeague\crates\client\src\camera_lock.rs:157–173 — startup typed LockCamera reader exists ; SHA-256 ffe68936534a47ff685f80d0b48fc068ed6cd8db8b0f648447a916d0d04bb6d6

- F:\OpenLeague\crates\client\src\ordinary_camera_input.rs:6–50 — six camera keys fixed locally ; SHA-256 b854c04e795203cd65ec98507a0a706f36eb3eeaeb1ab6a15da3b70fb940b0a9

- F:\OpenLeague\crates\client\src\ordinary_camera_input.rs:100–141 — ordinary Y focus and background follow consumer ; SHA-256 b854c04e795203cd65ec98507a0a706f36eb3eeaeb1ab6a15da3b70fb940b0a9

- F:\OpenLeague\crates\client\src\camera_lock_ui.rs:156–194 — UI uses same memory revision consumer ; SHA-256 d334ce52ec090da3f2a262c1ad36578d09ce4e489a2e0597e23a986733743f91

- F:\OpenLeague\crates\client\src\native_minimap_input.rs:98–108 — minimap unlock uses same setting ; SHA-256 cd1b0e19e3741ddd843282caeca2eff4c54a96482dbed9891680b51b45d087cc

- F:\OpenLeague\crates\client\src\main.rs:1503–1520 — wheel is transient local camera input ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620

- F:\OpenLeague\crates\client\src\main.rs:1545–1555 — F3 debug conflicts with native ally2 default ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620

- F:\OpenLeague\crates\client\src\main.rs:1450–1457 — CtrlShiftS camera binding may hit ordinary Stop source path ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620

Recherches bornées1168sources : paramètres MapScrollSpeed/MiddleMouseScrollSpeed/ScrollSmoothingEnabled/SnapCameraOnRespawn zéro hit; événements caméra trois hits seulement dans assertions tests. IO writeback zéro hit sur les quatre consumers, complété par inspection du flux; pas de call graph universel ni invocation du loader.

## R4 — Attendu, observé et vérifications

35tests composants réutilisés,12sources actuelles identiques au run retenu et baseline Game.cfg identique :9Setting,6UI,17ordinary input,3lecteur générique. Journaux terminaux code0 et retours finaux, anciennes lignes en cours conservées. Aucun test rejoué. Le test disque générique utilise EnvironmentQuality, pas une boucle LockCamera modifié→sauvegardé→nouveau processus.

- camera_lock::tests::background_lock_can_follow_but_unfocused_human_hotkey_and_ui_are_refused : attendu ok, observé ok, hérité non rejoué.

- camera_lock::tests::clean_observer_lease_restores_once_and_new_epoch_cannot_restore : attendu ok, observé ok, hérité non rejoué.

- camera_lock::tests::expected_revision_state_and_serial_refuse_stale_requests_without_change : attendu ok, observé ok, hérité non rejoué.

- camera_lock::tests::human_changes_and_human_noops_invalidate_observer_restoration : attendu ok, observé ok, hérité non rejoué.

- camera_lock::tests::native_default_remains_unlocked_and_invalid_configuration_is_explicit : attendu ok, observé ok, hérité non rejoué.

- camera_lock::tests::observer_setting_operations_preserve_already_pressed_human_buttons : attendu ok, observé ok, hérité non rejoué.

- camera_lock::tests::owner_pid_session_player_epoch_and_window_are_all_guarded : attendu ok, observé ok, hérité non rejoué.

- camera_lock::tests::physical_ui_observer_and_minimap_share_one_revision_consumer : attendu ok, observé ok, hérité non rejoué.

- camera_lock::tests::readiness_and_terminal_boundaries_refuse_mutation_and_invalidate_lease : attendu ok, observé ok, hérité non rejoué.

- camera_lock_ui::tests::background_keyboard_policy_does_not_admit_unfocused_pointer_clicks : attendu ok, observé ok, hérité non rejoué.

- camera_lock_ui::tests::foreign_window_events_cannot_toggle_or_steal_an_owned_press : attendu ok, observé ok, hérité non rejoué.

- camera_lock_ui::tests::human_hotkey_change_during_press_prevents_stale_ui_release : attendu ok, observé ok, hérité non rejoué.

- camera_lock_ui::tests::new_epoch_and_focus_loss_cancel_pointer_lease_without_replaying_release : attendu ok, observé ok, hérité non rejoué.

- camera_lock_ui::tests::ordered_short_click_has_one_owned_release_and_blocks_world_pointer : attendu ok, observé ok, hérité non rejoué.

- camera_lock_ui::tests::original_camera_records_keep_rect_uv_atlas_and_select_only_one_appearance : attendu ok, observé ok, hérité non rejoué.

- native_user_settings::tests::native_directory_choices_match_all_recorded_cases : attendu ok, observé ok, hérité non rejoué.

- native_user_settings::tests::native_default_language_initialization_and_migration_match_all_cases : attendu ok, observé ok, hérité non rejoué.

- native_user_settings::tests::files_on_disk_override_defaults_migrate_and_report_invalid_input : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::minimap_tests::manual_minimap_focus_releases_follow_without_inventing_actor_motion : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::absent_or_nonfinite_authoritative_target_suspends_without_guessing_position : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::blocked_frame_and_reopening_discard_gestures_without_replaying_os_repeats : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::camera_keys_match_original_gameevents_default_bindings : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::held_pan_preserves_existing_speed_and_does_not_add_tap_to_hold : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::local_inspection_does_not_advance_or_require_game_time_or_living_state : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::nonfinite_or_zero_frame_delta_never_adds_motion_or_queues_a_later_tap : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::opposing_taps_cancel_and_unrelated_gameplay_keys_are_untouched : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::press_release_in_one_frame_pans_once_while_frame_end_pressed_is_false : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::same_session_recovery_preserves_only_follow_new_player_or_session_resets_it : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::focus_loss_and_window_replacement_discard_taps_and_do_not_consume_other_readers : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::shared_setting_tests::ordinary_background_lock_follows_snapshot_without_altering_human_input : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::space_short_tap_centers_once_and_hold_follows_then_releases : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::wheel_permission_is_primary_window_only_and_disappears_during_gate : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::tests::y_toggles_once_with_repeat_ignored_and_locked_follow_takes_priority_over_pan : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::shared_setting_tests::ordinary_physical_y_routes_to_shared_consumer_once_and_unfocused_y_space_are_discarded : attendu ok, observé ok, hérité non rejoué.

- ordinary_camera_input::shared_setting_tests::either_winner_or_final_result_refuses_follow_without_rewriting_terminal_camera : attendu ok, observé ok, hérité non rejoué.

Journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log SHA-256 e92d1d1fedc29ec650da5fb536364cb29c8bdf02991a0b6782dbd7d3ecef53e3 ; binaire enregistré {"path": "E:\\OpenLeague\\target\\debug\\deps\\openleague_client-170289a4dedad9dd.exe", "sha256": "e2b2227752fb2e4db34a4602284dc6ff7359c393914619d0b502edcefe9aaddd", "bytes": 350254080}. Identité issue du run, pas nouvelle exécution/rehash de l’ancien chemin binaire.

### C1 — Chargement existant

Attendu : Reconnaître lecture actuelle et ne pas déclarer toute persistance absente.

Observé : Startup load_using→Loaded.text→camera_lock.setup lit HUD/LockCamera, défaut0; baseline identique à source native et run retenu.

Limite : Pas de nouvelle exécution du loader; sa création de répertoire et migration possible interdisent son invocation dans cet audit.

### C2 — Valeur valide/invalide

Attendu : 0/1 acceptés, champ absent ou invalide explicite.

Observé : Test retenu camera_lock configured accepte0/1, refuseNone/2; merge générique charge user avant baseline.

Limite : Test generic disk utilise EnvironmentQuality, pas une boucle fichier→Y/UI→save→relance LockCamera.

### C3 — Bascule et restauration

Attendu : Distinguer mémoire, lease conditionnelle et préférence disque.

Observé : Y, UI et minimap passent Setting.consume; owner_changed remet loaded default_locked, observer restore ne peut écraser révision humaine plus récente.

Limite : Aucun writeback identifié dans ces consumers; nouvelle session/lease réussie ne prouve pas persistance interprocessus.

### C4 — Raccourcis caméra

Attendu : Configuration remappée appliquée à chaque commande applicable.

Observé : 13défauts ordinaires recensés, six routes fixes (Y/Space/4flèches), sept routes sans consumer qualifié.

Limite : Pas de keymap caméra persistant identifié; trois hits de noms d’événements sont seulement assertions de tests.

### C5 — Conflits

Attendu : Qualifier les combinaisons sans commande concurrente imprévue.

Observé : F3 natif SelectAlly2 correspond actuellement à labels debug; CtrlShiftS natif DragScrollLock peut atteindre Action::Stop par condition KeyS sans garde de modificateurs.

Limite : Flux de source, pas parcours physique ni priorité native exécutée.

### C6 — Replay et modes

Attendu : Ne pas convertir une entrée absente en Unbound ni activer cheat/debug en partie.

Observé : 20déclarations replay;10SelectPlayer sans entrée dans troisInput.ini fournis. Sept événements supplémentaires contextuels distincts.

Limite : Provider dynamique possible non qualifié; aucun binding numérique inventé, aucun mode original exécuté.

### C7 — Refus et ownership

Attendu : Préserver révision/session/focus et gestes humains pendant observer/UI.

Observé : 35tests composants retenus couvrent setting, captures, input, leases et lecteur générique. Source actuelle identique.

Limite : Pas de sauvegarde réelle, validation OS ou rendu GUI actuel; ancien document HUD runtime true conserve pixels/follow/native false.

### C8 — Autres réglages et zoom

Attendu : Séparer paramètres enregistrables, gestes et état spatial instantané.

Observé : MapScrollSpeed/MiddleMouseScrollSpeed/ScrollSmoothing/SnapRespawn présents aux sources; zéro consumer nommé dans1168sources, pan150local. Wheel modifie zoom transitoire, pas un writer.

Limite : Pas de reconstruction numérique ou caméra-math ajoutée; parser opaque ne prouve pas application ni exigence de sauvegarder position courante.

Ancienne preuve F:\OpenLeague\docs\ordinary_camera_hud_progress.json date 2026-10-11T18:48:01.737619+00:00 : {"ordinary_hud_runtime_qualified": true, "actual_pixels_qualified": false, "camera_follow_runtime_qualified": false, "native_input_fidelity": false, "complete_game": false}. Limites conservées : One graphical HUD caster, optional paused resume; no six-GUI acceptance. ; Historical failures remain intact. Partial scopes do not establish complete runtime qualification. ; Camera gestures and capture interpretation require separate root observation; no pixel/native fidelity inferred. ; Smite90 remains provisional; Vilemaw, native input equivalence and full game acceptance are outside this document. Non rejouée/non relue visuellement ici.

Ancienne preuve F:\OpenLeague\docs\native_camera_wheel_live_validation.json date 2026-10-04T07:41:40.772983+00:00 : {"passed": true, "complete": false, "visually_inspected": true}. Limites conservées : Physical wheel not exercised; zoom acceptance is2592nativehandlers/65536Windowsvalues/ECSmessage+pose tests. ; Foreground window and human acceptance not established. Fullscene comparison, shadows/FOW/effects/audio remain incomplete. ; Vulkan logs retain missing TikTok implicit-layer manifest warning; actual framebuffer successfully generated. ; Server binary unchanged; latest333core tests cover source. No full6client/victory/fidelity acceptance. Non rejouée/non relue visuellement ici.

258contrôles documentaires producteur réussis. Non exécutés : tests Rust/compilation, loader de production, sauvegarde, jeu, relance, installation/migration, REA/natif/AIR, SQL/base, GUI/OS/clavier, GPU/réseau. L’exploration initiale a levé KeyError evtSelectPlayer1 car une déclaration était présumée avoir une entrée; corrigé en constat explicite des dix bindings absents, aucune valeur inventée.

## R5 — Écarts et reprise

Restent ouverts : application de keymap durable, politique et writeback HUD/LockCamera, sept commandes ordinaires, callbacks/priorité/chemins originaux, dix bindings replay non retrouvés, contexte/permissions supplémentaires et qualification de relance. Reprise native avec nouveau callback/xref/trace précis de chargement/sauvegarde ou provider d’événement; aucune recherche répétée sans piste nouvelle. Pas de succès de persistance tiré du test mémoire/lease ou d’une ancienne capture. Inconnue toujours open.

## R6 — Corrections documentaires, non appliquées

Aucun écart fonctionnel corrigé. Sept définitions existantes réutilisées :

- BIND-LOAD-01 : One shared keybinding loader/editor/writer/restart/provider; do not duplicate a camera persistence subsystem.

- BIND-SAVE-01 : One shared keybinding loader/editor/writer/restart/provider; do not duplicate a camera persistence subsystem.

- BIND-EDIT-CONFLICTS-01 : One shared keybinding loader/editor/writer/restart/provider; do not duplicate a camera persistence subsystem.

- BIND-RESTART-01 : One shared keybinding loader/editor/writer/restart/provider; do not duplicate a camera persistence subsystem.

- BIND-NATIVE-PROVIDER-01 : One shared keybinding loader/editor/writer/restart/provider; do not duplicate a camera persistence subsystem.

- SELF-FOCUS-CONFLICT-01 : Reuse focus/gesture/capture protection, keeping in-memory lock and durable preference distinct.

- TARGET-01-SELECTION : SelectSelf/Ally may have selection semantics beyond focus; do not infer inspection selection from centering alone.

Douze objectifs complémentaires : cinq transversaux et un par chacune des sept commandes ordinaires manquantes. Critères proposés pour reprise distincte, aucun critère normatif ni case du Plan modifié.

### CAMERA-KEYMAP-01 — Appliquer le keymap persistant aux commandes de caméra qualifiées.

Tâches existantes : SYS-17.4-01, SYS-22.3-03, SYS-22.3-07

Travail : Relier les13événements ordinaires à la configuration commune plutôt qu’aux six touches codées en dur. ; Conserver ordre/short taps, wheel gates et setting partagé; classifier événement absent, explicitement Unbound ou indisponible.

Critères de fin proposés : Remap choisi conservé par writer commun et relu au lancement; ancienne touche et conflits suivent règle qualifiée. ; Chaque événement applicable atteint son consumer réel; aucune chaîne opaque conservée présentée comme commande appliquée.

Condition de reprise : Autorisation produit distincte, BIND load/save/editor et événements/contrat natif disponibles.

Dépendances : BIND-LOAD-01, BIND-SAVE-01, BIND-EDIT-CONFLICTS-01, CAMERA-NATIVE-PERSISTENCE-01. État proposed_not_applied.

### CAMERA-DURABLE-SETTING-01 — Relier la préférence de verrouillage durable à la sauvegarde réelle.

Tâches existantes : SYS-09.4-04, SYS-22.3-07

Travail : Qualifier quelles actions Y/UI/menu/minimap modifient une préférence durable et quand elle est écrite; ne pas supposer toutes les bascules persistantes. ; Conserver lecture HUD/LockCamera existante; utiliser writer partagé vers le chemin autorisé, préserver autres clés et retour explicite d’échec. ; Ne pas sauvegarder owner/pid/session/revision, touche maintenue, position ou lease observateur; empêcher qu’une restauration transitoire écrase une préférence humaine.

Critères de fin proposés : Changement déclaré durable → fichier écrit une fois selon contrat → nouveau processus relit la valeur attendue. ; Échec écriture, config invalide et changement concurrent conservent fichier antérieur/état selon règle explicitée; observer et resets ne simulent pas sauvegarde.

Condition de reprise : Autorisation produit et politique originale d’écriture/portée ou reconstruction locale explicitement acceptée.

Dépendances : BIND-SAVE-01, CAMERA-NATIVE-PERSISTENCE-01. État proposed_not_applied.

### CAMERA-NATIVE-PERSISTENCE-01 — Qualifier les callbacks historiques de chargement et sauvegarde caméra.

Tâches existantes : SYS-17.4-06

Travail : Suivre handlers de13événements et getter/setter HUD/LockCamera jusqu’au writer et déclencheur réel. ; Distinguer writer générique AIR, provider du jeu, moment d’écriture, chemin, overrides/format et politique Y/UI/minimap; ne pas promouvoir GameIniFile.save en preuve de callback caméra.

Critères de fin proposés : Chaîne nommée événement/préférence→consumer→writer/relecture et contextes effectifs identifiés. ; En l’absence de handler/provider, inconnue précise reste ouverte avec prochaine entrée; pas de réimport complet PE sans xref/callback nouveau.

Condition de reprise : Nouveau callback/xref/trace de sauvegarde/chargement caméra dans le PE original ou provider nommé; les configs et helpers sont déjà épinglés.

Dépendances : Nouvelle entrée native discriminante, BIND-NATIVE-PROVIDER-01. État proposed_not_applied.

### CAMERA-RESTART-QUALIFICATION-01 — Qualifier la persistance de caméra dans un vrai nouveau processus.

Tâches existantes : SYS-22.3-01, SYS-22.3-02, SYS-22.3-07

Travail : Réutiliser35tests composants, puis choisir une préférence et un remap discriminants avec fichiers/binaires/source identifiés. ; Tester nouveau processus et nouvelle session, override valide/invalide, chemin non disponible, conflit et échec d’écriture sans appeler le loader sur données utilisateur pendant l’audit.

Critères de fin proposés : Preuve fichier avant/après et nouveau processus montre commande/réglage réellement conservé; mémoire/lease ne suffit pas. ; Parcours clavier/UI/OS identifié séparément des tests injectés; refus/focus préservent état et aucune migration implicite n’est exécutée.

Condition de reprise : Autorisation produit, writer et keymap intégrés, fixtures isolées autorisées et parcours réel prêt.

Dépendances : CAMERA-KEYMAP-01, CAMERA-DURABLE-SETTING-01, BIND-RESTART-01. État proposed_not_applied.

### CAMERA-CONTEXT-PERSISTENCE-01 — Qualifier les commandes et bindings de replay et autres contextes caméra.

Tâches existantes : SYS-21.1-03, SYS-21.2-03

Travail : Traiter20déclarations ReplayOptions, dont dix SelectPlayer sans entrée dans les Input.ini fournis; obtenir provider/handler plutôt qu’inventer touches1..0. ; Classer sept commandes HUD/debug/cheat et leur activation effective; garder permissions/contexte séparés du jeu ordinaire.

Critères de fin proposés : Chaque événement a source de binding ou absence explicite, mode autorisé et consumer qualifié; mauvaise session/mode refuse sans activer cheats. ; Remap/relecture applicable qualifié avec fichiers et contexte; absence déclarative ne devient ni Unbound ni absence globale native.

Condition de reprise : Nouveau provider/callback/trace des dix bindings ou contrat local explicite; autorisation produit pour tout consumer.

Dépendances : CAMERA-NATIVE-PERSISTENCE-01, BIND-LOAD-01, BIND-SAVE-01. État proposed_not_applied.

### CAMERA-COMMAND-EVTSELECTSELF — Qualifier puis relier evtSelectSelf à son consumer de caméra.

Tâches existantes : SYS-17.4-06, SYS-22.3-03, SYS-17.1-07

Travail : Réutiliser binding source [F1] et configuration commune; identifier maintien/appui/relâchement, cible/roster ou pan/verrou requis par handler/contrat. ; Conserver identité/session/focus, cible absente ou non finie et capture UI; No ordinary consumer identified; exact native event meaning beyond camera category remains unqualified.

Critères de fin proposés : Cas nominal de cet événement et remap rechargé observés; aucun geste de combat/diagnostic concurrent non prévu par le contrat. ; Cible/allié indisponible, focus/session/chord invalide n’invente pas mouvement; aucune sélection d’inspection supposée depuis le nom de l’événement.

Condition de reprise : Autorisation produit, règle originale ou locale explicite pour ce seul événement et consumer disponible.

Dépendances : CAMERA-KEYMAP-01, CAMERA-NATIVE-PERSISTENCE-01, SELF-FOCUS-CONFLICT-01. État proposed_not_applied.

### CAMERA-COMMAND-EVTSELECTALLY1 — Qualifier puis relier evtSelectAlly1 à son consumer de caméra.

Tâches existantes : SYS-17.4-06, SYS-22.3-03, SYS-17.1-07

Travail : Réutiliser binding source [F2] et configuration commune; identifier maintien/appui/relâchement, cible/roster ou pan/verrou requis par handler/contrat. ; Conserver identité/session/focus, cible absente ou non finie et capture UI; No ordinary consumer identified; exact native event meaning beyond camera category remains unqualified.

Critères de fin proposés : Cas nominal de cet événement et remap rechargé observés; aucun geste de combat/diagnostic concurrent non prévu par le contrat. ; Cible/allié indisponible, focus/session/chord invalide n’invente pas mouvement; aucune sélection d’inspection supposée depuis le nom de l’événement.

Condition de reprise : Autorisation produit, règle originale ou locale explicite pour ce seul événement et consumer disponible.

Dépendances : CAMERA-KEYMAP-01, CAMERA-NATIVE-PERSISTENCE-01, SELF-FOCUS-CONFLICT-01. État proposed_not_applied.

### CAMERA-COMMAND-EVTSELECTALLY2 — Qualifier puis relier evtSelectAlly2 à son consumer de caméra.

Tâches existantes : SYS-17.4-06, SYS-22.3-03, SYS-17.1-07

Travail : Réutiliser binding source [F3] et configuration commune; identifier maintien/appui/relâchement, cible/roster ou pan/verrou requis par handler/contrat. ; Conserver identité/session/focus, cible absente ou non finie et capture UI; Native F3; main.labels toggles debug_visible on KeyF3. Source dataflow only, no physical test.

Critères de fin proposés : Cas nominal de cet événement et remap rechargé observés; aucun geste de combat/diagnostic concurrent non prévu par le contrat. ; Cible/allié indisponible, focus/session/chord invalide n’invente pas mouvement; aucune sélection d’inspection supposée depuis le nom de l’événement.

Condition de reprise : Autorisation produit, règle originale ou locale explicite pour ce seul événement et consumer disponible.

Dépendances : CAMERA-KEYMAP-01, CAMERA-NATIVE-PERSISTENCE-01, SELF-FOCUS-CONFLICT-01. État proposed_not_applied.

### CAMERA-COMMAND-EVTSELECTALLY3 — Qualifier puis relier evtSelectAlly3 à son consumer de caméra.

Tâches existantes : SYS-17.4-06, SYS-22.3-03, SYS-17.1-07

Travail : Réutiliser binding source [F4] et configuration commune; identifier maintien/appui/relâchement, cible/roster ou pan/verrou requis par handler/contrat. ; Conserver identité/session/focus, cible absente ou non finie et capture UI; No ordinary consumer identified; exact native event meaning beyond camera category remains unqualified.

Critères de fin proposés : Cas nominal de cet événement et remap rechargé observés; aucun geste de combat/diagnostic concurrent non prévu par le contrat. ; Cible/allié indisponible, focus/session/chord invalide n’invente pas mouvement; aucune sélection d’inspection supposée depuis le nom de l’événement.

Condition de reprise : Autorisation produit, règle originale ou locale explicite pour ce seul événement et consumer disponible.

Dépendances : CAMERA-KEYMAP-01, CAMERA-NATIVE-PERSISTENCE-01, SELF-FOCUS-CONFLICT-01. État proposed_not_applied.

### CAMERA-COMMAND-EVTSELECTALLY4 — Qualifier puis relier evtSelectAlly4 à son consumer de caméra.

Tâches existantes : SYS-17.4-06, SYS-22.3-03, SYS-17.1-07

Travail : Réutiliser binding source [F5] et configuration commune; identifier maintien/appui/relâchement, cible/roster ou pan/verrou requis par handler/contrat. ; Conserver identité/session/focus, cible absente ou non finie et capture UI; No ordinary consumer identified; exact native event meaning beyond camera category remains unqualified.

Critères de fin proposés : Cas nominal de cet événement et remap rechargé observés; aucun geste de combat/diagnostic concurrent non prévu par le contrat. ; Cible/allié indisponible, focus/session/chord invalide n’invente pas mouvement; aucune sélection d’inspection supposée depuis le nom de l’événement.

Condition de reprise : Autorisation produit, règle originale ou locale explicite pour ce seul événement et consumer disponible.

Dépendances : CAMERA-KEYMAP-01, CAMERA-NATIVE-PERSISTENCE-01, SELF-FOCUS-CONFLICT-01. État proposed_not_applied.

### CAMERA-COMMAND-EVTONUIMOUSE4PAN — Qualifier puis relier evtOnUIMouse4Pan à son consumer de caméra.

Tâches existantes : SYS-17.4-06, SYS-22.3-03

Travail : Réutiliser binding source [Button 3] et configuration commune; identifier maintien/appui/relâchement, cible/roster ou pan/verrou requis par handler/contrat. ; Conserver identité/session/focus, cible absente ou non finie et capture UI; No ordinary consumer identified; exact native event meaning beyond camera category remains unqualified.

Critères de fin proposés : Cas nominal de cet événement et remap rechargé observés; aucun geste de combat/diagnostic concurrent non prévu par le contrat. ; Cible/allié indisponible, focus/session/chord invalide n’invente pas mouvement; aucune sélection d’inspection supposée depuis le nom de l’événement.

Condition de reprise : Autorisation produit, règle originale ou locale explicite pour ce seul événement et consumer disponible.

Dépendances : CAMERA-KEYMAP-01, CAMERA-NATIVE-PERSISTENCE-01, SELF-FOCUS-CONFLICT-01. État proposed_not_applied.

### CAMERA-COMMAND-EVTDRAGSCROLLLOCK — Qualifier puis relier evtDragScrollLock à son consumer de caméra.

Tâches existantes : SYS-17.4-06, SYS-22.3-03

Travail : Réutiliser binding source [Ctrl] [Shift] [s] et configuration commune; identifier maintien/appui/relâchement, cible/roster ou pan/verrou requis par handler/contrat. ; Conserver identité/session/focus, cible absente ou non finie et capture UI; Native Ctrl+Shift+S; main.commands sends Action::Stop on KeyS without Ctrl/Shift guard. No camera drag handler identified; no physical chord executed.

Critères de fin proposés : Cas nominal de cet événement et remap rechargé observés; aucun geste de combat/diagnostic concurrent non prévu par le contrat. ; Cible/allié indisponible, focus/session/chord invalide n’invente pas mouvement; aucune sélection d’inspection supposée depuis le nom de l’événement.

Condition de reprise : Autorisation produit, règle originale ou locale explicite pour ce seul événement et consumer disponible.

Dépendances : CAMERA-KEYMAP-01, CAMERA-NATIVE-PERSISTENCE-01, SELF-FOCUS-CONFLICT-01. État proposed_not_applied.

Tâches réutilisées, états préservés :

- SYS-17.4-01 / OLF-c010ba18-c9b6-59ab-b3a5-5b933320684a — Persister les raccourcis de capacités et d’objets : a_faire

- SYS-17.4-04 / OLF-7d5673b3-8e78-5446-831f-05ffd51d5849 — Gérer le lancement sur soi et les modificateurs de ciblage : a_faire

- SYS-17.4-08 / OLF-f51fd482-c241-572e-a85e-10ecbe4003f3 — Empêcher les saisies de chat de déclencher des commandes de combat : a_faire

- SYS-09.4-03 / OLF-f35e50de-7621-565f-a5d5-3a4aaf793435 — Déplacer la caméra aux bords de l’écran : a_faire

- SYS-09.4-04 / OLF-c34eefaa-7edb-5efc-adcd-c7f8385446fa — Verrouiller et déverrouiller la caméra sur le champion local : a_faire

- SYS-09.4-05 / OLF-51da5135-c7fb-534a-b3a6-92b0333e0b79 — Déplacer la caméra par la minimap : a_faire

- SYS-09.4-06 / OLF-caa2e11d-e7f4-5251-9ac1-c6aa34f07936 — Limiter la caméra aux bornes autorisées de la carte : a_faire

- SYS-21.1-03 / OLF-7b1b6c2c-8756-506d-9ebd-d6a141962e83 — Qualifier la disponibilité de chaque caméra et vue d’équipe : a_faire

- SYS-21.2-03 / OLF-47b7e764-e0e3-5b6b-95be-e255d467c641 — Changer le joueur suivi et sa caméra : a_faire

- SYS-22.3-01 / OLF-0098ca59-c07c-5c08-8536-f625cd4b3108 — Qualifier les touches par défaut sur clavier AZERTY : a_faire

- SYS-22.3-02 / OLF-e4793690-95a5-5851-9597-a954b69c6d72 — Qualifier les touches par défaut sur clavier QWERTY : a_faire

- SYS-22.3-03 / OLF-15336c59-7be4-5185-bc82-df51d624e3ec — Remapper une touche et gérer les conflits de raccourcis : a_faire

- SYS-22.3-07 / OLF-90c2f811-c684-5d29-9eb5-2e7311b590d3 — Conserver les réglages d’entrée après relancement : a_faire

- SYS-17.1-07 / OLF-fae17085-a8e6-5088-b3b5-8f83998772e7 — Afficher la cible sélectionnée et ses informations publiques : a_faire

## R7 — Livraison et conservation

Nouveaux fichiers uniquement : audit-unit.json, verify_camera_persistence.py, camera-command-matrix.json, camera-command-persistence-proof.json, ce rapport, verify_delivery.py et delivery-readback.json. Producteur audit_scope_closed=false; seule relecture R1–R7 clôture le parent documentaire. Fonctionnalité et goal global restent ouverts.

19fichiers logiciels gelés +6documents de contexte/méthode, cinq registres normatifs et Git suivi inchangés. Aucun goal/critère normatif, produit, tracker/interface ou base modifié; aucune base ouverte, installation, migration, relance, suppression ou écrasement. Preuves et échecs antérieurs conservés. Preuve principale F:\OpenLeague-work\audit-units\AUD-17.4-06-CAMERA-COMMAND-PERSISTENCE-01\camera-command-persistence-proof.json SHA-256 45fea5102e044f687166bd7dd066f9a77388a2005bb321ae0293b1247fe6f4a3 ; relecture F:\OpenLeague-work\audit-units\AUD-17.4-06-CAMERA-COMMAND-PERSISTENCE-01\delivery-readback.json.
