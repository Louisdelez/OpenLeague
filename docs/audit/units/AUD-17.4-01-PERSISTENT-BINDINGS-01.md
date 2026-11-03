# AUD-17.4-01-PERSISTENT-BINDINGS-01 — Raccourcis persistants

Date UTC : 2026-10-31T00:52:47.498359+00:00. SYS-17.4-01 — OLF-c010ba18-c9b6-59ab-b3a5-5b933320684a ; inconnue OLU-8d1361f4-bce6-53ca-996e-fc0ddefaf2d0.

## R1 — Périmètre et dimensions

Audit du parent entier « Persister les raccourcis de capacités et d’objets » : source des défauts, édition, lecture/écriture, applications clavier/HUD, relancement et limites. Audit clôturable après relecture indépendante ; implémentation partielle ; vérification partielle/héritée ; acceptation humaine non donnée. Aucun critère normatif modifié ; goal, registres, cases et inconnues conservés.

D17-SYS-17-4 requiert D09-SYS-09-4 « Caméra et commandes au sol », sept tâches encore a_faire et D09-SYS-09-1 requis. Le prérequis demeure fonctionnellement ouvert. Cast normal/rapide SYS-17.4-02, caméra SYS-17.4-06 et capture chat SYS-17.4-08 restent distincts. Ancien lien KEYS:5 couvrait seulement une entrée QWER fixe.

## R2 — Sources historiques et provenance

Référence jeu PUBLIC4.20.0.315 EUW/en_GB, date2014-11-17 17:46:45 sans fuseau/déploiement établi, catalogue4.20.1 distinct. Le PE source D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe ; SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. AIR lol_air_client release0.0.1.119 / version4.20.14_11_18_18_52 identifié séparément.

Trois couches inventoriées et relues sans supposer leur priorité historique effective :

- native_defaults : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\defaults\Input.ini ; 331 champs ; SHA-256 930f1499991e9c4973e81086a26c944b7330058970c4227a614b897eae09fec1.

- supplied_deploy_override : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\input.ini ; 13 champs ; SHA-256 aead4280d339159623dbe8f39784bde4b87a6b05afc6d95f2feccec7ba99073a.

- user_configuration_not_historical_default : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\Config\input.ini ; 27 champs ; SHA-256 fa16e719b04249006b3ab7c77f7810e728d3743faf82e86cb259b6cc96d0a531.

Le Config/input.ini710octets fourni est une configuration utilisateur, jamais un défaut officiel. Le fichier deploy305octets contient13 options QuickBindMode/smart ; les défauts30938octets331champs portent GameEvents et HUDEvents distincts. Valeurs ciblées : evtCastSpell1..4=q,w,e,r ; apprentissage Ctrl+q,w,e,r ; six objets1,2,3,5,6,7 ; evtUseVisionItem=[4] ; evtUseItem7=[b] sous commentaire Recall, pas septième slot ordinaire.

Chaîne AIR identifiée : LocalGameDataServiceImpl→KeybindingDAO ouvre gameStats_<locale>.sqlite en SQLMode.READ pour keybindingEvents/keybindingCategories. Cette base est un catalogue, pas la destination des préférences modifiées. Aucune base native ou de suivi n’a été ouverte ou interrogée. KeyBindingController charge ces défauts puis GameIniFile input.ini via OutputAssetsDir ; GameCfgStack lit override avec repli défaut et écrit overrideData. updateKey sérialise alternatives séparées par virgule et modificateurs en crochets ; save appelle iniOverrides.save puis synchronisation conditionnelle.

GameIniFile lit UTF8 si le fichier existe, avertit sinon ; save ouvre FileMode.WRITE, render puis writeUTFBytes et close. La source montre une écriture directe, aucune atomicité native démontrée. OutputAssetsDir distingue RADS/Config, SHALLOW/Game/DATA/CFG et DEV ; leur sélection effective sur une sessionhistorique reste non exécutée.

