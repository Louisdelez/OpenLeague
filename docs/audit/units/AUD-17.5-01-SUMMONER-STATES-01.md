# AUD-17.5-01-SUMMONER-STATES-01 — états D/F et refus

Sous-lot de SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 dans SYS-01.2-02. Seul ce sous-lot peut être clos après R1–R7; parent tous-contrôles, fonctionnalité et goal global ouverts.

## R1 — Périmètre

Deux commandes logiques D/F, indices HUD4/5 parmi six QWER/D/F, six sprites icon/overlay/hotkey-background. Cinq valeurs actuellement admises : Barrier, Heal, Exhaust, Ignite, Smite. Ce ne sont ni six invocateurs ni admission de tout le catalogue. État a_faire et inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd open conservés; aucun critère normatif modifié. Quatre prérequis D17-SYS-17-1..4 restent ouverts comme fonctions.

## R2 — Sources et preuves réutilisées

Audit source existant F:\OpenLeague-work\audit-units\AUD-17.1-04-SUMMONERS-01\summoner-hud-proof.json et rapport F:\OpenLeague\docs\audit\units\AUD-17.1-04-SUMMONERS-01.md épinglés. Sources/configs/icônes déjà recensées, aucun nouvel export DDS ou recherche web/natif. Catalogue courant F:\OpenLeague\data\4.20\native_summoner_hud.json SHA-256 b119461523bff79f82c84fb6d49c2cc9d4297bb98bb8cb9498454814bc21b77d ; disabled_cast_rules SHA-256 f5e3f647a7c68b7cbb4b7bb7786d645cb8c82439203dbf30af1ba5aaf0e57256. Huit autres noms natifs restent non admis : SummonerBoost, SummonerClairvoyance, SummonerFlash, SummonerHaste, SummonerMana, SummonerOdinGarrison, SummonerRevive, SummonerTeleport. Leurs tâches d’admission indépendantes sont conservées.

- Barrier / SummonerBarrier : profil actuel 210.0s, catalogue [210]; allows-disabled=true; owner-only shield. SHA-256 règle 3113fd41b73d63ef967cf4b3cc2c8172b1efe919161532c51b1e0a4ac908e3e1

- Heal / SummonerHeal : profil actuel 240s, catalogue [300]; allows-disabled=true; owner plus optional secondary ally; None selects by server policy. SHA-256 règle df19a7e05aef52f51345745344a0064692212003397077417baf8dacc1a5c088

- Exhaust / SummonerExhaust : profil actuel 210s, catalogue [210]; allows-disabled=true; enemy champion. SHA-256 règle 53a9665721937deec13d2d55b1ab49f0d4be9f1fd589987f4996845925550c9d

- Ignite / SummonerDot : profil actuel 180.0s, catalogue [180]; allows-disabled=true; enemy champion. SHA-256 règle dde3020d391ef828b4935972cbea4349cf983714ccfaf9c85180768e6149db13

- Smite / SummonerSmite : profil actuel 90s, catalogue [90]; allows-disabled=true; eligible enemy minion or neutral unit via shared native-tag registry. SHA-256 règle 576a1c9d4c4ea27df3c7076a12cfb6927e95c294f007d7f010a21ff4b3a8e279

Bindings originaux [d]/[f] réutilisés. Le délai ready_at est celui du moteur courant, son dénominateur est le profil de base actuel, pas un total d’instance réseau ni une autorité serveur Riot. Heal240 face au client/catalogue300 et Smite90 provisoire restent explicitement ouverts. Champs Ammo génériques ne prouvent pas des charges. PE d’origine SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862 identifié non exécuté.

## R3 — Consommateurs et distinctions

states produit empty1, ready0, cooldown4, dead3; health non fini refuse. Il réutilise CanCastWhileDisabled pour les cinq sorts, tous true dans le contrat courant. Le serveur vérifie aussi slot/paire, fin, mouvement forcé, vie, cooldown puis ciblage/type/portée/protection selon le sort. Donc ready visuel n’est pas un succès de lancement.

