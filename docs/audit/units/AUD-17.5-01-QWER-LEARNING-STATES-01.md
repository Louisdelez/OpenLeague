# AUD-17.5-01-QWER-LEARNING-STATES-01 — états QWER, apprentissage et refus

Sous-lot de SYS-17.5-01 / OLF-62057f72-7ad9-53a8-9188-d8ef7cb6fb46 dans SYS-01.2-02. Seul ce périmètre peut être clos après relecture R1–R7. Parent tous-contrôles ouvert, fonctionnalité et goal global non terminés.

## R1 — Périmètre précis

Huit commandes logiques : Q/W/E/R et LearnQ/W/E/R. Seize sprites : quatre Spell+Overlay et quatre EvolutionArrow+Frame. Icône ne signifie pas bouton cliquable : input QWER vient des commandes, apprentissage possède hit boxes. D/F et tous les autres contrôles sont exclus de ce sous-lot, pas supprimés du parent. État a_faire et inconnue OLU-7f169cfb-24b6-5bf1-86bc-6862d9a6c5dd open préservés; aucun critère normatif modifié. Quatre lots prérequis D17-SYS-17-1..4 restent fonctionnellement a_faire; preuves d’audit réutilisées sans les promouvoir en fonctions prêtes.

## R2 — Sources et preuves héritées

Audit QWER existant F:\OpenLeague-work\audit-units\AUD-17.1-03-QWER-01\qwer-hud-proof.json et rapport F:\OpenLeague\docs\audit\units\AUD-17.1-03-QWER-01.md relus et épinglés. Il conserve4schémas de rangs admis,118autres explicitement ouverts; aucune recherche d’icônes, DDS ou rangs répétée. V125 décrit seulement slots/apprentissage, pas tous les contrôles : F:\OpenLeague\docs\reference_hud_validation_sources\hud_validation-links.json.

- F:\OpenLeague\data\4.20\native_hud_spell_states_contract.json SHA-256 4e249c6ac849c7d2c718a3fbcb3e863b5c585fe7bff2f63fb4a6845ed94ae9c8 : Original availability and cooldown getter results supplied by callbacks; original resource-state controller76C430 adapted to supplied0/5 result. Getter and resource-cost producers are not qualified here. ; Native mask getter76C610, rank/cooldown ordering, four ordinary slots and color selection execute original instructions. Character masks supplied; full crowd-control/death/targeting/variant producers remain open. ; Palette comes from supplied FastHUD.ini Spells section; rollover pulse interpolation7830, pip/rank/cooldown effects, UI callbacks and whole framebuffer remain open.

- F:\OpenLeague\data\4.20\native_hud_learning_contract.json SHA-256 0a078d42a4111900b8b709747955c094af6091b062dd4940a3be3aadb4c58ddd : Original enable/disable branches execute native instructions. Virtual element setters adapted to capture booleans. Actor unavailable-mask and panel-open/fade producers supplied; their original population/transition not qualified. ; Native expanded icon/overlay fade, glow7D7830, collapse, tooltip, pointer handlers and native learn-event production remain open. ; Rust integration uses shared authoritative progression for supported Annie/Garen; other champion rank schemes remain open.

384états,192couleurs et32branches learning hérités, non réexécutés. Getters/contexte et masques/ressources fournis ne prouvent pas leurs producteurs historiques. PE SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862 identifié non exécuté. Couleurs/flags ne prouvent pas pixels, mode actuel ni acceptation de commande.

## R3 — Consommateurs et couches distinctes

state priorise unavailable1→cooldown4→rank0/2→blocked3→resource-state0/5. player_states donne availability=true puis utilise santé/mana/rangs/CD/stun et coût de base; il ne lit pas tous les masques, silence ou variantes. Palette et overlay ne sont pas une autorisation du serveur. Renderer appelle color(...,false,false); hover/override complets non prouvés.

Learning : eligible appelle next_rank après maxima; eligible=false omet arrow/frame, ce n’est pas toujours une couleur disabled. Render désactive sur winner, action_at vérifie rang/bounds/winner, input ajoute captures/ready. next_rank ne vérifie pas santé; command refuse health<=0 avant Learn. Nouveau constat conditionnel précis, sans inventer la politique native.

AnnieR guide et GarenE cancel passent avant les contrôles ordinaires de cooldown ; l’overlay générique peut rester4. Ne pas corriger cela en remboursant la recharge ou en prétendant que tout4 interdit tout recast. GameplayRejected est reçu avec contexte et borne512, puis diagnostic partagé/pause feedback; signature QWER et learning n’exposent aucun last-rejected par slot. Confidentialité de tous les motifs et présentation refusée restent SYS-17.5-05.

