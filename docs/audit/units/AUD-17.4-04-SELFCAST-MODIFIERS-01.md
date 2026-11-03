# AUD-17.4-04-SELFCAST-MODIFIERS-01 — lancement sur soi et modificateurs

Lot documentaire SYS-01.2-02 : SYS-17.4-04 / OLF-7d5673b3-8e78-5446-831f-05ffd51d5849. Audit clos uniquement après relecture indépendante R1–R7. Fonctionnalité non terminée, jeu et goal global non terminés, acceptation humaine non donnée.

## R1 — Périmètre et prérequis

Objectif : Gérer le lancement sur soi et les modificateurs de ciblage. État a_faire conservé, implementation_complete=false et acceptance_complete=false. Inconnue OLU-a410264e-afd4-5fd1-95f3-cdb0e636510b open. Lot D17-SYS-17-4 dépend de D09-SYS-09-4, toujours a_faire; audit permis sans déclarer le prérequis fonctionnel fini. Aucun critère normatif modifié.

Le lot précédent de portée est clos documentairement (reçu épinglé), pas fonctionnellement; ses488sources et profils de portée sont réutilisés sans nouvelle recherche de géométrie/textures ni import PE/REA.

## R2 — Sources natives et limites

### native_defaults

D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\defaults\Input.ini ; SHA-256 930f1499991e9c4973e81086a26c944b7330058970c4227a614b897eae09fec1. 331champs relus, sections/clés/valeurs/lignes identiques à la preuve retenue.

- L295 [DisableKeys] disableLinkedModifers=0

- L302 [ModifierEvents] evtShiftL=[L Shift]

- L303 [ModifierEvents] evtShiftR=[R Shift]

- L304 [ModifierEvents] evtCtrlL=[L Ctrl]

- L305 [ModifierEvents] evtCtrlR=[R Ctrl]

- L306 [ModifierEvents] evtAltL=[L Alt]

- L307 [ModifierEvents] evtAltR=[R Alt]

- L308 [ModifierEvents] evtCmd=[Cmd]

- L309 [ModifierEvents] evtFn=[Fn]

- L324 [GameEvents] evtSelfCastSpell1=[Alt][q]

- L325 [GameEvents] evtSelfCastSpell2=[Alt][w]

- L326 [GameEvents] evtSelfCastSpell3=[Alt][e]

- L327 [GameEvents] evtSelfCastSpell4=[Alt][r]

- L328 [GameEvents] evtSelfCastAvatarSpell1=[Alt][d]

- L329 [GameEvents] evtSelfCastAvatarSpell2=[Alt][f]

- L339 [GameEvents] evtSmartPlusSelfCastSpell1=[<Unbound>]

- L340 [GameEvents] evtSmartPlusSelfCastSpell2=[<Unbound>]

- L341 [GameEvents] evtSmartPlusSelfCastSpell3=[<Unbound>]

- L342 [GameEvents] evtSmartPlusSelfCastSpell4=[<Unbound>]

- L343 [GameEvents] evtSmartPlusSelfCastAvatarSpell1=[<Unbound>]

- L344 [GameEvents] evtSmartPlusSelfCastAvatarSpell2=[<Unbound>]

- L354 [GameEvents] evtSelfCastItem1=[Alt][1]

- L355 [GameEvents] evtSelfCastItem2=[Alt][2]

- L356 [GameEvents] evtSelfCastItem3=[Alt][3]

- L357 [GameEvents] evtSelfCastVisionItem=[Alt][4]

- L358 [GameEvents] evtSelfCastItem4=[Alt][5]

- L359 [GameEvents] evtSelfCastItem5=[Alt][6]

- L360 [GameEvents] evtSelfCastItem6=[Alt][7]

- L414 [GameEvents] evtPetMoveClick=[Alt] [Button 2], [Ctrl] [Button 2]

- L415 [GameEvents] evtPetReturn=[Alt] [Button 1]

### supplied_deploy_override

D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\cfg\input.ini ; SHA-256 aead4280d339159623dbe8f39784bde4b87a6b05afc6d95f2feccec7ba99073a. 13champs relus, sections/clés/valeurs/lignes identiques à la preuve retenue.