La garde ciblée D/F existe déjà dans le caller extérieur : si minimap_pointer et summoner_requires_world_target, aucun summoner_action n’est envoyé. Ce bool combine capture minimap et bouton caméra; helper vrai seulement pour Exhaust/Ignite/Smite. Heal garde target=None sur capture, donc pas d’allié choisi derrière overlay; None désigne l’absence de cible secondaire explicite, pas un soin propriétaire seulement. Barrier ne demande pas de cible. Ne pas inventer une garde manquante en lisant seulement la closure summoner_action.

Shared all_states/recharge commence par QWER; une erreur peut masquer le groupe D/F, correction existante conservée. Contrôle forcé : states ne lit pas champion_forced, cast_summoner_on le refuse. Constat conditionnel de source, pas défaut graphique exécuté ni règle historique imposée. Refus reçus demeurent diagnostic partagé, pas last-rejected par slot.

- F:\OpenLeague\crates\client\src\native_hud_summoners.rs:13–21 — typed enum names and original layouts ; SHA-256 c157514d222c049d3e6e0820b15e3f1b111b5b52588d45c9cae05e002a403129

- F:\OpenLeague\crates\client\src\native_hud_summoners.rs:39–77 — state ready dead empty stun and base profile ; SHA-256 c157514d222c049d3e6e0820b15e3f1b111b5b52588d45c9cae05e002a403129

- F:\OpenLeague\crates\client\src\native_hud_summoners.rs:71–90 — shared QWER coupling and denominator refusal ; SHA-256 c157514d222c049d3e6e0820b15e3f1b111b5b52588d45c9cae05e002a403129

- F:\OpenLeague\crates\client\src\native_hud_spells.rs:8–15 — six D/F sprites selected among fourteen QWER DF sources ; SHA-256 c9af91d89a4c014ee3a844378e61579f3b01efbe682c89d8fbf83b40050ede4d

- F:\OpenLeague\crates\client\src\native_hud_spells.rs:40–57 — render cleanup and no last-rejected slot signature ; SHA-256 c9af91d89a4c014ee3a844378e61579f3b01efbe682c89d8fbf83b40050ede4d

- F:\OpenLeague\crates\client\src\main.rs:1381–1399 — common input gate captured world pointer and Heal exception ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620

- F:\OpenLeague\crates\client\src\main.rs:1399–1438 — spell-specific target resolver ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620

- F:\OpenLeague\crates\client\src\main.rs:1439–1454 — outer D/F guard already blocks captured targeted casts ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620

- F:\OpenLeague\crates\client\src\native_minimap.rs:27–30 — world pointer requirement exactly three spells ; SHA-256 72359625c522957a9b55b58a7c0043eb18c48d4c0e1f6c3f11ebfeb11ef17ac1

- F:\OpenLeague\crates\client\src\native_minimap_input_tests.rs:156–174 — actual retained commands-system captured-pointer regression ; SHA-256 7c88507d4add854c70f427c8f76f81ddb575aeb1c2f8a09e085863c425398458

- F:\OpenLeague\crates\core\src\summoners.rs:44–87 — authoritative dispatch life cooldown and forced movement ; SHA-256 7af19297380715624cb37f70ab62dfa9a65f7c8665e49b7699ee495d7a0d56a3

- F:\OpenLeague\crates\core\src\summoner_heal.rs:33–70 — Heal target is secondary and owner always recipient ; SHA-256 e7d80ecc10f4a119efaf1b7581e2ef4cf66d50b0b606dd9ddb406e65e6d68ac5

- F:\OpenLeague\crates\core\src\summoner_smite.rs:37–76 — Smite type resource range and unsupported interactions ; SHA-256 61c70144c5abf7330d7f8215c88fe98fa5614bb6c36e9b8da5be5e45099372ab

- F:\OpenLeague\crates\client\src\main.rs:1344–1348 — refusal routed to shared diagnostic ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620

## R4 — Attendu, observé, exécuté

### D1 — D/F source and admitted enums

Méthode : pinned native/current definitions and retained enum/source test