- F:\OpenLeague\crates\client\src\native_hud_spells.rs:8–15 — QWER icon overlay source selection ; SHA-256 c9af91d89a4c014ee3a844378e61579f3b01efbe682c89d8fbf83b40050ede4d

- F:\OpenLeague\crates\client\src\native_hud_spells.rs:16–31 — state priority palette and partial actor masks ; SHA-256 c9af91d89a4c014ee3a844378e61579f3b01efbe682c89d8fbf83b40050ede4d

- F:\OpenLeague\crates\client\src\native_hud_spells.rs:40–57 — render signature is not rejection state ; SHA-256 c9af91d89a4c014ee3a844378e61579f3b01efbe682c89d8fbf83b40050ede4d

- F:\OpenLeague\crates\client\src\native_hud_learning.rs:7–15 — learning eligibility and eight source sprites ; SHA-256 9ae494663305220318cb31c736fb25b80ea8b18706544b0e28d4fa703f3135aa

- F:\OpenLeague\crates\client\src\native_hud_learning.rs:19–35 — learning render and action eligibility ; SHA-256 9ae494663305220318cb31c736fb25b80ea8b18706544b0e28d4fa703f3135aa

- F:\OpenLeague\crates\client\src\native_hud_learning.rs:34–47 — learning action path has rank and UI gates ; SHA-256 9ae494663305220318cb31c736fb25b80ea8b18706544b0e28d4fa703f3135aa

- F:\OpenLeague\crates\core\src\progression.rs:150–188 — rank eligibility has no life check ; SHA-256 eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766

- F:\OpenLeague\crates\core\src\lib.rs:598–623 — authoritative command life guard before Learn ; SHA-256 cb2af93a240737ed3f1d3ee31cf4ff916e730f402e7d0b128e7f29e5a3ed004d

- F:\OpenLeague\crates\core\src\spells.rs:101–152 — cast refusal silence and Garen cancel before cooldown ; SHA-256 26fc5175f41325935b7e7ad91d6aba72cf4560b1be97f69f69d70e0dfe0680a5

- F:\OpenLeague\crates\core\src\annie_r.rs:26–61 — Tibbers guide before summon cost cooldown ; SHA-256 508b096ee103dcc4d96dcf8f283a830e40d93c8a6339f6e49f5c5f83dcc2008e

- F:\OpenLeague\crates\client\src\main.rs:1344–1348 — rejection routed to shared diagnostic and pause feedback ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620

- F:\OpenLeague\crates\client\src\session_connection.rs:110–113 — shared rejection diagnostic storage ; SHA-256 fdd81b790bca52dd4e20ca5d34e81d78136f3958ab7028f5ca193d078fb9acd1

- F:\OpenLeague\crates\client\src\session_connection.rs:244–247 — received refusal has context and length gate ; SHA-256 fdd81b790bca52dd4e20ca5d34e81d78136f3958ab7028f5ca193d078fb9acd1

## R4 — Attendu, observé, exécuté

### S1 — common QWER state/palette helper

Méthode : retained native supplied-context vectors and matching-source CPU test, not rerun

Attendu : Keep native arithmetic/palette evidence distinct from production mask/actor provider.

Observé : 384states/192colors retained, test every_executed_native_state_and_palette_case_matches passed in identified run; availability/cooldown/resource suppliers and native masks not fully historical.

Limite : State helper success is not every control active/disabled/refused or framebuffer qualification.

### S2 — Annie E ordinary lifecycle

Méthode : retained actual core+HUD component test

Attendu : Rank0→learned ready→cast cooldown→ready, insufficient resource and death have explicit local states.

Observé : authoritative_annie_learning_cast_and_cooldown_change_hud_state recorded [2;4]→E0→E4→E0, mana0 E5, health0 E3.

Limite : AnnieE only; no122champion schemes, cost modifiers or GUI/OS proof.

### S3 — Garen Q visual ready versus silence refusal

Méthode : source-path comparison only, no new execution

Attendu : Do not equate visual state0 with successful command acceptance.

Observé : For learned/no-CD/alive/nonstunned/enough-base-mana conditions, player_states does not inspect silence_until; cast checks it and returns champion silenced. Target, casting and match guards are separate too.

Limite : Conditional source witness, not a new live failure or instruction to gray every target/range refusal.

### S4 — Annie R guide with summoned Tibbers

Méthode : source comparison plus retained guide test

Attendu : Separate summon cooldown from actionability of guide without refunding resources.

Observé : Generic HUD prioritizes cooldown state4. cast_tibbers routes existing pet to guide before summon CD/mana checks; retained test preserves CD/mana/ownership and accepts guide while stunned.

Limite : Core guide API test, not full UI/slash/transport nor original alternate-spell HUD parity. Native variant/controller remains open.

### S5 — Garen E cancel while Judgment active

Méthode : source comparison plus two retained core tests