### user_configuration_not_historical_default

D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\Config\input.ini ; SHA-256 fa16e719b04249006b3ab7c77f7810e728d3743faf82e86cb259b6cc96d0a531. 27champs relus, sections/clés/valeurs/lignes identiques à la preuve retenue.

- L24 [GameEvents] evtSelfCastSpell3=[Alt][e]

- L25 [GameEvents] evtSelfCastSpell4=[Alt][r]

- L27 [GameEvents] evtSelfCastSpell1=[Alt][q]

- L28 [GameEvents] evtSelfCastSpell2=[Alt][w]

Défauts : 13raccourcis self avec Alt, six smart-plus-self [<Unbound>], huit événements modificateurs. evtPetMoveClick=[Alt] [Button 2], [Ctrl] [Button 2]; evtPetReturn=[Alt] [Button 1]. Orthographe native disableLinkedModifers=0 conservée. Cela ne prouve ni priorité, ni AltGr, ni correspondance OS des boutons; ne pas inventer une sémantique PetReturn=Recall/Follow. Configuration utilisateur distincte des défauts historiques. Les modes Quickbinds et release sont déjà traités par02, aucune réinterprétation QuickBindMode.

Les488INIBIN déjà épinglés sont relus uniquement pour Flags, TextFlags et TargettingType. Flags présents487, TextFlags478, TargettingType488; zéro écart catalogue après normalisation du mot32bits. ZileanR : décodeur signé -2147415804, catalogue2147551492, même 0x80010904 : différence de représentation résolue, pas corruption. Flags absent pour HeimerdingerW; TextFlags absents pour Azir/0, Azir/1, Azir/2, Azir/3, Gangplank/3, Lucian/0, Quinn/1, Quinn/3, Thresh/2, Xerath/3. Absents conservés inconnus, aucun zéro substitué.

AlwaysSelf apparaît182fois, NotAffectSelf31, Instacast233. EzrealQ/W contiennent AlwaysSelf et TargettingType6 mais le consumer actuel exige un point au sol. Ne pas déduire self éligible de ces seuls tokens ou type. Source authoring et destinataire effectif sont distincts. Aucun decoder sémantique natif des flags exécuté. Aucune nouvelle qualification de manifeste sur488fichiers : seuls les13cas précis hérités le sont; provider/précédence historique restent ouverts.

PE original identifié, non exécuté : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe ; SHA-256 402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862. Matrice F:\OpenLeague-work\audit-units\AUD-17.4-04-SELFCAST-MODIFIERS-01\native-selfcast-matrix.json.

## R3 — Consommateurs réels

Corpus1168fichiers actuel inchangé. Shortcuts enregistre slot/learn et Ctrl au keydown; Alt/Shift ne produisent aucune intention self. Les sept tests ordonnés couvrent ce Ctrl local, pas le selfcast. Main lit AltLeft/Right en fin de frame pour pet_control+clic droit, exige Annie et pet vivant/non expiré, puis CastAt slot3. Ctrl+[Button2] et Alt+[Button1] PetReturn n’ont pas de branche qualifiée dans commands inspecté. Un chord Alt entièrement relâché avant cette lecture n’est pas représenté par cette condition; constat de flux, pas test physique exécuté.

Picker ennemi exclut alliés; picker Heal allié exclut propriétaire. Heal.target désigne un allié secondaire : target==owner refuse, recipients=once(owner).chain(ally) soigne déjà owner. Un remplacement universel target=Some(owner) serait incorrect. Barrier, AnnieE et buffs Garen agissent sur owner par gameplay; ils ne prouvent aucun raccourci Alt. UseItem(owner,slot) ne propose qu’effets de potions ici, avec refus active non implémenté; ce n’est pas tous les objets/vision ciblés. Ezreal requiert point au sol et autres champions non implémentés gardent refus explicites. Aucune obligation de nouvel enum réseau inventée : adapter dans le consumer réel selon profil.