Attendu : Two slots with six sprites, five current spell values, no admission from a texture alone.

Observé : D/F are shared indices4/5, native bindings[d]/[f]; five typed values mapped, eight other native families remain unadmitted.

Limite : No all-mode/account/entire catalogue or GUI parity.

### D2 — Barrier state and repeat refusal

Méthode : retained actual core/HUD component test

Attendu : Ready→cooldown icon/text/ring, repeat refuses without extending deadline, ready at observed deadline.

Observé : real_barrier_cast test records state[0,0]→[4,0], ring/counter onlyslotD, repeated cast refuses and ready_at unchanged; pure projection at deadline returns ready.

Limite : Not accelerated live time, new GUI or physical D/F test.

### D3 — Five loadout states and disabled flags

Méthode : retained state/profile test plus pinned disabled policy

Attendu : Empty1, ready0, cooldown4, dead3 and invalid health refusal; stun policy distinct from death.

Observé : every_loadout test loops five values, confirms profile deadline bounds, death/nonfinite health; all five CanCastWhileDisabled=1 and current allows table true.

Limite : Does not establish every control effect or native actor-mask producer.

### D4 — Captured pointer: Exhaust/Ignite/Smite

Méthode : retained ECS commands-system regression with local socket observer

Attendu : Three targeted spells on D and F over captured minimap emit no cast or underlying RMB world action.

Observé : Existing outer guards call summoner_requires_world_target before summoner_action. Retained test exercises six spell/slot cases, no datagram and sequence0, with refusal text. Camera capture feeds the same source boolean.

Limite : Camera branch source linkage only; no physical OS/GPU or full secure session acceptance. The guard exists; do not propose it as missing.

### D5 — Heal and Barrier captured-pointer exceptions

Méthode : retained D/F Heal ECS regression plus source dispatch

Attendu : Heal may send None without picking ally behind overlay; Barrier needs no world target.

Observé : heal_d_and_f test preserves optional target outside, skips world pick over minimap. None is secondary ally policy, not owner-ID; Barrier goes through Summoner action.

Limite : Owner+secondary-ally server policy remains; no claim Heal must heal owner only or target-owner parameter is valid.

### D6 — Target validity and atomic rejection

Méthode : retained core tests for Heal/Exhaust/Ignite/Smite

Attendu : Wrong/missing/hidden/dead/out-of-range/type/resource targets do not spend cooldown or mutate protected state.

Observé : Named tests cover rejected targets, visibility/range and missing/unknown/wrong-kind resources; Smite permits native-disabled stun/silence per local policy.

Limite : Exact tested cases only, no all five complete kits or original server permissions.

### D7 — Shared error boundary

Méthode : source-path comparison plus reused correction

Attendu : Name why valid individual D/F state can still be hidden by shared QWER/DF renderer failure.

Observé : all_states first calls player_states?; recharge first calls QWER player_params?; render clears shared group on error. Denominator rejects remaining>current unmodified profile.

Limite : Not a new live fault or instruction to remove guard; existing HUD-SUM-ERROR-BOUNDARY-01 reused.

### D8 — Profile authority and ammo

Méthode : pinned inherited local/native comparison

Attendu : Do not call current denominator an original server cooldown or infer ammo from generic FX.

Observé : Current Heal240 differs catalogue/client300; Smite90 remains provisional, other profiles retain source caveats. Generic Ammo definitions do not admit charge behavior.

Limite : No new web/native research or unauthorized correction of profile values.

### D9 — Forced movement visual/command difference

Méthode : conditional source comparison only, no runtime execution

Attendu : Separate allows-disabled/stun from forced-movement guard and avoid ready=accepted.

Observé : With live/finite/ready actor and no ordinary stun, D/F states can be0 because no forced predicate is read. cast_summoner_on rejects champion_forced before dispatch.

Limite : Not proof of original CC or a rendered defect; qualification needed for one named spell/control effect before altering core or HUD.

### D10 — Refused feedback and lifecycle

Méthode : source consumers and retained session/loadout signature test

Attendu : Keep no-send, server refusal, profile error and session change separate.