Attention à l’activation : ClientConfig initialise enableKeybinding=false et playerPreferencesSyncing=true, avec setters ; UpdateKeybindings n’écrit la préférence reçue que si enableKeybinding==true. Cloud save/load sont conditionnels et liés aux timestamps/summoner. ApplicationController appelle loadFromServerIfNeeded quand sync est activé. Présence des classes ≠ preuve d’un éditeur AIR actif EUW2014 ni d’un service original disponible. Le consommateur natif jeu83ED50/6D77E0 et ses priorités restent ouverts ; ne pas le remplacer par cet empilement AIR.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\Keybinding\KeyBindingController.as:186 — KeyBindingController.getInputOverrideFilename ; SHA-256 20c9ee99262de2d9238643788acb784e40f729d953fc977938cf6de5e80a97f7.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\Keybinding\KeyBindingController.as:295 — KeyBindingController.onKeybindingDefaultsRetrieved ; SHA-256 20c9ee99262de2d9238643788acb784e40f729d953fc977938cf6de5e80a97f7.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\Keybinding\KeyBindingController.as:269 — KeyBindingController.updateKey ; SHA-256 20c9ee99262de2d9238643788acb784e40f729d953fc977938cf6de5e80a97f7.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\Keybinding\KeyBindingController.as:127 — KeyBindingController.generateDataFromKeys ; SHA-256 20c9ee99262de2d9238643788acb784e40f729d953fc977938cf6de5e80a97f7.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\Keybinding\KeyBindingController.as:330 — KeyBindingController.getKeysFromData ; SHA-256 20c9ee99262de2d9238643788acb784e40f729d953fc977938cf6de5e80a97f7.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\Keybinding\KeyBindingController.as:324 — KeyBindingController.save ; SHA-256 20c9ee99262de2d9238643788acb784e40f729d953fc977938cf6de5e80a97f7.

- F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibCommon_dat\scripts\com\riotgames\platform\common\utils\file\GameCfgStack.as:17 — GameCfgStack.readValue ; SHA-256 7c5918ff035828cc1da5cbd77661cdc1d36b103bdce221e3f88a55eb896e6868.

- F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibCommon_dat\scripts\com\riotgames\platform\common\utils\file\GameCfgStack.as:28 — GameCfgStack.setValue ; SHA-256 7c5918ff035828cc1da5cbd77661cdc1d36b103bdce221e3f88a55eb896e6868.

- F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibCommon_dat\scripts\com\riotgames\platform\common\utils\file\GameIniFile.as:62 — GameIniFile.initializeFromFile ; SHA-256 d88e5c163c42af16ba90ddd594c0a0d52287c33f0237ff5270fb92ea73e3bf40.

- F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibCommon_dat\scripts\com\riotgames\platform\common\utils\file\GameIniFile.as:41 — GameIniFile.readFile ; SHA-256 d88e5c163c42af16ba90ddd594c0a0d52287c33f0237ff5270fb92ea73e3bf40.

- F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibCommon_dat\scripts\com\riotgames\platform\common\utils\file\GameIniFile.as:74 — GameIniFile.save ; SHA-256 d88e5c163c42af16ba90ddd594c0a0d52287c33f0237ff5270fb92ea73e3bf40.

- F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibCommon_dat\scripts\com\riotgames\platform\common\utils\file\GameCfgData.as:280 — GameCfgData.readValue ; SHA-256 074459a6c0320e68afea9aa18ac107207ca65d8e5e90c0ea598f029311727780.

- F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibCommon_dat\scripts\com\riotgames\platform\common\utils\file\GameCfgData.as:195 — GameCfgData.render ; SHA-256 074459a6c0320e68afea9aa18ac107207ca65d8e5e90c0ea598f029311727780.

- F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibCommon_dat\scripts\com\riotgames\platform\common\utils\file\OutputAssetsDir.as:69 — OutputAssetsDir.GetOutputBaseDir ; SHA-256 d726751750570085d5c59f20acde024d6400ef59e6f389206da0d83668a1ff1f.

- F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibCommon_dat\scripts\com\riotgames\platform\common\utils\file\OutputAssetsDir.as:95 — OutputAssetsDir.GetGameConfigFileDir ; SHA-256 d726751750570085d5c59f20acde024d6400ef59e6f389206da0d83668a1ff1f.

- F:\OpenLeague\docs\reference_air_sources\review\mod__ser__mod_ser_dat\scripts\com\riotgames\platform\gameclient\module\services\local\KeybindingDAO.as:16 — KeybindingDAO.KeybindingDAO ; SHA-256 4788cdecb7dbfcae90d31c55557e4217623cc811c35b93cb3ff174600f88947f.

- F:\OpenLeague\docs\reference_air_sources\review\mod__ser__mod_ser_dat\scripts\com\riotgames\platform\gameclient\module\services\local\KeybindingDAO.as:73 — KeybindingDAO.getKeybindingDefaults ; SHA-256 4788cdecb7dbfcae90d31c55557e4217623cc811c35b93cb3ff174600f88947f.