- F:\OpenLeague\crates\client\src\spell_input.rs:1–58 — ordered Ctrl learning not self intent ; SHA-256 2f99cb617bfd218da8d8125fcf65fbfea34eb602391899547cf065c758eadccf.

- F:\OpenLeague\crates\client\src\main.rs:1381–1394 — command gate and Alt-only pet path ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:1394–1438 — summoner dispatch distinguishes secondary ally ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\main.rs:1439–1501 — fixed item summoner spell and ground dispatch ; SHA-256 eba4e38b4c5c244426e74feeb70ed351e9cddcb58e2507cfcd1bfc771dc4b620.

- F:\OpenLeague\crates\client\src\picking.rs:42–111 — enemy and secondary ally pickers ; SHA-256 8415d4f86ca72c31484f1a9bf3df3faa94fcfb7cda4c684cc0c0bc30295bb2cb.

- F:\OpenLeague\crates\core\src\lib.rs:279–301 — current protocol action choices ; SHA-256 cb2af93a240737ed3f1d3ee31cf4ff916e730f402e7d0b128e7f29e5a3ed004d.

- F:\OpenLeague\crates\core\src\spells.rs:101–121 — ground and unsupported spell refusals ; SHA-256 26fc5175f41325935b7e7ad91d6aba72cf4560b1be97f69f69d70e0dfe0680a5.

- F:\OpenLeague\crates\core\src\spells.rs:157–174 — Garen self effects are gameplay ; SHA-256 26fc5175f41325935b7e7ad91d6aba72cf4560b1be97f69f69d70e0dfe0680a5.

- F:\OpenLeague\crates\core\src\annie.rs:22–56 — Annie E self effect and dispatch ; SHA-256 cc03328f3151a3ef7a1b777249df7885b1cfc313de57a012e82bf81b89ca4f31.

- F:\OpenLeague\crates\core\src\annie_r.rs:26–61 — pet guide ownership range and orders ; SHA-256 508b096ee103dcc4d96dcf8f283a830e40d93c8a6339f6e49f5c5f83dcc2008e.

- F:\OpenLeague\crates\core\src\summoners.rs:44–87 — summoner own recipient dispatch ; SHA-256 7af19297380715624cb37f70ab62dfa9a65f7c8665e49b7699ee495d7a0d56a3.

- F:\OpenLeague\crates\core\src\summoner_heal.rs:33–84 — Heal secondary ally explicitly excludes owner ; SHA-256 e7d80ecc10f4a119efaf1b7581e2ef4cf66d50b0b606dd9ddb406e65e6d68ac5.

- F:\OpenLeague\crates\core\src\consumables.rs:8–24 — item API has owner and slot with unsupported refusal ; SHA-256 984ee7042fe5f1a82d15a80689f9022d9a4afa3e7d6f92e16adc3e37e340c6c6.

Recherche bornée evtSelfCast|evtSmartPlusSelfCast|\bself_cast\b|\bSelfCast\b : zéro correspondance dans1168sources Rust/JS/HTML, complétée par les flux réels ci-dessus. Cette absence lexicale ne prouve pas l’absence universelle dans les binaires externes.

## R4 — Attendu, observé et contrôles

14tests CPU réussis réutilisés,11fichiers sources actuels identiques au run avancé : 7Ctrl ordonné,1picker Heal,2Heal core,1AnnieE et3Tibbers. Aucun test rejoué. Journaux terminaux code0, anciens états en cours conservés avec retours finaux observés. Identités des binaires de test enregistrées dans la preuve, pas vérification/réexécution de ces anciens chemins binaires aujourd’hui.

- core_tests journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\core_tests.log SHA-256 4d1161dda40d4d56de33399840916146e12d3c321cc8024d91778986b1574c35 ; binaire enregistré {"path": "E:\\OpenLeague\\target\\debug\\deps\\openleague_core-21eb81eb13817108.exe", "sha256": "6e9c5b42549fcf8b434979709ce0e845d4faf554552e6c5c4f3e5251f6da1623", "bytes": 787776512}.

