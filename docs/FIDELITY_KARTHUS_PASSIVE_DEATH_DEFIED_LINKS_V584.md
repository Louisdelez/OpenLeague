# Karthus — sources et consommateurs du passif, V584

Date UTC : 2026-10-26T04:07:53.333425+00:00. Projet `F:/OpenLeague`. Tâche **SYS-01.2-02** : relier chaque exigence à une source native et à son consommateur actuel.

## Résultat

Trois fiches Karthus reliées à **27 sources natives ordinaires**, **81 associations** et **21 points du code**, soit **42 liens** pour contrat/simulation. Quatre sources de preuves ajoutées. Statuts, critères, trois inconnues propres, quatre dépendances et propriétaires des questions conservés.

**Le moteur refuse les sorts de Karthus vivant et mort.** La référence décrit sept secondes de lancement gratuit après des dégâts mortels. Les scénarios publics vérifient cette limite actuelle, les morts et réapparitions ordinaires ; ils ne qualifient pas le passif. Aucun code de gameplay ou asset n’est modifié par ce lot de traçabilité.

## Sources natives

Référence PUBLIC 4.20.0.315, EUW/en_GB, build littéral 2014-11-17 à 17:46:45 ; fuseau et date de déploiement inconnus. Catalogue 4.20.1 distinct. Identités taille/SHA-256 et appartenance RADS sélectionnée vérifiées sur D: ; appartenance ne prouve pas priorité historique de montage.

| Fichier | Source enregistrée |
|---|---|
| Karthus.inibin | OLS-9df27739-a10f-57cb-b52d-f21be2744202 |
| fontconfig_en_GB.txt | OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d |
| CharScriptKarthus.luaobj | OLS-26c8c252-d167-5567-8540-a9b7c79fe6b2 |
| CharScriptKarthus.preload | OLS-0277505d-ad3c-5d8b-9dea-79a6190d3067 |
| Death Defied.inibin | OLS-ac04fd1c-dce8-57e4-b3fc-203de08f68ee |
| Death Defied Buff.inibin | OLS-afcc88ca-a36e-5e10-b45a-ad54b49e6a75 |
| KarthusDeathDefiedBuff.inibin | OLS-f0ee4a96-4805-5509-9f14-da459c84b780 |
| KarthusDeathDefiedBuff.luaobj | OLS-ff297ed0-507c-5afb-b5dc-b1a9ee87dbf4 |
| KarthusDeathDefiedBuff.preload | OLS-9b3d35e5-6864-5716-8937-309b4426d847 |
| KarthusLayWasteDeadA1.inibin | OLS-f8225743-d8ba-5b83-96b6-f7cd9b9a6584 |
| KarthusLayWasteDeadA1.luaobj | OLS-b27f0be3-8671-5f46-a457-7a9f3877a302 |
| KarthusLayWasteDeadA1.preload | OLS-6b79cb32-27f6-59ea-89ca-27723ae5b12e |
| KarthusLayWasteDeadA2.inibin | OLS-255b7c7b-2ed0-5bf5-b9c3-2b0c4d286aef |
| KarthusLayWasteDeadA2.luaobj | OLS-1ac15ee0-224a-5e35-92bc-0575738feef6 |
| KarthusLayWasteDeadA2.preload | OLS-02b75c91-a859-52b1-95a0-2bc513b44f96 |
| KarthusLayWasteDeadA3.inibin | OLS-301d51d2-3f79-527a-a10c-6505ad1d29de |
| KarthusLayWasteDeadA3.luaobj | OLS-17cb3796-5b03-5614-a17a-f2e483fc20ed |
| KarthusLayWasteDeadA3.preload | OLS-61c018e8-bef1-5995-a1d8-7ed7d2cc6093 |
| KarthusWallOfPain2.inibin | OLS-62225841-ead4-53bd-addf-364cc6206641 |
| KarthusWallOfPain2.luaobj | OLS-e3e3f2c9-98af-522b-baab-9e06c2c196d8 |
| KarthusWallOfPain2.preload | OLS-d2ba9cf9-6d0c-5519-9866-3537546137ed |
| KarthusDefile2.inibin | OLS-37a85c03-8442-5cb3-9f6f-f1ade55f3f0f |
| KarthusDefile2.luaobj | OLS-0f639077-dd2f-523a-b91a-61564056886a |
| KarthusDefile2.preload | OLS-c9ec7ba2-251e-589d-accf-0beb4490a7ca |
| KarthusFallenOne2.inibin | OLS-b8b6718c-5d30-5f9c-ab58-f92ba15b3347 |
| KarthusFallenOne2.luaobj | OLS-0ffd2f88-77de-59cb-8959-e0523f34fbcd |
| KarthusFallenOne2.preload | OLS-b6e2a428-237b-5b0c-aead-c49a88a18aaa |