Observé : Captured targeted input reports locally; server reason uses shared diagnostic, no per-slot last-rejected state. Signature changes with session/loadout even when ready.

Limite : No per-control refusal animation, all-reasons privacy, full GUI or parent completion; SYS-17.5-05 remains separate.

Treize tests existants réutilisés sans relance,17sources et7données de règles/catalogue correspondent au manifeste exécuté :

- native_hud_summoners::tests::every_loadout_state_stun_and_profile_is_explicit : attendu ok / observé ok, hérité non rejoué.

- native_hud_summoners::tests::five_exact_original_dds_and_source_bindings_cover_only_existing_enum : attendu ok / observé ok, hérité non rejoué.

- native_hud_summoners::tests::real_barrier_cast_drives_icon_text_ring_and_second_cast_rejection : attendu ok / observé ok, hérité non rejoué.

- native_hud_summoners::tests::qwer_values_and_original_names_remain_separate : attendu ok / observé ok, hérité non rejoué.

- native_hud_spells::summoner_signature_tests::session_and_loadout_changes_invalidate_icons_even_when_state_is_ready : attendu ok / observé ok, hérité non rejoué.

- native_minimap::input::tests::heal_d_and_f_over_minimap_skip_world_pick_and_preserve_optional_target_outside : attendu ok / observé ok, hérité non rejoué.

- native_minimap::input::tests::target_required_summoners_and_underlying_world_pointer_stay_blocked_over_minimap : attendu ok / observé ok, hérité non rejoué.

- summoner_exhaust::tests::invalid_targets_are_atomic_and_duplicate_loadouts_remain_rejected : attendu ok / observé ok, hérité non rejoué.

- summoner_ignite::tests::invalid_targets_visibility_and_range_never_spend_cooldown : attendu ok / observé ok, hérité non rejoué.

- summoner_smite::tests::smite_rejects_missing_champions_allies_dead_unknown_resource_and_kind_mismatch_atomically : attendu ok / observé ok, hérité non rejoué.

- summoner_smite::tests::smite_native_disabled_flag_permits_stun_and_silence_without_resource_or_order_cost : attendu ok / observé ok, hérité non rejoué.

- summoner_heal::tests::heal_restores_owner_and_one_wounded_ally_with_native_speed_and_historical_cooldown : attendu ok / observé ok, hérité non rejoué.

- summoner_heal::tests::explicit_ally_range_enemy_dead_and_unknown_fail_without_cooldown_or_health_changes : attendu ok / observé ok, hérité non rejoué.

Journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log SHA-256 e92d1d1fedc29ec650da5fb536364cb29c8bdf02991a0b6782dbd7d3ecef53e3 ; binaire enregistré {"path": "E:\\OpenLeague\\target\\debug\\deps\\openleague_client-170289a4dedad9dd.exe", "sha256": "e2b2227752fb2e4db34a4602284dc6ff7359c393914619d0b502edcefe9aaddd", "bytes": 350254080}

Journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\core_tests.log SHA-256 4d1161dda40d4d56de33399840916146e12d3c321cc8024d91778986b1574c35 ; binaire enregistré {"path": "E:\\OpenLeague\\target\\debug\\deps\\openleague_core-21eb81eb13817108.exe", "sha256": "6e9c5b42549fcf8b434979709ce0e845d4faf554552e6c5c4f3e5251f6da1623", "bytes": 787776512}

La preuve de capture minimap est ECS+observer socket fixture, pas OS, GPU ou transport sécurisé complet. Les six refus ciblés sont trois sorts sur D puis F; la branche caméra est reliée dans le code, pas une nouvelle capture. Aucun test Rust/natif, jeu/réseau actuel ou rendu relancé. 230contrôles documentaires producteur réussis; profils/images/critères existants inchangés.

Premier contrôle conservé : le journal Smite était trouvé mais son corps de test ne figurait pas dans les16sources choisies. Le module déclaré par #[path="summoner_smite_tests.rs"] était absent de cette liste. Version2 ajoute cette17esource et vérifie son hash dans le manifeste exécuté; aucun des13tests n’est retiré ni relancé. verify_summoner_states.py et producer-attempt-1-failure.json restent intacts; seules les métadonnées de vérification sont corrigées.