Attendu : A cooldown display can coexist with valid cancel; silence refusal preserves active effect and deadline.

Observé : Generic HUD gives4 with remaining cooldown; cast cancels spin before ordinary CD refusal. Recorded judgment_recast test preserves deadline and restores attacks; silenced_judgment test refuses without changing spin/CD.

Limite : Do not zero original cooldown or infer native min-recast/texture binding from this local behavior.

### S6 — Learning visible eligibility and pointer gate

Méthode : retained native32case contract and current geometry/learning component test

Attendu : Separate native sprite flags from rank eligibility and command revalidation.

Observé : flags(!eligible,expanded,false) selects arrow/frame; action_at checks eligible/bounds/winner, normal component learns an eligible slot then refuses once points used.

Limite : Four admitted ordinary rank schemes; unavailable/special schemes remain explicit refusals, not full-champion readiness.

### S7 — LEARN-Q with dead Annie and unspent point

Méthode : conditional source-path comparison only, not executed

Attendu : Name any eligibility/action guard difference without inventing original dead-learning policy.

Observé : maxima/next_rank do not inspect health; with eligible Q and no winner, render/action_at can expose/produce Learn. Simulation.command rejects health<=0 before Learn.

Limite : No live or new CPU dead-learning test; original historical rule unresolved. This is not proof that the original must disable learning while dead.

### S8 — All eight controls: server refusal feedback

Méthode : actual source consumers and bounded signature inspection

Attendu : Keep display state, accepted input, server rejection and public message qualification separate.

Observé : Incoming GameplayRejected validates context/512byte bound, then reports shared reason and pause feedback. QWER render signature/learning flags have no last-rejected-per-slot state.

Limite : No privacy proof for every reason, no transient per-control refusal animation or GUI acceptance; SYS-17.5-05 remains separate.

Sept tests existants réutilisés,11sources actuelles identiques au run retenu :

- native_hud_spells::tests::every_executed_native_state_and_palette_case_matches : attendu ok / observé ok, hérité non rejoué.

- native_hud_spells::tests::authoritative_annie_learning_cast_and_cooldown_change_hud_state : attendu ok / observé ok, hérité non rejoué.

- native_hud_learning::tests::all32_native_enable_branch_cases_match : attendu ok / observé ok, hérité non rejoué.

- native_hud_learning::tests::original_button_geometry_and_real_learning_gate_pointer_actions : attendu ok / observé ok, hérité non rejoué.

- annie_r::tests::guide_keeps_original_cooldown_cost_and_ownership_and_is_allowed_when_stunned : attendu ok / observé ok, hérité non rejoué.

- spell_tests::judgment_recast_cancels_future_damage_preserves_cooldown_and_restores_attacks : attendu ok / observé ok, hérité non rejoué.

- spell_tests::silenced_judgment_recast_is_rejected_without_mutating_active_spin : attendu ok / observé ok, hérité non rejoué.

Journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log SHA-256 e92d1d1fedc29ec650da5fb536364cb29c8bdf02991a0b6782dbd7d3ecef53e3 ; binaire enregistré {"path": "E:\\OpenLeague\\target\\debug\\deps\\openleague_client-170289a4dedad9dd.exe", "sha256": "e2b2227752fb2e4db34a4602284dc6ff7359c393914619d0b502edcefe9aaddd", "bytes": 350254080}

Journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\core_tests.log SHA-256 4d1161dda40d4d56de33399840916146e12d3c321cc8024d91778986b1574c35 ; binaire enregistré {"path": "E:\\OpenLeague\\target\\debug\\deps\\openleague_core-21eb81eb13817108.exe", "sha256": "6e9c5b42549fcf8b434979709ce0e845d4faf554552e6c5c4f3e5251f6da1623", "bytes": 787776512}

Contrat états, catalogue de sorts et navigation correspondent au manifeste du run. Contrat learning identique à la preuve QWER héritée mais non indexé dans ce manifeste : limite conservée. Aucune nouvelle réussite de test, capture GUI, clavier, GPU, serveur ou natif revendiquée. 186contrôles documentaires producteur réussis. Chemin skill_ranks.rs présumé absent, progression.rs réel retrouvé par rg --files; pas de conclusion fonctionnelle tirée de cette erreur de découverte.

## R5 — Manques et reprise du parent

Garder ouverts masques/cost modifiers/ressources/variants et politique native learning mort, contrôle secondaire et feedback par slot. Reprise native sur callback/provider précis de variante HUD, masques ou vie/apprentissage; pas nouveau scan d’icônes ni exécution de palette inchangée. Source-path silence/dead-learning n’est pas un nouveau test exécuté.

- D/F et autres sorts/variantes hors des huit commandes logiques

