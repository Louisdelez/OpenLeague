# AUD-17.4-02-CAST-MODE-PERSISTENCE-01 — Modes normal et rapide

Date UTC : 2026-10-31T01:03:45.659192+00:00 ; parent SYS-17.4-02, OLF-4e001528-e50b-579e-ae58-e6eb088040f5 ; inconnue OLU-0816f405-8a26-502a-901a-ec5c491c46ed.

## R1 — Périmètre et dimensions

Audit du parent entier : paramètres normal/rapide par action, fichiers/provenance, déclenchement appliqué, appui/relâchement, édition/sauvegarde/restauration et limites. Clôture documentaire après relecture ; implémentation partielle, vérification héritée/partielle, acceptation humaine non donnée. Aucun critère normatif modifié. D17-SYS-17-4 requiert D09-SYS-09-4, toujours a_faire. Les sept autres parents ne sont pas clôturés par ce lot ; aperçu/confirmation SYS-17.4-03 et ciblage/modificateurs SYS-17.4-04 restent distincts.

## R2 — Sources historiques

Référence jeu PUBLIC4.20.0.315 EUW/en_GB, build2014-11-17 17:46:45 sans fuseau/déploiement établi, catalogue4.20.1 distinct. Les trois Input.ini déjà identifiés restent séparés :331champs defaults,13flags deploy fourni,27champs configuration utilisateur ; aucun dernier état utilisateur présenté comme défaut du patch.

- native_defaults : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\defaults\Input.ini ; SHA-256 930f1499991e9c4973e81086a26c944b7330058970c4227a614b897eae09fec1.

- supplied_deploy_override : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\input.ini ; SHA-256 aead4280d339159623dbe8f39784bde4b87a6b05afc6d95f2feccec7ba99073a.

- user_configuration_not_historical_default : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\Config\input.ini ; SHA-256 fa16e719b04249006b3ab7c77f7810e728d3743faf82e86cb259b6cc96d0a531.

La section exacte est [Quickbinds] et les13flags ...smart valent1 dans les deux fichiers fournis. Les défauts GameEvents ont des événements normaux et des alternatives Shift smart distincts :

- ability/0 : evtCastSpell1=[q] ; evtSmartCastSpell1=[Shift][q] ; [Quickbinds]/evtCastSpell1smart=1 dans le fourni.

- ability/1 : evtCastSpell2=[w] ; evtSmartCastSpell2=[Shift][w] ; [Quickbinds]/evtCastSpell2smart=1 dans le fourni.

- ability/2 : evtCastSpell3=[e] ; evtSmartCastSpell3=[Shift][e] ; [Quickbinds]/evtCastSpell3smart=1 dans le fourni.

- ability/3 : evtCastSpell4=[r] ; evtSmartCastSpell4=[Shift][r] ; [Quickbinds]/evtCastSpell4smart=1 dans le fourni.

- summoner/0 : evtCastAvatarSpell1=[d] ; evtSmartCastAvatarSpell1=[Shift][d] ; [Quickbinds]/evtCastAvatarSpell1smart=1 dans le fourni.

- summoner/1 : evtCastAvatarSpell2=[f] ; evtSmartCastAvatarSpell2=[Shift][f] ; [Quickbinds]/evtCastAvatarSpell2smart=1 dans le fourni.

- item/0 : evtUseItem1=[1] ; evtSmartCastItem1=[Shift][1] ; [Quickbinds]/evtUseItem1smart=1 dans le fourni.

- item/1 : evtUseItem2=[2] ; evtSmartCastItem2=[Shift][2] ; [Quickbinds]/evtUseItem2smart=1 dans le fourni.

- item/2 : evtUseItem3=[3] ; evtSmartCastItem3=[Shift][3] ; [Quickbinds]/evtUseItem3smart=1 dans le fourni.

- item/3 : evtUseItem4=[5] ; evtSmartCastItem4=[Shift][5] ; [Quickbinds]/evtUseItem4smart=1 dans le fourni.

- item/4 : evtUseItem5=[6] ; evtSmartCastItem5=[Shift][6] ; [Quickbinds]/evtUseItem5smart=1 dans le fourni.

- item/5 : evtUseItem6=[7] ; evtSmartCastItem6=[Shift][7] ; [Quickbinds]/evtUseItem6smart=1 dans le fourni.

- vision/None : evtUseVisionItem=[4] ; evtSmartCastVisionItem=[Shift][4] ; [Quickbinds]/evtUseVisionItemsmart=1 dans le fourni.