- client_tests journal E:\mapslol3v3\Ezreal_E_arrival_heads_pause_Q_flash_fresh_runtime_qualification_v2\runs\2b178615c12a425aa4ca644f4985fa43\client_tests.log SHA-256 e92d1d1fedc29ec650da5fb536364cb29c8bdf02991a0b6782dbd7d3ecef53e3 ; binaire enregistré {"path": "E:\\OpenLeague\\target\\debug\\deps\\openleague_client-170289a4dedad9dd.exe", "sha256": "e2b2227752fb2e4db34a4602284dc6ff7359c393914619d0b502edcefe9aaddd", "bytes": 350254080}.

- summoner_heal::tests::explicit_ally_range_enemy_dead_and_unknown_fail_without_cooldown_or_health_changes — attendu ok / observé ok, hérité non rejoué.

- summoner_heal::tests::heal_restores_owner_and_one_wounded_ally_with_native_speed_and_historical_cooldown — attendu ok / observé ok, hérité non rejoué.

- annie::tests::molten_guards_are_atomic_and_cdr_changes_cooldown_only — attendu ok / observé ok, hérité non rejoué.

- annie_r::tests::guide_keeps_original_cooldown_cost_and_ownership_and_is_allowed_when_stunned — attendu ok / observé ok, hérité non rejoué.

- annie_r::tests::pet_ai_attacks_after_native_windup_and_command_cancels_without_resetting_recovery — attendu ok / observé ok, hérité non rejoué.

- annie_r::tests::tibbers_follow_range_filters_and_explicit_move_remain_bounded — attendu ok / observé ok, hérité non rejoué.

- picking::heal_target_tests::heal_cursor_targets_living_ally_in_range_and_never_enemy_or_self — attendu ok / observé ok, hérité non rejoué.

- spell_input::ordered_shortcut_tests::complete_control_e_chord_in_one_frame_keeps_keydown_modifier — attendu ok / observé ok, hérité non rejoué.

- spell_input::ordered_shortcut_tests::focus_reset_removes_stale_modifier_and_intent — attendu ok / observé ok, hérité non rejoué.

- spell_input::ordered_shortcut_tests::held_modifier_across_frames_and_both_controls_are_preserved — attendu ok / observé ok, hérité non rejoué.

- spell_input::ordered_shortcut_tests::later_control_or_already_released_control_cannot_convert_cast_to_learn — attendu ok / observé ok, hérité non rejoué.

- spell_input::ordered_shortcut_tests::other_shortcuts_are_not_consumed_and_slot_precedence_is_unchanged — attendu ok / observé ok, hérité non rejoué.

- spell_input::ordered_shortcut_tests::repeated_keydown_and_frame_gate_do_not_replay_an_intent — attendu ok / observé ok, hérité non rejoué.

- spell_input::ordered_shortcut_tests::bevy_collector_keeps_message_order_without_consuming_other_readers — attendu ok / observé ok, hérité non rejoué.

### S1 — Contrat des touches natif

Attendu : Identifier défauts, overrides et événements sans inventer la priorité.

Observé : 13raccourcis self avec Alt,6smart-plus-self non affectés,8modificateurs,2événements pet et disableLinkedModifers=0. UserConfig4self distinct du défaut.

Limite : Noms de touches/boutons, pas preuve du dispatch OS ou du consommateur de priorité.

### S2 — Ordre Ctrl et focus

Attendu : Apprentissage garde le modificateur au keydown, sans replay.

Observé : Sept tests ordered_shortcut passés dans run identifié; source actuelle identique. Shortcut ne contient que slot/learn.

Limite : Ctrl apprentissage qualifié localement; ni self Alt ni smart-plus-self qualifiés.

### S3 — Sélection sur soi

Attendu : Intention self choisit la cible ou le point requis par capacité.

Observé : Pas de resolver générique identifié; enemy picker exclut alliés, ally picker Heal exclut propriétaire. Ezreal exige point au sol, autres champions non pris en charge refusés.

Limite : Recherche lexicale bornée et flux réel inspectés; pas absence universelle ni test GUI actuel.

### S4 — Heal et effets propres