- F:\OpenLeague\docs\reference_air_sources\review\mod__ser__mod_ser_dat\scripts\com\riotgames\platform\gameclient\module\services\local\KeybindingDAO.as:33 — KeybindingDAO.getKeybindingCategories ; SHA-256 4788cdecb7dbfcae90d31c55557e4217623cc811c35b93cb3ff174600f88947f.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\PlayerPreferencesSyncController.as:119 — PlayerPreferencesSyncController.saveToServerIfNeeded ; SHA-256 76cd68c215c4d6313ad94ab91a04aaeac6fc9edb2d5296736d3f34ccde4e3026.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\PlayerPreferencesSyncController.as:84 — PlayerPreferencesSyncController.saveKeybindingsIfNeeded ; SHA-256 76cd68c215c4d6313ad94ab91a04aaeac6fc9edb2d5296736d3f34ccde4e3026.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\PlayerPreferencesSyncController.as:98 — PlayerPreferencesSyncController.UpdateKeybindings ; SHA-256 76cd68c215c4d6313ad94ab91a04aaeac6fc9edb2d5296736d3f34ccde4e3026.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\PlayerPreferencesSyncController.as:162 — PlayerPreferencesSyncController.loadFromServerIfNeeded ; SHA-256 76cd68c215c4d6313ad94ab91a04aaeac6fc9edb2d5296736d3f34ccde4e3026.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\account\GameCfgData\PlayerPreferencesSyncController.as:253 — PlayerPreferencesSyncController.shouldUpdateToCloud ; SHA-256 76cd68c215c4d6313ad94ab91a04aaeac6fc9edb2d5296736d3f34ccde4e3026.

- F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibSystem_dat\scripts\com\riotgames\pvpnet\system\config\ClientConfig.as:67 — default AIR keybinding flag false ; SHA-256 dedc99b1d3067c5a9fb96dbf5659625e43919db0e5cb8c5c33701beead67b65c.

- F:\OpenLeague\docs\reference_air_sources\review\lib__ClientLibSystem_dat\scripts\com\riotgames\pvpnet\system\config\ClientConfig.as:267 — default AIR preference sync flag true ; SHA-256 dedc99b1d3067c5a9fb96dbf5659625e43919db0e5cb8c5c33701beead67b65c.

- F:\OpenLeague\docs\reference_air_sources\review\mod__man__mod_man_dat\scripts\com\riotgames\platform\gameclient\ApplicationController.as:926 — actual AIR cloud-load call ; SHA-256 14614012a94c79933e7af2f6ec50334d33d6ae2cb88c99873d480862dd7649b9.

Quatre DAT existants vérifiés contre le manifeste de décompilation, copies AS comparées octet pour octet aux exports antérieurs ; aucun export ni REA répété. Onze cas ASCII du formatter83DF6F–83E1D4 sont hérités avec helpers chaîne adaptés, pas la boucle d’événements native. Aucun ActionScript, SQL ou processus original exécuté.

## R3 — Consommateurs actuels

Corpus actuel de1 168fichiers Rust/JS/HTML identique. spell_input::KEYS fixe quatre KeyCode Q/W/E/R ; Shortcuts enregistre ordre keydown, Ctrl au moment de l’appui, ignore repeat, efface intentions à chaque frame et reset au focus perdu. Le plugin est installé dans main ; commands consomme Shortcuts.selected. Le HUD snapshot_values appelle hud_labels qui lit le contrat compilé include_str dans OnceLock ; ce n’est pas une préférence modifiable.

main.item_hotkey fixe1,2,3,5,6,7 pour slots0..5 ;4 reste réservé. commands donne priorité aux objets avant les autres actions, passe Action::UseItem et applique les gates de focus/ressources/fin de partie. native_hud_inventory consomme icônes et counts ; aucun InventoryItemHotKey identifié dans ce module. native_hud_widgets affiche SpellHotKey depuis le contrat fixe.

native_user_settings::load_using est un vrai lecteur Game.cfg et peut créer un répertoire/migrer ce fichier : il n’est pas invoqué dans cet audit. Il ne charge pas input.ini et ne prouve aucune persistance de keymap. Le fichier native_hud.rs ou inventory_panel.rs imaginé n’a pas servi de preuve d’absence : leurs consommateurs réels widgets/inventory ont été retrouvés et inspectés.

Recherche bornée reproductible sur1 168sources : \bkeybind(?:ing|ings)?\b|\bkey_bindings?\b|\brebinding\b|(?<![\w])input\.ini(?!\w)|evtCastSpell[1-4]|evtUseItem[1-7] ; 5 correspondances classées : commentaire caméra, test de defaults, commentaire spell_input, diagnostic de limites du HUD learning et commentaire de rebinding de fibre audio sans rapport avec le clavier. L’expression exploratoire Input.ini trop large capturait input.initial* ; l’expression consignée ajoute les bornes d’identifiant. Recherche lexicale + dispatch direct ne qualifient pas les bibliothèques externes ou le binaire original.

- F:\OpenLeague\crates\client\src\spell_input.rs:4 — fixed spell keys collector and labels ; SHA-256 2f99cb617bfd218da8d8125fcf65fbfea34eb602391899547cf065c758eadccf.