Les13flags couvrent quatre capacités, deux invocateurs, six objets et vision. Vision4 reste distincte de six slots et evtUseItem7/Recall[b]. Ni0, ni absent, ni ordre provider ou moment de déclenchement ne sont démontrés par les fichiers contenant1. Game.cfg defaults ne déclare pas explicitement SmartCastOnKeyRelease ; le Game.cfg utilisateur inspecté contient [HUD]/SmartCastOnKeyRelease=1 ligne33. Cela ne prouve pas un défaut natif1 ou0.

Game.cfg default : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\defaults\Game.cfg SHA-256 02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e ; utilisateur : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\Config\Game.cfg SHA-256 64d34912ea5411b47d6da0de44da374dd0a9e396fe96dc2b1d87ca76d562110e. Copies locales defaults Input.ini/Game.cfg comparées exactement. Les champs sont relevés lexicalement, sans prétendre exécuter le parser original.

Stockage AIR réutilisé depuis audit01 : KeyBindingController→GameCfgStack override→GameIniFile.save écrit input.ini. Sa base DAO est un catalogue READ ; aucune base ouverte. Le flag de relâchement appartient à Game.cfg, pas aux13flags Quickbinds. L’activité effective du menu AIR/cloud et le provider jeu restent non qualifiés.

PE natif : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Trois chaînes exactes et16occurrences DWORD en sections exécutables repérées en lecture bytes :

- Quickbinds à 0x10c1554 ; offset fichier13374804 ; occurrences valeurs : 0x821d61, 0x821d8a, 0x821e59, 0x821e82, 0x821fab, 0x821fd4, 0x8220a3, 0x8220cc, 0x82222d, 0x822259, 0x82232b, 0x822357, 0x82ed32, 0x8327d3.

- SmartCastOnKeyRelease à 0x10c1fbd ; offset fichier13377469 ; occurrences valeurs : .

- SmartCastOnKeyRelease à 0x10c25d8 ; offset fichier13379032 ; occurrences valeurs : 0x8363b0, 0x836d7c.

Ce ne sont pas des instructions, xrefs analysées ou entrées de fonctions. REA6.4 et son script V795 existant sont identifiés ; pas de réimport de toute l’image inchangée ici. Entrée précise de reprise : resolve_containing_procedure à0x821d61/0x82ed32/0x8327d3/0x8363b0/0x836d7c, puis getters/setters/callers et ordre effectif. Aucun code original, REA, ActionScript ou SQL exécuté dans ce lot.

## R3 — Consommateurs actuels

Le corpus de1 168sources reste identique. ground_target est une liste champion/slot pour routage au sol ; il ne lit ni normal/rapide ni préférences. Shortcuts contient slot/learn et ne porte pas de mode ; il choisit au keydown, filtre répétition, garde Ctrl et reset focus. Un Shift maintenu ne devient pas une variante de mode transmise par Shortcut. Main lit D/F just_pressed et item_hotkey fixe ; le chemin ciblé lit curseur/ray et produit directement Cast/CastAt, les autres branches Learn/Summoner/UseItem. Aucun état de confirmation normal/rapide persistant établi.

Le chargeur générique Game.cfg peut conserver un champ opaque dans text.entries ; sans consumer de mode cela ne signifie ni application ni sauvegarde de cette option. Recherche précise : \bQuickbinds\b|\bQuickBindMode\b|\bSmartCastOnKeyRelease\b|evtSmartCast|\bquick_cast\b|\bcast_mode\b dans1 168fichiers Rust/JS/HTML ; zéro correspondance. Une recherche exploratoire cast.*mode avait trouvé des modes de tests/graphismes et des sous-chaînes sans rapport ; elle n’a pas été considérée comme une implémentation de mode de lancement.

- F:\OpenLeague\crates\client\src\spell_input.rs:1 — fixed ground-routing and ordered key intent ; SHA-256 2f99cb617bfd218da8d8125fcf65fbfea34eb602391899547cf065c758eadccf.

- F:\OpenLeague\crates\client\src\main.rs:1351 — fixed item key mapping ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:1366 — commands entry has no mode preference input ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:1394 — summoner current cursor targeting ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:1439 — current immediate dispatch ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\native_user_settings.rs:54 — generic Game.cfg loading boundary ; SHA-256 f13aa64b4349d6bb250a888e147e2bec8f0422b98a4e61a3dd22c2837b6f7e1c.