Attendu : Préserver signature du consumer et ne pas confondre effet auto-propriétaire avec raccourci.

Observé : Heal target est allié secondaire; target==owner refuse, recipients inclut toujours owner. AnnieE et Garen ont effets propres au lanceur. Deux tests Heal et un AnnieE réutilisés.

Limite : Some(owner) universel serait incorrect; ces effets ne démontrent pas AltD/F ou AltE.

### S5 — Commandes du familier

Attendu : Distinguer Alt/Ctrl Button2 et PetReturn Button1, routage temporel sûr.

Observé : Main utilise AltLeft/Right maintenu en fin de frame+RMB et pet Annie vivant; guide_tibbers respecte ownership/coût/CD selon trois tests hérités.

Limite : CtrlButton2 et PetReturn sans branche qualifiée dans commands; chord Alt relâché dans la frame non capturé par cette condition; pas de nouveau test OS.

### S6 — Objets

Attendu : Qualifier sixslots et vision par objet/active réel.

Observé : Main sixslots fixes→UseItem(slot). Core potions owner-only et refus slot/active/ressource explicites.

Limite : Ni vision self ni objets ciblés complets; aucune nouvelle exécution potions revendiquée.

### S7 — Champs natifs et représentation

Attendu : Conserver valeurs manquantes et bits, sans inventer une règle.

Observé : 488sources, Flags487,TextFlags478,TargettingType488. ZileanR i32 -2147415804/catalog2147551492 même mot0x80010904. AlwaysSelf182 inclut EzrealQ/W type6.

Limite : Flags absent HeimerdingerW et10TextFlags absents restent inconnus, pas zéros; aucun flag semantic decoder natif.

### S8 — Ciblage rapide ou sur soi

Attendu : Qualifier éligibilité/repli et interaction normal/rapide sur preuve.

Observé : Six événements natifs sans touche affectée par défaut; modes/persistance/preview demeurent dans lots liés.

Limite : Unbound ne signifie pas implémentation absente dans jeu original; pas de handler/repli natif qualifié.

### S9 — UI, refus et conflit

Attendu : Aucune commande sur capture/focus/fin/session ou cible invalide selon contrat.

Observé : Gates inventaire/shop/ready/winner et reset focus de Shortcuts présents; refus Heal owner/ennemi/mort/horsportée et garde AnnieE testés par preuves retenues.

Limite : Shop gate ne prouve pas chat; AltGr, mapping physique, captures et selfresolver de bout en bout restent ouverts.

734contrôles documentaires producteur réussis. Nouvelles opérations : relecture sources/INI, trois champs INIBIN et comparaison identités/journaux. Non exécutés : Rust/tests, jeu, binaire original, REA, SQL/base, OS/clavier physique, GPU/réseau ou parcours GUI. Tests composants existants ne prouvent pas lancement sur soi complet.

## R5 — Manques et reprise

Restent ouverts : resolver self/smart-plus-self, éligibilité/repli par capacité, dispatch AltD/F/objets/vision, Ctrl pet/PetReturn, ordre souris/modificateurs, linked-modifiers/AltGr, captures UI et qualification physique. Données manquantes nommées ci-dessus. Reprise native seulement avec callback/xref/trace original discriminant de evtSelfCast/evtSmartPlusSelfCast/evtPetReturn ou getter Flags/TargettingType; ne pas relancer un import complet du PE ni répéter le scan488sans piste nouvelle. Pour prouver le raccourci, il faut une capacité où owner/autre cible diffèrent, sourcée et implémentée; AnnieE/Garen buffs/Heal auto-owner sont insuffisants. L’inconnue demeure open.

## R6 — Corrections atomiques proposées, non appliquées

Aucun écart fonctionnel corrigé. Neuf définitions existantes réutilisées sans modification : BIND-SPELL-DISPATCH-01, BIND-ITEM-DISPATCH-01, BIND-EDIT-CONFLICTS-01, BIND-NATIVE-PROVIDER-01, CAST-MODE-MODEL-01, CAST-MODE-ABILITY-01, CAST-MODE-RELEASE-01, PREVIEW-INTENT-01, PREVIEW-CONFIRM-CANCEL-01. Huit objectifs complémentaires ci-dessous; critères documentaires de reprise, aucun remplacement des critères normatifs du goal/Plan.