- F:\OpenLeague\crates\client\src\main.rs:1351 — fixed six item keys and reserved vision key ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:1366 — actual commands entry and gate ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:1439 — actual item dispatch ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:600 — actual startup configuration selection ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:700 — actual ordered shortcut plugin ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\native_hud_widgets.rs:82 — actual spell label consumer ; SHA-256 d088b147e43585a8a19e3fbf30625980303d7218158c3e6da8f0e116bf3ddf81.

- F:\OpenLeague\crates\client\src\native_hud_inventory.rs:35 — actual inventory icon and count consumer ; SHA-256 00c506b31d15f93f844a9bc45c8327839d2a0ffde80a527d23d0abb62501c6db.

- F:\OpenLeague\crates\client\src\native_user_settings.rs:54 — Game.cfg loader migration boundary ; SHA-256 f13aa64b4349d6bb250a888e147e2bec8f0422b98a4e61a3dd22c2837b6f7e1c.

## R4 — Vérification et attendu/observé

13 tests CPU ciblés réutilisés : neuf raccourcis/libellés/ordre/focus, un test des six touches objets, trois tests Game.cfg. Cinq fichiers sources correspondent exactement au manifeste avancé ; job client_tests terminal code0 et journaux conservés. Aucune relance de test inchangé. Les trois tests Game.cfg couvrent leurs lecteurs/migrations/erreurs, pas la persistance Input.ini.

- item_hotkey_tests::original_six_item_keys_and_reserved_four_are_respected : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- native_user_settings::tests::native_directory_choices_match_all_recorded_cases : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- native_user_settings::tests::native_default_language_initialization_and_migration_match_all_cases : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- native_user_settings::tests::files_on_disk_override_defaults_migrate_and_report_invalid_input : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- spell_input::hotkey_tests::original_short_label_cases_and_source_defaults_match : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- spell_input::hotkey_tests::shared_actual_key_press_dispatch_matches_native_hud_slots : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- spell_input::ordered_shortcut_tests::complete_control_e_chord_in_one_frame_keeps_keydown_modifier : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- spell_input::ordered_shortcut_tests::focus_reset_removes_stale_modifier_and_intent : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- spell_input::ordered_shortcut_tests::held_modifier_across_frames_and_both_controls_are_preserved : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- spell_input::ordered_shortcut_tests::later_control_or_already_released_control_cannot_convert_cast_to_learn : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- spell_input::ordered_shortcut_tests::other_shortcuts_are_not_consumed_and_slot_precedence_is_unchanged : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- spell_input::ordered_shortcut_tests::repeated_keydown_and_frame_gate_do_not_replay_an_intent : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

- spell_input::ordered_shortcut_tests::bevy_collector_keeps_message_order_without_consuming_other_readers : attendu ok ; observé ok dans journal hérité E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log.

Binaire de test enregistré : {'path': 'E:\\OpenLeague\\target\\debug\\deps\\openleague_client-170289a4dedad9dd.exe', 'sha256': 'e2b2227752fb2e4db34a4602284dc6ff7359c393914619d0b502edcefe9aaddd', 'bytes': 350254080}. Identité historique conservée, aucune nouvelle exécution ni qualification du graphe GUI complet.

Deux captures réellement relues avec view_image :

- F:\OpenLeague\logs\native-hud-hotkeys-live-vulkan-annie-precast.png SHA-256 c7574d9b07d93911dd01026f5a7fa39cd83a542d43d18bc0c267a3423859a854 ; vulkan: Annie near own shop; q/w/e/r lowercase under four spell icons, gold425, HP512/512, mana534/534. Old retained pixels; no edit dialog, changed key, item-hotkey label, save, OS keyboard delivery or restart proof.

- F:\OpenLeague\logs\native-hud-hotkeys-live-dx12-annie-precast.png SHA-256 e614beed074461c1c48390f7839700be6670bf17952bc25f30c6b1952f3e16f1 ; dx12: Annie near own shop; q/w/e/r lowercase under four spell icons, gold425, HP512/512, mana534/534. Old retained pixels; no edit dialog, changed key, item-hotkey label, save, OS keyboard delivery or restart proof.

Anciens runs Annie1280x800 DPI1 Vulkan/DX12 : clientSHA bb541b213d7338555001941afe8691e72b28900efb35009f76b174e9a17e9a14 ; serveurSHA4e690499ad6f81703a24801cf1e6d469e338337f406ae861835aebf31f2ff8b9. Commandes ordinaires envoyées directement : les pixels q/w/e/r ne prouvent ni clavier OS ni édition/sauvegarde/restart. complete=false conservé.

### B1 — Défauts capacités et apprentissage