## R4 — Attendu, observé et preuves

14 tests retenus déjà réussis, sources exactes rapprochées sur trois fichiers : dix tests spell_input (dont helper ground_target), un test de touches d’objets et trois tests génériques Game.cfg. Job client_tests terminal code0, identité du journal et du binaire de test conservée. Ils ne testent pas une préférence normal/rapide ni un parcours de persistance. Aucun test rejoué et aucune nouvelle capture nécessaire pour une fonctionnalité absente de ces consommateurs.

- item_hotkey_tests::original_six_item_keys_and_reserved_four_are_respected : attendu ok, observé ok (hérité).

- native_user_settings::tests::native_directory_choices_match_all_recorded_cases : attendu ok, observé ok (hérité).

- native_user_settings::tests::native_default_language_initialization_and_migration_match_all_cases : attendu ok, observé ok (hérité).

- native_user_settings::tests::files_on_disk_override_defaults_migrate_and_report_invalid_input : attendu ok, observé ok (hérité).

- spell_input::hotkey_tests::original_short_label_cases_and_source_defaults_match : attendu ok, observé ok (hérité).

- spell_input::hotkey_tests::shared_actual_key_press_dispatch_matches_native_hud_slots : attendu ok, observé ok (hérité).

- spell_input::ordered_shortcut_tests::complete_control_e_chord_in_one_frame_keeps_keydown_modifier : attendu ok, observé ok (hérité).

- spell_input::ordered_shortcut_tests::focus_reset_removes_stale_modifier_and_intent : attendu ok, observé ok (hérité).

- spell_input::ordered_shortcut_tests::held_modifier_across_frames_and_both_controls_are_preserved : attendu ok, observé ok (hérité).

- spell_input::ordered_shortcut_tests::later_control_or_already_released_control_cannot_convert_cast_to_learn : attendu ok, observé ok (hérité).

- spell_input::ordered_shortcut_tests::other_shortcuts_are_not_consumed_and_slot_precedence_is_unchanged : attendu ok, observé ok (hérité).

- spell_input::ordered_shortcut_tests::repeated_keydown_and_frame_gate_do_not_replay_an_intent : attendu ok, observé ok (hérité).

- spell_input::tests::only_supported_ground_slots_route_to_position_command : attendu ok, observé ok (hérité).

- spell_input::ordered_shortcut_tests::bevy_collector_keeps_message_order_without_consuming_other_readers : attendu ok, observé ok (hérité).

Journal : E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log SHA-256 e92d1d1fedc29ec650da5fb536364cb29c8bdf02991a0b6782dbd7d3ecef53e3 ; binaire enregistré {'path': 'E:\\OpenLeague\\target\\debug\\deps\\openleague_client-170289a4dedad9dd.exe', 'sha256': 'e2b2227752fb2e4db34a4602284dc6ff7359c393914619d0b502edcefe9aaddd', 'bytes': 350254080}.

### M1 — Valeurs natives et provenance

Attendu : Séparer bindings d’événement, flags de mode et préférence de relâchement.

Observé : Treize Quickbinds smart=1 deploy/user; défauts GameEvents normal+Shift-smart; HUD/SmartCastOnKeyRelease=1 uniquement dans Game.cfg utilisateur inspecté.

Limite : Ni0/1/absence ni priorité native effective prouvée par ces fichiers.

### M2 — Changement de mode capacités

Attendu : Préférence sélectionnée modifie le déclencheur de chaque capacité, avec conservation après relance.

Observé : Shortcuts possède slot/learn, pas mode; KEYS fixes et décision de cible par champion/slot. ground_target route au sol seulement.

Limite : Helper et tests de lancement existants ne constituent pas une sélection normal/rapide.

### M3 — Modes invocateurs/objets

Attendu : Préférence par slot D/F et six objets, sans activer action manquante.

Observé : Main prend D/F just_pressed et item_hotkey fixe puis envoie Summoner/UseItem directement. Vision4 réservée et Recall distinct.

Limite : Aucun mode configurable démontré;13flags, dont vision, ne signifient pas13actions implémentées.

### M4 — Confirmation/annulation/indicateur

Attendu : Contrat de déclenchement normal/rapide et annulation identifié, indicateur lié à SYS-17.4-03.

Observé : Chemin ciblé actuel lit cursor/ray et produit Cast/CastAt dans la même sélection; pas d’état persistant de visée dans Shortcut.