### SELF-INTENT-RESOLVE-01 — Résoudre une intention de ciblage et les modificateurs dans l’ordre des entrées.

Tâches existantes : SYS-17.4-01, SYS-17.4-02, SYS-22.3-03.

Travail : Distinguer normal, rapide, sur soi et rapide-ou-soi selon politique prouvée et touches configurées; garder Ctrl apprentissage. ; Définir priorité des modificateurs gauche/droite, événements d’une même frame et entrée capturée; ne pas lire Alt seulement en fin de frame.

Critères de fin proposés : Cas appui/relâchement dans une frame, repeat, deux modificateurs et priorité reproduits sans réécriture rétroactive ni double action. ; Intention observable vers consumer réel; absence de règle native reste contrat local explicite.

Condition de reprise : Autorisation produit distincte; mappings et contrat original/priorité identifiés.

Dépendances : BIND-SPELL-DISPATCH-01, CAST-MODE-MODEL-01, SELF-NATIVE-DISPATCH-01. État proposed_not_applied.

### SELF-ABILITY-ADAPTER-01 — Adapter le ciblage sur soi au consumer de chaque capacité applicable.

Tâches existantes : SYS-04.6-01, SYS-04.6-02.

Travail : Utiliser les profils SELFCAST-PROFILE par capacité; séparer destinataire, origine, zone centrée et point au sol. ; Résoudre vers Cast/CastAt ou contrat nécessaire sans imposer Some(owner) partout; conserver les sorts non implémentés en refus.

Critères de fin proposés : Un cas éligible discriminant propriétaire/autre cible et les cas non éligibles aboutissent au comportement attendu. ; Coût/cooldown/état restent atomiques sur refus; AlwaysSelf/TargettingType seuls ne valident aucune éligibilité.

Condition de reprise : Autorisation produit; consumer et règle de la capacité choisis disponibles.

Dépendances : SELF-INTENT-RESOLVE-01, SELF-NATIVE-DISPATCH-01. État proposed_not_applied.

### SELF-SUMMONER-ADAPTER-01 — Définir le ciblage sur soi de D/F par sort d’invocateur.

Tâches existantes : SYS-04.6-01, SYS-17.4-01.

Travail : Respecter slot/loadout, cible secondaire de Heal et effet déjà propre à Barrier. ; Établir séparément sorts ciblant ennemi, point et soi, et la règle de rapide-ou-soi non affecté par défaut.

Critères de fin proposés : Heal conserve propriétaire plus au maximum un allié valide; Some(owner) ne remplace pas son argument secondaire. ; Chaque sort applicable qualifié par résultat/cooldown/refus, les autres explicitement ouverts.

Condition de reprise : Autorisation produit, règles des sorts sélectionnés et entrée AltD/F disponible.

Dépendances : SELF-INTENT-RESOLVE-01. État proposed_not_applied.

### SELF-ITEM-ADAPTER-01 — Qualifier le ciblage sur soi des six objets et du slot de vision.

Tâches existantes : SYS-17.4-01, SYS-04.6-02.

Travail : Conserver distinction native item1..6 et vision4; relier objets réellement utilisables à UseItem/contrat ciblé approprié. ; Réutiliser refus potions pleines, slot vide et active non implémenté; ne pas présenter les potions owner-only comme tous les objets actifs.

Critères de fin proposés : Chaque objet traité possède règle d’éligibilité et cas nominal/refus; aucune cible propriétaire forcée dans une API incompatible. ; Vision et six slots ne se décalent pas après remap; objet non pris en charge reste explicitement indisponible.

Condition de reprise : Autorisation produit, objet/active concret et sa source/consumer identifiés.

Dépendances : BIND-ITEM-DISPATCH-01, SELF-INTENT-RESOLVE-01. État proposed_not_applied.

### SELF-PET-INPUT-01 — Qualifier les deux modificateurs de déplacement du familier et son retour.