Attendu : QWER et Ctrl+QWER liés à actions et mêmes libellés.

Observé : Valeurs GameEvents natives identifiées; KEYS fixes, collecteur ordonné et labels compilés q/w/e/r; neuf tests ciblés de raccourcis hérités.

Limite : Pas de keymap éditable ni traduction physique/logique OS qualifiée.

### B2 — Objets et touche4

Attendu : Six slots utilisent1,2,3,5,6,7; vision4 distincte; ne pas confondre evtUseItem7/Recall[b] avec septième slot ordinaire.

Observé : Défauts natifs et item_hotkey(0..5) correspondent; test réserve4; Action::UseItem prioritaire.

Limite : Persistance et labels objets non identifiés; vision/Recall sont des actions distinctes à conserver.

### B3 — Couches et provenance

Attendu : Défaut natif, override fourni et configuration utilisateur ont provenance distincte.

Observé : 331/13/27 champs relus; config utilisateur710octets n’est pas un défaut4.20. AIR charge catalogue localisé par DAO READ puis override input.ini.

Limite : Ne pas assimiler l’empilement AIR aux priorités effectives du binaire jeu ni au dump utilisateur.

### B4 — Modifier et sérialiser

Attendu : Modifier une action et alternatives/modificateurs sans détruire les autres entrées.

Observé : AIR updateKey écrit overrideData via GameCfgStack; générateur utilise virgules et crochets, getKeysFromData les relit.

Limite : Aucun éditeur Rust identifié; AS non exécuté; conflits, limites de combinaison et validation native restent à qualifier.

### B5 — Sauvegarder localement

Attendu : Écriture sur fichier utilisateur sélectionné, résultat observable et aucun faux succès sur erreur.

Observé : AIR save→iniOverrides.save→FileMode.WRITE/render/writeUTFBytes. Le loader Rust inspecté charge Game.cfg, peut migrer Game.cfg; il ne sauvegarde pas input.ini.

Limite : Aucun write/save input Rust identifié; source AIR montre écriture directe, pas garantie atomique native. Aucun loader produit exécuté ici.

### B6 — Restaurer après relancement

Attendu : Un nouveau processus relit les raccourcis édités et commande avec nouvelles touches seulement.

Observé : AIR initializeFromFile/readFile/Stack documentés; runtime actuel conserve constantes et include_str OnceLock.

Limite : Aucun parcours edit→save→restart→dispatch actuel démontré. Trois tests Game.cfg ne remplacent pas ce parcours.

### B7 — Absent, vide, invalide, interdit écriture

Attendu : Repli/erreur explicite; préserver ancienne configuration; contrat pour désaffectation.

Observé : AIR absence fichier avertit et conserve GameCfgData vide; readValue replie sur valeur fausse/vide. Helper local refuse nonASCII et rend blanc pour libellé long/modifié/Unbound.

Limite : Pas de preuve de refus/écriture Input.ini Rust ni de parser original jeu complet; utiliser [<Unbound>] selon contrat, pas inventer équivalence avec vide.

### B8 — Ordre clavier/focus/conflit

Attendu : Pas d’intention rejouée, modificateur au keydown et pas de cast pendant saisie.

Observé : Sept tests ordonnés hérités sur module exact; reset au focus perdu; priorité QWER fixe, objets avant sorts. Gate shop actuel distinct de chat.

Limite : Pas de résolution de conflits après remapping ni OS AZERTY/QWERTY/mouse-extra; tâches22.3 et chat17.4-08 réutilisées.

### B9 — Libellés et inventaire

Attendu : Même configuration effective pour dispatch et labels capacités/objets.

Observé : snapshot_values→hud_labels constants; inventaire actuel traite icônes et counts, sans InventoryItemHotKey. Deux captures montrent défauts q/w/e/r.

Limite : Pas de mise à jour label après remap; pas de preuve de labels objets; accepter défaut affiché ne valide pas persistance.

### B10 — Cloud et activation AIR

Attendu : Identifier flags et éviter de déduire usage historique de simple présence de classes.

Observé : DAO READ catalogue, jamais DB writable de préférences; cloud conditionnel playerPreferencesSyncing, UpdateKeybindings garde enableKeybinding. Defaults source false/true respectivement, setters existent.

Limite : Activation effective EUW2014, menu appelant save/update et service distant original non qualifiés. Aucun DB/SQL ni réseau exécuté.

Contrôles producteur : 306 vérifications documentaires réussies ; ces vérifications ne sont pas de nouveaux tests fonctionnels. Non exécutés maintenant : Cargo, application, ActionScript, SQL, tests Rust, sockets, GPU, clavier physique, édition/sauvegarde de configuration, relancement ou migration. Aucun native_user_settings::load appelé.

## R5 — Écarts et reprise