- `Karthus.inibin` donne `Passive1LuaName=Death Defied`, avec espaces, icône `Karthus_Passive.dds`. Six champs de niveaux passifs absents, sans valeur par défaut inventée. La description en_GB liée, ligne 4211, décrit sept secondes de lancement des sorts alors que le champion est mort.
- `Death Defied.inibin` lie `game_buff_tooltip_Death_Defied`, ligne 1823 : sorts gratuits pendant sept secondes après dégâts mortels. `Death Defied Buff.inibin` lie un texte de forme spirituelle, ligne 1824.
- Cinq liaisons de buffs inspectées : quatre résolues, **une absente**, `game_buff_tooltip_Defile` référencée par `KarthusDeathDefiedBuff.inibin`. La clé distincte `game_buff_tooltip_KarthusDefile` est du contexte de Defile ; aucun remplacement automatique.
- `KarthusDeathDefiedBuff.luaobj` conserve `BuffName=Death Defied Buff`, l’icône passive, persistance après mort et non-dissipation. Ces métadonnées ne fournissent pas le callback serveur ni l’ordonnancement de la mort.
- Les variantes `KarthusLayWasteDeadA1/A2/A3`, `KarthusWallOfPain2`, `KarthusDefile2`, `KarthusFallenOne2` ont leurs triplets inibin/Lua/preload identifiés. Leurs champs bruts restent distincts des sorts vivants et d’une implémentation exécutée.
- Huit Lua ordinaires lus entièrement, zéro prototype enfant : sept initialisations littérales qualifiées ; **FallenOne2, NEWTABLE pc12**, dépasse le lecteur littéral. Limite du lecteur, sans corruption démontrée.
- `KarthusDefile2.luaobj` conserve `SpellToggleSlot=3` et `BuffName=KarthusDefile`. Aucun changement arbitraire de convention d’index ne permet de déclarer qu’il s’agit de R.
- Huit preloads ordinaires : le root déclare notamment `karthusdeathdefied` et une dépendance NightmareBot ; le buff déclare les variantes mortes, les sorts vivants restaurés et des effets avatar/root/explosion/fade. Ce sont des dépendances, pas une acceptation de rendu ou de gameplay.
- Cinq chemins candidats inspectés sont absents : DDF du personnage, `KarthusDeathDefied.inibin/.luaobj` dans les sorts du personnage et les sorts globaux. Cette recherche ciblée ne prouve pas une absence universelle. Le nom exact de preload reste non résolu ; aucun alias silencieux vers les noms avec espaces ou suffixe Buff.
- Deux ressources **NightmareBotKarthusDeathDefiedBuff** Lua/preload sont conservées dans la découverte mais exclues des liens natifs ordinaires. Leur icône `Lich_Defied.dds` ne remplace pas `Karthus_Passive.dds`.
- Neuf références communautaires séparées : CharScript, QWER, statistiques et trois JSON de sorts. Le CharScript est vide ; ces références ne sont pas assimilées au serveur historique.

## Diagnostic réellement exécuté

Compilation privée `cargo build --locked --offline` contre le vrai `crates/core/src/lib.rs` non-test. Dépendances/checksums alignés au lock racine. **1 158 entrées de code/ressources** et la chaîne antérieure sont contrôlées, y compris Karma V583 et les preuves/échecs de stockage Jinx V582.

Exécutable `F:\OpenLeague-work\Requirements_registry_4_20_2026-10-20\revision536_yasuo_crit_probe_aligned\cargo-target\debug\openleague-karthus-passive-death-defied-probe.exe` — 6031872 octets — SHA-256 `f527d4c1a50cc57602770e26876eb94c52cde364f052ca3a7913d8d3cd1b4a45`.

Deux parties Map10 neuves : Karthus victime, Annie attaquante. Achat public du Rubis 1028 dans le second cas : coût 400, +150 HP. Déplacements publics séquentiels vers le centre, attaques d’Annie jusqu’à la mort, Stop du tueur, observation jusqu’à réapparition puis déplacement public de Karthus. Aucune injection directe de santé, position, mana, niveau, délai ou horloge.