Limite : Aucune parité temporelle native ou preview courante prouvée; tâches03/04 distinctes.

### M5 — Appui/relâchement et focus

Attendu : Respecter préférence release, ne pas rejouer après repeat/focus ou relâchement annulé.

Observé : Collecteur filtre fresh/repeat, retient Ctrl au keydown et reset focus; release retire held mais ne génère pas de cast mode. Sept tests ordonnés hérités.

Limite : Ces tests ne qualifient pas SmartCastOnKeyRelease ni clavier OS.

### M6 — Load/save/restart et erreur

Attendu : Mode modifié sauvé au bon store, relu dans nouveau processus; erreurs ne donnent pas faux succès.

Observé : Chaîne AIR input.ini et BIND-LOAD/SAVE/RESTART réutilisées; current Game.cfg est générique, aucun consumer exact mode trouvé dans1168sources.

Limite : Loader peut conserver champ opaque Game.cfg; cela ne prouve ni son application ni sa sauvegarde par options.

### M7 — Fidélité du fournisseur et sémantique

Attendu : Nommer précisément les entrées natives restant à analyser.

Observé : Quickbinds0x10c1554 et deux chaînes SmartCastOnKeyRelease trouvées;16DWORDoccurrences exécutables donnent adresses de reprise.

Limite : Aucune instruction/fonction/xref sémantique inférée des bytes; REA non réexécuté, runtime historique absent.

### M8 — Conservation et correction antérieure

Attendu : Corriger seulement l’erreur de terme sans réécrire les acquis ou cocher tâche.

Observé : Erratum remplace une occurrence prose QuickBindMode/smart par [Quickbinds]; main01 avait déjà section correcte. SHA et sept rubriques antérieures conservés.

Limite : Correction documentaire uniquement; fonctionnalité et inconnue restent ouvertes.

228 contrôles documentaires producteur réussis ; ne pas compter comme tests fonctionnels. Non exécutés maintenant : Cargo, gameplay, clavier OS, GPU, réseau, REA/Ghidra, ActionScript, SQL, sauvegarde/relancement ou migration produit. Pas de preuve actuelle de normal/rapide configurables.

## R5 — Écarts et reprise

Ouverts : sémantique valeurs0/1/absence et priorité réelle, édition/lecture/sauvegarde des modes, application capacités/invocateurs/objets, déclenchement au relâchement et parcours après relance. L’inconnue OLU-0816f405-8a26-502a-901a-ec5c491c46ed reste open. Champs présents ou strings natives ne remplacent pas le getter/caller effectif ; tester ground_target ne clôture pas mode de lancement. Les adresses de reprise précises évitent de répéter une recherche générale sans hypothèse.

## R6 — Corrections et réutilisations

Aucun écart fonctionnel corrigé. Les cinq fiches communes de01 sont conservées sans duplication ni application :

- BIND-LOAD-01 — Preserve Quickbinds per-action flags separately from GameEvents key combinations; read release preference in Game.cfg without conflating stores. Critères et reprise : définition exacte conservée dans F:\OpenLeague-work\audit-units\AUD-17.4-01-PERSISTENT-BINDINGS-01\persistent-bindings-proof.json.

- BIND-SAVE-01 — Persist mode edits in proper user store; preserve13other flags/unknown entries and key bindings. Critères et reprise : définition exacte conservée dans F:\OpenLeague-work\audit-units\AUD-17.4-01-PERSISTENT-BINDINGS-01\persistent-bindings-proof.json.

- BIND-EDIT-CONFLICTS-01 — Mode toggle edits reuse current binding editor transaction; no implicit remap or unsupported action activation. Critères et reprise : définition exacte conservée dans F:\OpenLeague-work\audit-units\AUD-17.4-01-PERSISTENT-BINDINGS-01\persistent-bindings-proof.json.

- BIND-RESTART-01 — Add per-action mode and key-release option to the same new-process persistence qualification. Critères et reprise : définition exacte conservée dans F:\OpenLeague-work\audit-units\AUD-17.4-01-PERSISTENT-BINDINGS-01\persistent-bindings-proof.json.

- BIND-NATIVE-PROVIDER-01 — Resolve named Quickbinds/release raw PE candidates before any historical default/provider/timing claim. Critères et reprise : définition exacte conservée dans F:\OpenLeague-work\audit-units\AUD-17.4-01-PERSISTENT-BINDINGS-01\persistent-bindings-proof.json.

### CAST-MODE-MODEL-01 — Définir et relire les préférences normal/rapide par action.

