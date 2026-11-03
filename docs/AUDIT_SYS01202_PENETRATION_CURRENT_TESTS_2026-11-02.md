# SYS-01.2-02 — contrôle ciblé des tests de pénétration (V846)

**Date :** 2026-11-02  
**Lot :** vérification de l’implémentation locale courante pour les objets 3020, 3035, 3134, 3135 et 3136.  
**État :** vérification ciblée terminée; l’objectif parent reste actif. Ce résultat ne signifie pas que ces objets, le moteur ou le jeu sont terminés.

## Critère de fin de ce lot

Exécuter le harnais Rust existant de pénétration sur le binaire courant; relever les cas nominaux et les refus qu’il couvre; relier le test à ses sources et données locales; distinguer ces résultats du comportement historique du serveur.

## Contrôle exécuté

Binaire exécuté directement, sans recompilation :

`target/debug/deps/openleague_core-21eb81eb13817108.exe penetration::tests --nocapture --test-threads=1`

**Attendu :** 7 tests sélectionnés, zéro échec.  
**Observé :** 7 réussis, 0 échoué, 0 ignoré, 1 920 filtrés, durée 0,02 s; code de sortie 0.

Le résultat nominal local de la formule incluse est 100 armure, 10 pénétration plate et 35 % = 55 armure effective. Le plancher à zéro, la résistance non positive et les entrées invalides sont aussi couverts. Le test du groupe d’objets rejette les achats répétés de 1001 et 3020. Ce sont des assertions du simulateur local, pas des règles serveur établies par ce contrôle.

| Test exécuté | Objets concernés | Contrôle observé |
|---|---|---|
| `percent_before_flat_zero_floor_negative_and_invalid_inputs` | Formule générique | Valeur nominale, plancher, résistance nulle/négative; NaN, valeur plate négative/infinie et pourcentage hors plage refusés. |
| `source_owned_items_change_damage_without_mutating_target_stats` | 3134, 3035, 3135, 3136 | Dégâts physiques, magiques et vrais calculés à partir des bonus du propriétaire; statistiques défensives de la cible inchangées. |
| `unique_passives_deduplicate_but_direct_stats_stack` | 3134, 3135 | Pénétration plate et passive de pourcentage observées après achats répétés; stats directes distinctes s’empilent. |
| `world_targets_receive_identical_post_mitigation_amount_once` | 3035, 3134 | Monstres et tourelles reçoivent le montant post-mitigation attendu une seule fois. |
| `boot_upgrade_unique_group_and_separate_magic_pen_sources` | 3020, 3136, groupe 1001 | Groupe d’amélioration et refus de doublons de 3020; sources de pénétration magique testées séparément. |
| `official_integer_sell_refunds_replace_fractional_gold` | 3134, 3135 | Remboursements de vente entiers contrôlés. |
| `ultimate_retains_caster_penetration_and_kill_attribution` | 3136 | Le sort conserve la pénétration du lanceur; attribution d’élimination et récompense vérifiées. |

## Binaire et empreintes relus

Binaire : `F:\OpenLeague\target\debug\deps\openleague_core-21eb81eb13817108.exe`  
Taille : 787 789 824 octets; dernière écriture : 2026-10-21 10:19:25 UTC.  
SHA-256 : `46d3732181601e8bfdc1923857d66192fd2a18fba13fe7aa3bd2f80876f74e6d`.

Les empreintes ci-dessous ont été relues pour relier le binaire et le harnais à l’état courant du dépôt :

| Fichier | SHA-256 |
|---|---|
| `crates/core/src/penetration.rs` | `7a4e2b53c0f8bbcdd0c0047a880e393d2dfcfaa6e6496ddff6bc83acdc87fd41` |
| `crates/core/src/shop.rs` | `3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0` |
| `crates/core/src/progression.rs` | `eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766` |
| `crates/core/src/damage.rs` | `0d579a7b4e7a3941df7e70f78d62029c9f34df0c345749c2adc17153f9624387` |
| `data/4.20/shop_foundation.json` | `504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae` |
| `data/4.20/map10_shop_admission.json` | `6393e7c2a39abed63b6f3db36c265e94d5ce2fc5435e29c17ccf012f288ad485` |
| `assets/maps/tt_navigation_grid.json` | `98903341b52e204145eafc92a949394712257abc352bc3dad5e5fe204f1c1321` |
| `assets/maps/tt_navigation_grid.cells.bin` | `beeeff7df5b236e7617cacf0c848b850c1114e007253434ce59d7ad6410b7e72` |

Les liens natifs et comparaisons déjà établis sont conservés dans les rapports V841 à V845 : 3035, 3134, 3020, 3136 et 3114.

## Limites et reprise

- Les sept tests établissent uniquement le comportement du simulateur local compilé. Ils ne prouvent pas la logique du serveur LoL 4.20, la priorité des ressources au runtime, le réseau, le client graphique ni l’acceptation humaine.
- L’objet 3114 n’apparaît pas dans le harnais de pénétration. Les tests génériques de régénération et les preuves antérieures de l’objet 1004 ne constituent pas un test d’achat et de régénération spécifique à 3114. Le lot 3114 reste ouvert sur ce point.
- Une tentative de relancer Cargo avec `cargo test --locked --offline -p openleague-core --lib penetration::tests -- --nocapture --test-threads=1` s’est arrêtée avant l’exécution : accès refusé à `target/debug/.cargo-build-lock` (erreur système 5). Le test ci-dessus a été exécuté depuis le binaire existant; aucune recompilation n’est revendiquée.
- Les sources historiques serveur et l’observation de jeu demeurent absentes ou non établies. Ne pas étendre ce résultat à l’équivalence historique.
- Prochain petit lot : ajouter/valider une preuve dédiée à 3114, avec achat isolé, taux de régénération mana attendu à +60 % au niveau observé, évolution sur une seconde non plafonnée, retour après vente et cas d’un champion sans mana; n’ouvrir le lot qu’avec une source/valeur précise et un résultat mesuré.

**Clôture limitée :** la vérification du harnais courant de pénétration pour 3020, 3035, 3134, 3135 et 3136 est réussie. Les fonctionnalités et la fidélité historique ne sont pas déclarées terminées. Aucun code produit, registre de tâches, goal, Plan, interface, base de suivi, checkpoint de reprise ou statut de tâche n’a été modifié; aucun logiciel installé ni migration appliquée.