Audit source/consommateur précis au-delà du seul KEYS est établi. Restent non implémentés/non qualifiés dans les consommateurs inspectés : keymap éditable et son Input.ini load/save, dispatch remappé des capacités et objets, labels dépendant des bindings, édition/conflits et parcours après relancement. Le loader Game.cfg, les tests défauts et les captures ne ferment aucun de ces écarts.

Fidélité native distincte : priorité réelle des trois Input.ini, activation/menuAIR, catalogue localisé effectif, OS/locale, validation des combinaisons/Unbound/vide et callbacks83ED50/6D77E0 restent indéterminés. Entrée de reprise : nouvelle trace nommée du loader/menu/flags ou analyse native ciblée sur une hypothèse discriminante ; aucune recherche répétée sans cette entrée. L’inconnue OLU-8d1361f4-bce6-53ca-996e-fc0ddefaf2d0 reste open dans le registre conservé.

## R6 — Corrections précises réutilisant les tâches existantes

Aucun écart fonctionnel corrigé. Neuf fiches proposées, statut proposed_not_applied ; elles précisent ce parent et réutilisent les tâches existantes22.3 et17.1-05 sans créer une implémentation parallèle.

### BIND-LOAD-01

Objectif : Charger une keymap effective de capacités et six slots objets depuis un fichier utilisateur identifié.

Tâches existantes : SYS-22.3-07. Sources/consommateurs : GameCfgStack.readValue ; KeyBindingController.onKeybindingDefaultsRetrieved ; native_user_settings.rs ; spell_input.rs.

Prérequis/dépendances : SYS-17.4-01 ; BIND-NATIVE-PROVIDER-01 pour fidélité historique complète.

Travail : Définir identité/provenance du fichier et sections; préserver défauts, override utilisateur et options smart distincts. ; Lire alternatives, modificateurs et désaffectation selon contrat identifié; refuser l’invalide sans inventer un default silencieux.

Critères de fin : Mapping nominal lu depuis disque, fichier absent/vide/invalide/unknown fields et mauvais format vérifiés. ; Aucun Game.cfg, catalogue ou configuration fournie n’est réécrit à la lecture; priorité native non prouvée marquée politique locale.

Condition de reprise : Correction produit autorisée et contrat Input.ini/disposition choisi explicitement; sources présentes, pas de nouvelle recherche large.

État : proposed_not_applied.

### BIND-SAVE-01

Objectif : Sauvegarder une modification de keymap sans perdre les réglages existants.

Tâches existantes : SYS-22.3-07. Sources/consommateurs : GameIniFile.save ; GameCfgData.render ; KeyBindingController.save.

Prérequis/dépendances : BIND-LOAD-01.

Travail : Écrire seulement le fichier utilisateur sélectionné et préserver sections/entrées hors modification. ; Définir politique locale de commit et erreur sans attribuer atomicité à AIR; diagnostiquer lecture seule, dossier manquant et écriture interrompue.

Critères de fin : Une modification capacités et une modification objets sont relues sur disque; ancien contenu utile préservé. ; Erreur visible et aucun succès annoncé si commit échoue; aucun write aux sources natives ou catalogue.

Condition de reprise : Autorisation produit, readerBIND-LOAD-01 disponible et fixture isolée sous F pour cas de sauvegarde.

État : proposed_not_applied.

### BIND-SPELL-DISPATCH-01

Objectif : Appliquer les bindings de capacités et apprentissage à la boucle clavier réelle.

Tâches existantes : SYS-22.3-03. Sources/consommateurs : spell_input::Shortcuts ; main.commands.

Prérequis/dépendances : BIND-LOAD-01 ; SYS-22.3-03 ; SYS-17.4-08.

Travail : Remplacer sélection par constantes par keymap effective sans perdre ordre keydown, repeat, deux Ctrl et reset focus. ; Définir conflits et priorité avec autres actions; ne pas changer implicitement quickcast/selfcast.

Critères de fin : Touches éditées déclenchent slots/appprentissage attendus; anciennes touches désaffectées ne déclenchent plus. ; Refus pendant captures applicables, perte focus et appui complet dans une frame vérifiés; pas de double commande.

Condition de reprise : Correction produit autorisée et keymap chargée; réutiliser les neuf tests existants avant nouveaux cas discriminants.

État : proposed_not_applied.

### BIND-ITEM-DISPATCH-01

Objectif : Appliquer les bindings effectifs aux six slots d’objets.

Tâches existantes : SYS-22.3-03, SYS-17.1-05. Sources/consommateurs : main.item_hotkey ; main.commands Action::UseItem ; native Input.ini GameEvents.

Prérequis/dépendances : BIND-LOAD-01 ; SYS-22.3-03.