Sources/consommateurs : Input.ini [Quickbinds] ; Input.ini GameEvents smart alternatives ; spell_input.rs.

Travail : Distinguer13flags Quickbinds et bindings GameEvents; traiter absent/vide/invalide sans déduire default patch des fichiers fournis. ; Identifier sémantique0/1, priorité provider et interactions des raccourcis Shift sur preuve native ou politique locale explicitement distincte.

Critères de fin : Une matrice13actions et valeurs admissibles est reliée au consumer, avec refus explicites et statut indisponible pour vision/action non implémentée. ; Lecture ne réécrit pas les ressources; mode différent du keycode et de la cible.

Condition de reprise : Correction produit autorisée et contrat de valeurs/absence nommé; les sources actuelles fournissent1, pas une démonstration des autres valeurs.

Dépendances : BIND-LOAD-01 ; BIND-NATIVE-PROVIDER-01. État : proposed_not_applied.

### CAST-MODE-ABILITY-01 — Appliquer le mode choisi aux quatre capacités sans modifier leurs règles serveur.

Sources/consommateurs : spell_input::Shortcuts ; main.commands Action::Cast/CastAt/Learn.

Travail : Relier chaque slot à sa préférence et définir les événements de déclenchement normal/rapide et annulation sur contrat identifié. ; Conserver apprentissage Ctrl et distinction ciblage au sol/unité; ne pas déduire mode de ground_target.

Critères de fin : Deux préférences différentes produisent les déclenchements attendus, une seule commande et aucune ancienne intention rejouée. ; Refus ressource/focus/fin/cible absent vérifiés; ne pas déclarer les122kits terminés.

Condition de reprise : Correction produit autorisée, modèle lu et déclencheurs normaux/rapides qualifiés ou politique locale nommée.

Dépendances : CAST-MODE-MODEL-01 ; SYS-17.4-03 ; SYS-17.4-04 ; SYS-17.4-08. État : proposed_not_applied.

### CAST-MODE-SUMMONER-01 — Appliquer les préférences aux deux slots d’invocateur.

Sources/consommateurs : main.summoner_action ; main.commands KeyD/KeyF ; GameEvents avatar smart bindings.

Travail : Brancher les flags evtCastAvatarSpell1smart/2smart sur D/F effectifs, sans modifier loadout ni validation du serveur. ; Conserver cas sans cible et cibles autorisées, ainsi que le refus lorsque pointeur minimap capturé.

Critères de fin : Chaque slot utilise son mode et bonne cible; option survivant au relancement, aucune double commande et actions non implémentées refusées.

Condition de reprise : Correction produit autorisée et modèle persistant; ne pas utiliser les tests d’objet comme preuve du dispatch D/F.

Dépendances : CAST-MODE-MODEL-01 ; BIND-RESTART-01. État : proposed_not_applied.

### CAST-MODE-ITEM-01 — Appliquer les préférences aux six slots d’objets.

Sources/consommateurs : main.item_hotkey ; main.commands Action::UseItem ; Quickbinds six item flags.

Travail : Brancher evtUseItem1..6smart sur slots0..5 en conservant priorités/conflits explicites. ; Garder vision4 et evtUseItem7/Recall distincts; une préférence conservée pour action indisponible ne la rend pas implémentée.

Critères de fin : Chaque slot fait une seule Action::UseItem selon mode qualifié; refus inventaire/cible/focus explicites. ; Aucun septième objet inventé et aucune preuve de smartcast tirée du seul test des touches1,2,3,5,6,7.

Condition de reprise : Correction produit autorisée, keymap/modèle effectifs et cas d’objet supporté identifié.

Dépendances : CAST-MODE-MODEL-01 ; SYS-22.3-03 ; BIND-RESTART-01. État : proposed_not_applied.

### CAST-MODE-EDIT-01 — Éditer une préférence de lancement et la persister dans le bon fichier utilisateur.

Sources/consommateurs : Input.ini Quickbinds ; existing binding edit/save correction ; mode model.

Travail : Réutiliser transaction lecture/écriture de BIND-LOAD/SAVE et éditeur existant prévu; séparer changement mode d’une réaffectation touche. ; Annulation/reset/erreur conservent les autres paramètres et n’activent pas une action indisponible.

Critères de fin : Un toggle capacités, un D/F et un objet modifient seulement leurs préférences puis sont retrouvés dans nouveau processus. ; Échec écriture visible, aucun faux succès ni changement lors annulation, aucun write au catalogue ou source native.