| Cas | HP max | Impacts témoins | Refus publics | Dont mort | Ticks observés après mort | Délai ordinaire |
|---|---:|---:|---:|---:|---:|---:|
| base | 516 | 14 | 82 | 55 | 480 | 480 |
| ruby | 666 | 17 | 82 | 55 | 480 | 480 |

Les **31 baisses de santé** ont chacune un projectile Annie→Karthus témoin. Les deux morts ordinaires créditent chacune une seule première élimination à 400 ; la victime reste niveau 1. Le délai ordinaire est **480 ticks, soit 16 secondes**. Ce délai est distinct de la fenêtre passive native de sept secondes.

Avant la mort, les refus couvrent joueur inconnu, attaque sur soi, slot invalide et Learn/Cast/CastAt de QWER. Aux offsets **0, 1, 209, 210, 211** après mort, les quatre Cast, quatre CastAt et Move/Attack/Stop sont refusés par `champion dead` : **55 refus morts par cas**, 110 au total. Chaque refus conserve le snapshot.

Jusqu’au tick 479, santé nulle, position et mana inchangés, même échéance de réapparition. Au tick 480, réapparition naturelle avec santé/mana restaurés et retour à la base ; le déplacement fonctionne à nouveau. Douze refus Learn/Cast/CastAt sont également contrôlés après réapparition.

Total : **164 refus sans mutation, 960 ticks observés après mort, deux morts et deux réapparitions ordinaires**. Les sorts gratuits ne sont jamais admis ; la stabilité du mana pendant un refus ne prouve donc pas la politique de coût gratuit sur un lancement accepté.

Attendu historique : autoriser les sorts pendant la fenêtre native. Observé actuel : refus général mort et absence de support vivant. Attendu du diagnostic de limite : refus explicites sans mutation et réapparition ordinaire ; observé conforme. Les snapshots sont des diagnostics locaux, sans preuve de transport réseau, affichage ou audio.

## Consommateurs reliés

| Source et ligne | Rôle |
|---|---|
| crates/core/src/lib.rs:533 | initialization |
| crates/core/src/lib.rs:598 | blanket_dead_command_guard |
| crates/core/src/progression.rs:68 | ordinary_caps_not_spirit_state |
| crates/core/src/progression.rs:150 | alive_learning_refusal |
| crates/core/src/progression.rs:159 | unsupported_Karthus_ranks |
| crates/core/src/spells.rs:101 | dead_guard_then_unsupported_alive_Karthus |
| crates/core/src/annie_w.rs:29 | dead_guard_then_unsupported_ground_cast |
| crates/core/src/lib.rs:685 | tick_order_lifecycle_and_terminal_boundary |
| crates/core/src/lib.rs:744 | diagnostic_not_network_acceptance |
| crates/core/src/damage.rs:53 | lethal_cleanup_and_immediate_respawn_deadline |
| crates/core/src/champion_kills.rs:26 | ordinary_kill_credit |
| crates/core/src/champion_kills.rs:32 | single_ordinary_kill_reward |
| crates/core/src/attacks.rs:157 | witnessed_Annie_projectiles |
| crates/core/src/lifesteal.rs:4 | ordinary_attack_damage |
| crates/core/src/lifecycle.rs:33 | actual_baseline_respawn_and_resource_restore |
| crates/core/src/lifecycle.rs:6 | level1sixteen_seconds_distinct_from_seven_seconds_passive |
| crates/core/src/lifecycle.rs:24 | resource_policy_static_context |
| crates/core/src/regeneration.rs:32 | dead_regeneration_suppressed |
| crates/core/src/shop.rs:261 | Ruby_public_control |
| crates/core/src/shop.rs:215 | Ruby150health_control |
| crates/core/src/attacks.rs:103 | static_only_no_Karthus_spirit_cleanup |

Les frontières command/learn/cast/cast_at expliquent les refus. Le traitement des dégâts létaux, du crédit de mort et de la réapparition explique le cycle ordinaire observé. Les attaques et projectiles fournissent les témoins des impacts ; le shop et les statistiques fournissent le contrôle Rubis. Les règles de ressources et de déconnexion sont du contexte inspecté statiquement lorsqu’elles ne sont pas exercées par ces scénarios.

Dix ressources locales de profils/règles sont reliées séparément des ressources natives, dont les règles de mort et les positions de réapparition Map10. Ces règles locales ne deviennent pas des preuves du serveur historique par cette liaison.