Tâches existantes : SYS-17.4-05.

Travail : Préserver Alt+clic droit existant; qualifier Ctrl+[Button2] et Alt+[Button1] evtPetReturn depuis handler/trace original. ; Ne pas confondre retour avec recall/follow sans preuve; lier propriétaire, pet vivant, durée, silence et commande unique.

Critères de fin proposés : Événements complets et touches relâchées dans une frame routés correctement sans Move/Attack accidentel du champion. ; Alt/Ctrl déplacement et retour ont chacun cas attendu/observé; pet absent/expiré/autre propriétaire refuse sans changer coût/cooldown.

Condition de reprise : Autorisation produit; sémantique originale PetReturn et correspondance bouton/OS identifiées.

Dépendances : SELF-INTENT-RESOLVE-01, SELF-NATIVE-DISPATCH-01. État proposed_not_applied.

### SELF-FOCUS-CONFLICT-01 — Préserver focus et captures UI sur les entrées de ciblage.

Tâches existantes : SYS-17.4-08, SYS-22.3-01, SYS-22.3-02.

Travail : Réutiliser reset focus Ctrl existant pour la nouvelle intention et les combinaisons souris/modificateur. ; Qualifier chat, shop, inventaire, minimap, fenêtre/session, changement de mode et AltGr sans supposer le gate shop couvre chat.

Critères de fin proposés : Aucune commande de combat pendant capture ni replay après retour focus/session. ; AZERTY/QWERTY et AltGr gardent texte/modificateurs distincts; aucun cas physique qualifié sur le seul test injecté.

Condition de reprise : Autorisation produit, intention et surfaces de capture disponibles.

Dépendances : SELF-INTENT-RESOLVE-01, SYS-17.4-08. État proposed_not_applied.

### SELF-NATIVE-DISPATCH-01 — Qualifier les handlers historiques self/smart-plus-self et priorité des modificateurs.

Tâches existantes : SYS-04.6-01, SYS-17.4-01.

Travail : Suivre événements evtSelfCast*, evtSmartPlusSelfCast*, evtPetMoveClick/Return vers callback/provider réel; obtenir lecture Flags/TargettingType et comportement cible absente. ; Relier disableLinkedModifers=0 et modificateurs L/R à leur consommateur; ne pas importer à nouveau le PE entier sans entrée ciblée nouvelle.

Critères de fin proposés : Handler/caller/trace nommé démontre priorité et règle d’éligibilité/repli; chaîne configuration→événement→consumer tracée. ; Si donnée native absente, champ exact et source de reprise identifiés; aucun contrat universel inventé.

Condition de reprise : Nouveau callback/xref/trace original discriminant; corpus/configurations déjà épinglés.

Dépendances : Nouvelle entrée native discriminante. État proposed_not_applied.

### SELF-QUALIFY-01 — Qualifier un parcours réel discriminant de lancement sur soi.

Tâches existantes : SYS-04.6-01, SYS-22.3-01, SYS-22.3-02.

Travail : Choisir une capacité implémentée où viser propriétaire ou autre unité donne des résultats différents; un simple buff Garen/AnnieE ou Heal auto-propriétaire est insuffisant. ; Identifier source/binaire/assets, observer touche, intention, cible, résultat et refus; distinguer tests CPU injectés de clavier réel.

Critères de fin proposés : Parcours normal/autre cible et sur soi comparés; ressource/cooldown/état, annulation, focus et cibles invalides vérifiés. ; Aucune qualification globale de488sorts à partir d’un seul parcours; capacité discriminante manquante reste prérequis ouvert.

Condition de reprise : Autorisation produit; une capacité discriminante et son adapter sont implémentés et sourcés.

Dépendances : SELF-ABILITY-ADAPTER-01, SELF-FOCUS-CONFLICT-01. État proposed_not_applied.