- objets/vision, contrôles minimap/ping/caméra/pause/abandon/retour et autres contrôles HUD à inventorier depuis listes et consumers réels

- couverture explicite de tous les contrôles, comparaison rendue et politiques natives actif/désactivé/refusé

- SYS-17.5-02..06, autres clauses du parent01 et recette globale du HUD

Le parent SYS-17.5-01 reste ouvert : ces huit commandes ne couvrent pas « chaque contrôle ». La suite doit inventorier les autres contrôles depuis sources et consommateurs, puis réutiliser leurs audits avec comparaisons d’état explicites.

## R6 — Corrections réutilisées et précisions

Aucune fonctionnalité corrigée. Trois définitions existantes réutilisées sans modification : HUD-QWER-RANK-SOURCE-01, HUD-QWER-STATE-RESOURCE-01, HUD-QWER-LEARNING-PANEL-01. Trois profils/écarts distincts précisent ce travail sans ajouter de case au Plan :

### HUD-STATE-ANNIE-R-GUIDE-01 — Qualifier un profil de contrôle distinct pour guider Tibbers.

Travail : Identifier la variante/controller d’état original et distinguer disponibilité guide, recharge invocation et mana. ; Préserver cooldown/mana/ownership et refus silence/portée/pet absent; ne pas remplacer la recharge invocation par zéro.

Critères de fin proposés : États guide/invocation et refus comparés à source/contrat explicite et rendu réellement observé. ; Tests core existants restent verts sur sources identifiées; un indicateur/action approprié ne prétend pas terminer tout Annie.

Condition de reprise : Nouveau callback/variant de sort HUD original nommé ou règle locale explicite; autorisation produit distincte.

Dépendances : HUD-QWER-STATE-RESOURCE-01. État proposed_not_applied.

### HUD-STATE-GAREN-E-CANCEL-01 — Qualifier le profil d’état du contrôle Judgment/cancel.

Travail : Relier variante cancel, silence et délai d’origine au même slot sans effacer sa recharge. ; Comparer action secondaire possible et feedback de refus; conserver cadence, pulses et retour attaques du core actuel.

Critères de fin proposés : Pendant spin, hors spin et sous silence les états/actions/refus ont résultat documenté et comparé sur le vrai contrôle. ; Aucune réduction/reset de cooldown pour simuler readiness; timing natif non prouvé reste explicite.

Condition de reprise : Contrôleur HUD/callback GarenECancel ou contrat local déclaré, autorisation produit et scène reproductible.

Dépendances : HUD-QWER-STATE-RESOURCE-01. État proposed_not_applied.

### HUD-STATE-LEARN-DEAD-01 — Qualifier la cohérence de l’apprentissage pendant la mort.

Travail : Établir règle historique ou décision locale explicite pour affichage/commande Learn quand health<=0 et rang/points admissibles. ; Conserver garde serveur et code UI actuels avant décision; comparer disponibilité, envoi, refus et absence de mutation, sans déduire la règle native de la boutique.

Critères de fin proposés : Cas Q à point non dépensé mort/vivant, puis autres slots admissibles, vérifiés selon contrat nommé et rendus sans succès fictif. ; Si différence autorisée entre affordance et commande, feedback/refus documenté; sinon consumer corrigé sous autorisation produit et régression pertinente exécutée.

Condition de reprise : Nouvelle source/trace originale du learning-state/life policy ou contrat local accepté; autorisation produit distincte.

Dépendances : HUD-QWER-LEARNING-PANEL-01, SYS-17.5-05. État proposed_not_applied.

Les observations prêt/refusé ou cooldown/recast n’autorisent ni recoloriage universel ni modification du serveur historique sans source. Réutiliser le découpage source/resource/learning déjà établi, pas créer un chantier global de toutes les interfaces.

## R7 — Livraison et conservation

Nouveaux fichiers uniquement : audit-unit.json, verify_qwer_learning_states.py, qwer-learning-states-proof.json, ce rapport, verify_delivery.py et delivery-readback.json. Relecture peut fermer le sous-lot; parent_documentary_scope_closed=false doit rester explicite.19fichiers logiciels gelés +6documents, cinq registres normatifs et Git suivi inchangés. Aucun goal/critère normatif, produit, tracker/UI ou base modifié; aucune base ouverte, installation, migration, relance, suppression ou écrasement.

Preuve principale F:\OpenLeague-work\audit-units\AUD-17.5-01-QWER-LEARNING-STATES-01\qwer-learning-states-proof.json SHA-256 0f7239f495a3725b1e4dc8a90b0a9f037ef762eb8e648831645318768cb9ed19 ; relecture F:\OpenLeague-work\audit-units\AUD-17.5-01-QWER-LEARNING-STATES-01\delivery-readback.json. Preuves antérieures, erreurs et limites conservées.