Travail : Utiliser keymap effective pour slots0..5, conserver vision4 et ancien evtUseItem7/Recall séparés. ; Définir collision avec capacités, inventaire capturé et cible; aucune autorité nouvelle de gameplay.

Critères de fin : Chaque slot remappé produit une seule Action::UseItem correcte et ancienne touche inactive. ; Touches simultanées/conflits/focus refusés ou résolus selon contrat explicite;4 ne devient pas septième objet.

Condition de reprise : Correction produit autorisée, keymap effective et inventaire identifié; test six touches existant conservé.

État : proposed_not_applied.

### BIND-SPELL-LABELS-01

Objectif : Afficher les libellés de capacités issus des bindings effectifs.

Tâches existantes : SYS-22.3-01, SYS-22.3-02. Sources/consommateurs : spell_input.hud_labels ; native_hud_widgets.snapshot_values ; native_hud_hotkeys_contract.json.

Prérequis/dépendances : BIND-LOAD-01 ; BIND-SPELL-DISPATCH-01 ; SYS-22.3-01 ; SYS-22.3-02.

Travail : Supprimer dépendance du texte aux seuls defaults compilés; utiliser la même keymap que le dispatch. ; Qualifier labels courts/longs/modificateurs/alternatifs/Unbound et caractères horsASCII sans inventer format natif.

Critères de fin : Changer un binding modifie le label associé, les quatre slots restent cohérents et restaurés après relance. ; Captures réelles et refus/fallback visible pour format non qualifié; onze cas natifs ASCII conservés avec leurs limites.

Condition de reprise : Correction produit autorisée et police/label path identifiés; original6D77E0 requis seulement pour parité historique de traduction.

État : proposed_not_applied.

### BIND-ITEM-LABELS-01

Objectif : Afficher les six libellés de raccourcis d’objets issus de la keymap.

Tâches existantes : SYS-17.1-05. Sources/consommateurs : native_hud_inventory.rs ; native HUD InventoryItemHotKey0..5 sources ; main.item_hotkey.

Prérequis/dépendances : BIND-LOAD-01 ; BIND-ITEM-DISPATCH-01 ; SYS-17.1-05.

Travail : Inspecter les sources HUD natives nommées avant ajouter des glyphes; conserver icônes/charges. ; Relier chacun des six labels à sa touche effective, traiter vide/Unbound et longueur.

Critères de fin : Six labels concordent avec les six actions après édition et relance; pas de confusion vision/Recall. ; Captures avec plusieurs slots et limites de police/scale identifiées; absence de ressource reste explicite.

Condition de reprise : Correction produit autorisée, sources HUD nommées accessibles et keymap effective; pas de duplication du HUD existant.

État : proposed_not_applied.

### BIND-EDIT-CONFLICTS-01

Objectif : Éditer une affectation et appliquer une politique explicite de conflit.

Tâches existantes : SYS-22.3-03, SYS-22.3-04. Sources/consommateurs : KeyBindingController.updateKey/getKeysFromData ; KeybindingID ; spell_input.rs ; native_user_settings.rs.

Prérequis/dépendances : BIND-LOAD-01 ; BIND-SAVE-01 ; SYS-22.3-03 ; SYS-17.4-08.

Travail : Créer une édition d’action unique avec validation/annulation/réinitialisation et désaffectation explicites. ; Qualifier conflit, modificateurs et boutons supportés; garder focus éditeur hors combat.

Critères de fin : Un changement, annulation, reset et conflit nominal/refus produisent un résultat visible déterministe. ; Aucune touche de capture ne lance combat; aucune sauvegarde lors annulation; persistance seulement sur validation réussie.

Condition de reprise : Autorisation produit et contrat de keymap/écriture; activation/UI AIR non prouvées ne deviennent pas obligation de cloud.

État : proposed_not_applied.

### BIND-RESTART-01

Objectif : Qualifier le parcours complet édition→sauvegarde→relancement→commandes.

Tâches existantes : SYS-22.3-07. Sources/consommateurs : main startup ; spell_input.rs ; main.item_hotkey ; native_hud_widgets.rs ; native_hud_inventory.rs.

Prérequis/dépendances : BIND-SAVE-01 ; BIND-SPELL-DISPATCH-01 ; BIND-ITEM-DISPATCH-01 ; BIND-SPELL-LABELS-01 ; BIND-ITEM-LABELS-01.

Travail : Réutiliser 13 tests ciblés et anciennes captures de défauts; compléter seulement le parcours remappé. ; Identifier deux processus distincts, fichier avant/après, touches nouvelles/anciennes, commandes et labels.

Critères de fin : Au moins une capacité et un objet modifiés survivent au nouveau processus avec action/label cohérents. ; Cas annulé, fichier invalide, écriture refusée et focus perdu gardent résultat explicite, sans faux succès ni mutation des sources.