Condition de reprise : Correction produit autorisée et contrat de mode/model/save disponible.

Dépendances : CAST-MODE-MODEL-01 ; BIND-SAVE-01 ; BIND-EDIT-CONFLICTS-01 ; BIND-RESTART-01. État : proposed_not_applied.

### CAST-MODE-RELEASE-01 — Distinguer et appliquer l’option de lancement au relâchement.

Sources/consommateurs : user Game.cfg HUD/SmartCastOnKeyRelease ; native PE string0x10c25d8 ; spell_input ordered collector.

Travail : Traiter HUD/SmartCastOnKeyRelease dans Game.cfg séparément des13flags Input.ini. ; Qualifier affichage indicateur et déclencheur appui/relâchement, annulation et perte focus; réutiliser SYS-17.4-03 pour rendu plutôt que le déclarer acquis ici.

Critères de fin : Valeur absente/invalide et préférences appui/relâchement ont comportement attendu/observé; aucun cast après perte focus ni double cast. ; Option conservée après relance; la valeur utilisateur1 n’est jamais présentée comme défaut4.20 sans getter original.

Condition de reprise : Nouvelle trace getter/caller original ou analyse REA ciblée après resolve_containing_procedure aux occurrences0x8363b0/0x836d7c; correction produit autorisée séparément.

Dépendances : CAST-MODE-MODEL-01 ; SYS-17.4-03 ; SYS-17.4-08 ; BIND-RESTART-01. État : proposed_not_applied.

Tâches existantes vérifiées :

- SYS-17.4-01 / OLF-c010ba18-c9b6-59ab-b3a5-5b933320684a — Persister les raccourcis de capacités et d’objets ; état a_faire conservé.

- SYS-17.4-03 / OLF-dfcf608b-5420-5a99-9456-47574b64d7f5 — Afficher les indicateurs de portée avant confirmation ; état a_faire conservé.

- SYS-17.4-04 / OLF-7d5673b3-8e78-5446-831f-05ffd51d5849 — Gérer le lancement sur soi et les modificateurs de ciblage ; état a_faire conservé.

- SYS-17.4-08 / OLF-f51fd482-c241-572e-a85e-10ecbe4003f3 — Empêcher les saisies de chat de déclencher des commandes de combat ; état a_faire conservé.

- SYS-22.3-03 / OLF-15336c59-7be4-5185-bc82-df51d624e3ec — Remapper une touche et gérer les conflits de raccourcis ; état a_faire conservé.

- SYS-22.3-07 / OLF-90c2f811-c684-5d29-9eb5-2e7311b590d3 — Conserver les réglages d’entrée après relancement ; état a_faire conservé.

## R7 — Livraison et cohérence

Erratum ciblé ERR-17.4-01-QUICKBINDS-01 : F:\OpenLeague-work\audit-units\AUD-17.4-02-CAST-MODE-PERSISTENCE-01\prior-quickbinds-term-erratum.json SHA-256 cd8c276658bfdb09f0b45d55648f6df675dff78d57e8cbd701c59c913e7a0b44. Une occurrence prose QuickBindMode/smart devient « de la section [Quickbinds], avec suffixe smart ». Les données JSON sources de01 étaient déjà correctes. Original main/rapport/reader01 conservés par SHA ; correction documentaire, aucune réécriture des acquis.

Nouveaux fichiers uniquement : fiche audit-unit.json, prior-quickbinds-term-erratum.json, verify_cast_modes.py, cast-mode-proof.json, ce rapport et lecteur verify_delivery.py/delivery-readback.json. audit_scope_closed=false dans le producteur ; seul le lecteur indépendant clôture les sept rubriques du parent. Goal global et fonctionnalité restent non terminés.

19 fichiers logiciels gelés, six documents de contexte/méthode, cinq registres normatifs et Git suivi contrôlés inchangés ; aucune base ouverte, goal/critère/registre modifié, application de suivi ou jeu lancé, installation, migration ou restart. Relecture requise : F:\OpenLeague-work\audit-units\AUD-17.4-02-CAST-MODE-PERSISTENCE-01\delivery-readback.json. Preuve principale : F:\OpenLeague-work\audit-units\AUD-17.4-02-CAST-MODE-PERSISTENCE-01\cast-mode-proof.json SHA-256 97a6c8dd377677b5538071a8af2bfb106a599dcd6d1516842919f1e9c220e686.