## R5 — Manques et reprise

Gardes supplémentaires, état acteur/contrôle forcé, profils historiques, indépendance d’erreur QWER/D/F, feedback par slot et parcours visuel restent ouverts. Reprise sur règle/callback/trace précis de masque ou profil, ou scénario d’intégration identifié autorisé; pas de nouveau scan DDS ou recherche identique sans piste. Les constats conditionnels ne deviennent pas de nouveaux tests réussis.

- inventory/vision, minimap/ping/camera/pause/surrender/return and other HUD controls need scoped state comparisons

- all-HUD control inventory and native active/disabled/refused coverage, GUI/OS/GPU and historical authority remain open

- eight native summoner families outside the current enum retain their independent admission corrections

- SYS-17.5-02..06 and global HUD acceptance are not completed by this subunit

Couverture partielle : dix commandes logiques distinctes comparées dans deux sous-lots (huit QWER/Learn puis deux D/F), aucun dénominateur HUD complet ni pourcentage. Le parent SYS-17.5-01 reste ouvert.

## R6 — Corrections existantes et objectif précis

Aucune fonctionnalité corrigée. Cinq définitions réutilisées sans modification : HUD-SUM-HEAL-PROFILE-01, HUD-SUM-SMITE-PROFILE-01, HUD-SUM-AMMO-SCOPE-01, HUD-SUM-ERROR-BOUNDARY-01, HUD-SUM-RENDER-LIFECYCLE-01. Huit admissions par nom restent celles de l’audit source. Une seule précision nouvelle du masque de mouvement forcé :

### HUD-SUM-FORCED-MOVEMENT-STATE-01 — Qualifier le signal D/F pendant un mouvement forcé pour un invocateur et un effet nommés.

Travail : Identifier règle native/contrat local de mouvement forcé distincte du seul bit CanCastWhileDisabled et du stun. ; Comparer pour un sort nommé état visuel, commande acceptée/refusée, feedback et absence de mutation; conserver les gardes et profils actuels avant décision.

Critères de fin proposés : Source/controller ou décision locale explicite nomme le masque pertinent, cas nominal et refus réellement comparés sur le contrôle. ; Aucun Ready=accepté présumé, ni grisé universel imposé; cooldown/protection/état serveur préservés, preuve limitée au sort/effet retenu.

Condition de reprise : Nouvelle trace/callback natif de masque/disponibilité ou règle locale acceptée, puis autorisation produit et scénario de contrôle forcé précis.

Dépendances : HUD-SUM-RENDER-LIFECYCLE-01, SYS-17.5-05. État proposed_not_applied.

La garde minimap/caméra, exceptions Heal/Barrier et tests existants sont des acquis conservés. Aucun nouvel objectif de réparation de cette garde. Aucun critère normatif ni case du Plan modifié.

## R7 — Livraison et conservation

Nouveaux fichiers uniquement : audit-unit.json, verify_summoner_states.py conservé, producer-attempt-1-failure.json, verify_summoner_states_v2.py, summoner-states-proof.json, ce rapport, verify_delivery.py et delivery-readback.json. Seule relecture ferme le sous-lot; parent_documentary_scope_closed=false.19fichiers logiciels gelés +6documents, cinq registres normatifs et Git suivi inchangés. Aucun goal/critère normatif, produit, tracker/UI ou base modifié; aucune base ouverte, installation, migration, relance, suppression ou écrasement.

Preuve principale F:\OpenLeague-work\audit-units\AUD-17.5-01-SUMMONER-STATES-01\summoner-states-proof.json SHA-256 b9c5b7e269abbbcbbe889b04425e7aa359424cfd5b0a3ab3e7ed6f45eea9621b ; relecture F:\OpenLeague-work\audit-units\AUD-17.5-01-SUMMONER-STATES-01\delivery-readback.json. Anciens résultats et limites conservés.