Condition de reprise : Autorisation produit, correctifs load/save/apply/labels disponibles et deux sessions ordinaires isolées identifiées.

État : proposed_not_applied.

### BIND-NATIVE-PROVIDER-01

Objectif : Qualifier les priorités/activation du fournisseur historique de raccourcis sans assimiler AIR au jeu.

Tâches existantes : SYS-22.3-01, SYS-22.3-02, SYS-22.3-07. Sources/consommateurs : Input.ini defaults/deploy/user ; KeybindingDAO READ ; ClientConfig enableKeybinding ; KeyBindingController ; native83ED50/6D77E0.

Prérequis/dépendances : Nouvelles entrées historiques nommées; contrat statique AIR déjà acquis.

Travail : Suivre seulement une trace/hook nommée du loader d’entrée jeu ou du menu actif et les flags de sessionEUW. ; Relier catalogue localisé et override au consommateur effectif; distinguer absence cloud du support local.

Critères de fin : Ordre des fichiers/providers, flags effectifs et consommateurs identifiés sur preuve historique ou inconnus conservés. ; Aucune exécution SQL ou dépendance cloud introduite dans Plan; aucun succès historique déduit du fichier utilisateur.

Condition de reprise : Nouvelle trace originale de loader/menu/flags ou analyse REA ciblée avec callback nommé et entrée discriminante; sinon arrêter la recherche.

État : proposed_not_applied.

Tâches inspectées, états inchangés :

- SYS-22.3-01 / OLF-0098ca59-c07c-5c08-8536-f625cd4b3108 — Qualifier les touches par défaut sur clavier AZERTY ; a_faire.

- SYS-22.3-02 / OLF-e4793690-95a5-5851-9597-a954b69c6d72 — Qualifier les touches par défaut sur clavier QWERTY ; a_faire.

- SYS-22.3-03 / OLF-15336c59-7be4-5185-bc82-df51d624e3ec — Remapper une touche et gérer les conflits de raccourcis ; a_faire.

- SYS-22.3-04 / OLF-65129913-b16f-5561-ae67-a6cafa5c2f56 — Qualifier les boutons supplémentaires de souris requis ; a_faire.

- SYS-22.3-07 / OLF-90c2f811-c684-5d29-9eb5-2e7311b590d3 — Conserver les réglages d’entrée après relancement ; a_faire.

- SYS-17.1-05 / OLF-0e2d77ab-62ab-59c0-bf3e-70cbcb22f2da — Afficher l’inventaire et les charges d’objet ; a_faire.

- SYS-17.4-02 / OLF-4e001528-e50b-579e-ae58-e6eb088040f5 — Persister les modes de lancement normal et rapide ; a_faire.

- SYS-17.4-06 / OLF-610203c3-0359-5552-b384-9ae5b501a757 — Persister les commandes de caméra ; a_faire.

- SYS-17.4-08 / OLF-f51fd482-c241-572e-a85e-10ecbe4003f3 — Empêcher les saisies de chat de déclencher des commandes de combat ; a_faire.

## R7 — Livraison et conservation

Nouveaux fichiers seulement dans ce lot : audit-unit.json, verify_persistent_bindings.py (première tentative échouée conservée), producer-attempt-1-failed.json, verify_persistent_bindings_v2.py, persistent-bindings-proof.json, ce rapport, verify_delivery.py et delivery-readback.json. Producteur audit_scope_closed=false ; clôture du parent documentaire seulement après sept rubriques de relecture indépendante. Aucune clôture des sept autres parents de17.4 ou du goal global.

Première tentative : arrêt sur assertion trop étroite des correspondances rebinding ; aucun reçu principal ni rapport créé. V2 classe les cinq occurrences réelles sans effacer la tentative ni ignorer les sources HUD/audio.

19 fichiers logiciels gelés et six documents de contexte/méthode, cinq registres normatifs, contenu du corpus et état Git suivi sont vérifiés inchangés. Aucune base ouverte ; aucun goal/critère/registre/case/note/historique modifié ; aucune installation, migration ou restart. Échec lecture Git standard128 Permission denied conservé comme limite d’accès du bac à sable, contrôle lecture seule élevé réussi, sans modification Git.

Preuve principale : F:\OpenLeague-work\audit-units\AUD-17.4-01-PERSISTENT-BINDINGS-01\persistent-bindings-proof.json ; SHA-256 f11919464ff786316a36362a9316740dea2a381475369eb9c26a65cf635d1677. Relecture : F:\OpenLeague-work\audit-units\AUD-17.4-01-PERSISTENT-BINDINGS-01\delivery-readback.json.