Découpage par capacité :488IDs SELFCAST-PROFILE-<champion>-<slot>, chacun avec sa source, champs présents/absents, profil de portée déjà existant et gabarit per_ability_profile_template. Exemple SELFCAST-PROFILE-ezreal-0 et SELFCAST-PROFILE-annie-2. Applicabilité undetermined_not_inferred_from_flags pour tous; aucun sort éligible/non applicable décrété par les tokens. Ce sont des décisions de qualification proposées, pas488fonctionnalités terminées ni nouvelles cases du Plan. Critères communs : Décision applicable/non applicable étayée par source/handler/trace nommé et cas attendu/observé propre au sort. ; Si applicable, cas discriminant propriétaire contre autre cible et refus limites, une seule commande correcte, coûts/cooldown/état et focus préservés. ; Absence de champ et comportement non qualifié restent explicites; un buff auto-centré ne prouve pas le raccourci.. Reprise : Autorisation produit distincte; contrat de ciblage et consumer de cette capacité disponibles; sinon nouveau handler/getter/trace nommé.

- SYS-04.6-01 / OLF-b4b63c0d-2b5a-5a76-b054-952302efb33b — Valider les filtres allié, ennemi, neutre et soi-même : a_faire conservé.

- SYS-04.6-02 / OLF-2c3307f8-7f3d-5b52-881f-9af92ce7b07b — Valider les cibles champion, sbire, monstre, structure et invocation : a_faire conservé.

- SYS-17.4-01 / OLF-c010ba18-c9b6-59ab-b3a5-5b933320684a — Persister les raccourcis de capacités et d’objets : a_faire conservé.

- SYS-17.4-02 / OLF-4e001528-e50b-579e-ae58-e6eb088040f5 — Persister les modes de lancement normal et rapide : a_faire conservé.

- SYS-17.4-03 / OLF-dfcf608b-5420-5a99-9456-47574b64d7f5 — Afficher les indicateurs de portée avant confirmation : a_faire conservé.

- SYS-17.4-05 / OLF-ade7b0e7-dee1-5e67-93ad-61a4ec86b2f9 — Gérer attaque-déplacement et sélection de champions uniquement : a_faire conservé.

- SYS-17.4-08 / OLF-f51fd482-c241-572e-a85e-10ecbe4003f3 — Empêcher les saisies de chat de déclencher des commandes de combat : a_faire conservé.

- SYS-22.3-01 / OLF-0098ca59-c07c-5c08-8536-f625cd4b3108 — Qualifier les touches par défaut sur clavier AZERTY : a_faire conservé.

- SYS-22.3-02 / OLF-e4793690-95a5-5851-9597-a954b69c6d72 — Qualifier les touches par défaut sur clavier QWERTY : a_faire conservé.

- SYS-22.3-03 / OLF-15336c59-7be4-5185-bc82-df51d624e3ec — Remapper une touche et gérer les conflits de raccourcis : a_faire conservé.

- SYS-22.3-07 / OLF-90c2f811-c684-5d29-9eb5-2e7311b590d3 — Conserver les réglages d’entrée après relancement : a_faire conservé.

## R7 — Livraison et conservation

Nouveaux fichiers uniquement : audit-unit.json, verify_selfcast_modifiers.py, native-selfcast-matrix.json, selfcast-modifiers-proof.json, ce rapport, verify_delivery.py et delivery-readback.json. Producteur audit_scope_closed=false; seule relecture R1–R7 permet clôture documentaire du parent. Fonctionnalité, goal global et acceptation restent ouverts.

19fichiers logiciels gelés +6documents de contexte/méthode et cinq registres normatifs inchangés; Git suivi identique. Aucun goal/critère normatif, produit, tracker/interface ou base modifié; aucune base ouverte, installation, migration, redémarrage, suppression ou écrasement. Preuves antérieures et essais échoués conservés. Preuve principale F:\OpenLeague-work\audit-units\AUD-17.4-04-SELFCAST-MODIFIERS-01\selfcast-modifiers-proof.json SHA-256 08a496f010bdaf36bf1aeaae1128b77918181c68a08fb3d309c08b3c01e40138; relecture F:\OpenLeague-work\audit-units\AUD-17.4-04-SELFCAST-MODIFIERS-01\delivery-readback.json.