## Travail restant et limites

1. Admission de QWER vivants et de leurs variantes postmortem, état spirituel et fenêtre de sept secondes sur contrat vérifié.
2. Transition létale, instant du crédit de mort, départ du délai de réapparition, effets simultanés et restrictions de ciblage, mouvement, attaque et autres actions.
3. Politique de coûts gratuits sur des lancements réellement acceptés, mana, délais préexistants, sorts déjà engagés, activation/arrêt de Defile et canalisation de R.
4. Frontières d’expiration, dernière action au même tick, arrêt des effets, restitution des sorts vivants, réapparition, déconnexion et fin de partie.
5. Résoudre les candidats manquants et la clé Defile ou conserver leur portée exacte ouverte ; améliorer le lecteur Lua pour NEWTABLE sans inventer les instructions absentes.
6. Séparer les variantes NightmareBot ; aucune adoption de comportement, icône ou durées à partir de cette variante.
7. Plusieurs niveaux, causes de mort, coûts, interactions, HUD, icône, animation, avatar/VFX, audio et réseau à qualifier après implémentation.

Aucun serveur historique exécuté. Aucune ressource 3D manquante n’est déduite du blocage de gameplay. BattleTraining, les autres champions et le défaut de déplacement V564 restent des limites distinctes ouvertes.

## Intégration et conservation

BUILD, RUN, inspection, PREPARE, CHECK, PUBLISH et AUDIT : retours réels 0, identités/journaux conservés.

La préparation locale du script de clôture documentaire a d’abord refusé une mention historique intentionnelle de Karma V583. La garde a été précisée avant création/exécution de ce script ; aucun livrable publié ni reçu antérieur n’a été remplacé.

- 72 associations volontairement invalides et quatre graphes invalides refusés.
- Trois fragments de consignes changés, 42 212 inchangés ; anciens objets/descripteurs conservés.
- Deux bases locales : quatre destinataires actualisés, 42 603 autres lignes inchangées, **42 607 états manuels et 23 historiques conservés**, synchronisation normale idempotente.
- Identités, hiérarchie et inconnues inchangées octet pour octet. Trois questions propres et quatre dépendances conservées avec leurs propriétaires.
- Graphe : 99 013 sources, 3 632 consommateurs, 42 215 exigences, 26 189 inconnues ouvertes et 5 517 résolues précédemment. Revue globale : **3 632 ancres exactes, zéro divergence courante**. Revue structurelle ; les sources sélectionnées sont hachées séparément, sans prétendre re-hacher tout le catalogue.

Fichiers livrés : `docs/completion_tasks_2026-10-20.json`, `docs/fidelity_requirement_trace_4_20.json`, `docs/fidelity_sources_4_20.json`, `docs/reference_requirement_trace_sources/karthus-passive-death_defied-links-v584.json`, `docs/fidelity_karthus_passive_death_defied_links_v584.json`, ce rapport, `coverage.json`, `completion_plan.json`, `resume_checkpoint.json`, `docs/ai/CURRENT.md`, `HANDOFF.md` et reçu de reprise privé. Données/consignes des deux bases actualisées sans acceptation ni coche automatique.

Preuves sous `F:/OpenLeague-work/Requirements_registry_4_20_2026-10-20` : `revision584_Karthus_discovery`, `revision584_Karthus_passive_probe`, `revision584_Karthus_inspection_verified`, `revision584_Karthus`, puis `revision585_trace_review/REVIEW.json`.

## Reprise

Continuer SYS-01.2-02 depuis revision585_trace_review/REVIEW.json. Karthus V584 publié/audité :27sources natives ordinaires,81associations,21points/42liens. Deux cas base516HP/Ruby666HP,31impacts Annie témoins,2morts,164refus dont110dead aux offsets0/1/209/210/211;960ticks,2réapparitions ordinaires480ticks. Texte natif sept secondes de lancement gratuit après dégâts mortels,nonréalisé;sorts vivants également refusés. Huit Lua7littéraux1NEWTABLEpc12,8preloads,4liaisons de buffs résolues1clé Defile absente,5chemins candidats absents dontDDF/référence exacte KarthusDeathDefied;2NightmareBotexclus;9communautaires. Conserver les ambiguïtés/limites et preuves V583Karma,V582stockage,V564déplacement. Poursuivre un autre passif après inspection réelle,par exemple Kassadin. Goal actif;aucun statut/case/inconnu fermé.
