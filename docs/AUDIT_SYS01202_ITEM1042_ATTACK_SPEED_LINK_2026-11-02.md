# SYS-01.2-02 — item 1042 : PercentAttackSpeedMod (V819)

Date : 2026-11-02

## Périmètre et critère de clôture

Cette unité relie le champ d’attaque de Dagger à la donnée locale et au consumer de cadence d’attaque. Elle se clôt pour cette liaison si le reçu 4.20 et le catalogue concordent et si achat/vente modifient puis restaurent la cadence courante dans le test ciblé.

Elle ne clôt pas ITEM-1042-SCOPE, ITEM-1042-SERVER, les attaques en partie historique ou SYS-01.2-02.

## Source 4.20 et donnée locale

- Référence : client PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB.
- Source enregistrée : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\1042.inibin.
- OLS-6a0aee4b-4dc4-5377-8d10-2249a9bdcc5a; 559 octets; SHA-256 7a69325ffca20442c839e7e0acedb719f93f4144a073b147661957c5ff1f4a75; version 4.20.0.315; membership matches_selected_project_manifest.
- Reçu natif réutilisé sans re-hash : PercentAttackSpeedMod=0.15000000596046448; Price=450; InStore=true; CanBeSold=true.
- shop_foundation.json correspond : attack_speed=0.15000000596046448, price=450, sell_price=315 et même SHA. map10_shop_admission.json autorise 1042.

## Consommateur courant identifié

- shop::bonuses additionne item.bonuses.attack_speed.
- progression::stats intègre croissance et bonus d’objet dans attack_cooldown_ticks.
- shop::buy_item et shop::sell_item appliquent puis retirent l’effet dans la simulation locale Map10.
- Le test inclut des assertions sur 1001; elles sont hors portée ici. La preuve 1042 porte sur l’achat de la dague, la baisse de cadence et sa vente.

## Vérification exécutée

Commande : cargo test --offline -p openleague-core boots_group_is_unique_and_dagger_changes_attack_cadence -- --nocapture.

Résultat : shop::tests::boots_group_is_unique_and_dagger_changes_attack_cadence réussi, 1 passed, 0 failed; 1926 tests unitaires filtrés; Cargo exit 0. Après achat de 1042, attack_cooldown_ticks est inférieur à sa valeur initiale; après vente de la dague il revient à cette valeur. L’assertion de refus du doublon de groupe concerne les bottes 1001 et n’est pas créditée à 1042.

## Limites et état

- Lien source → catalogue → cadence locale clos pour PercentAttackSpeedMod de 1042.
- Aucun nombre exact de DPS ou de coups en partie, animation de windup, latence réseau ou comparaison au serveur Riot mesuré.
- ITEM-1042-SCOPE et ITEM-1042-SERVER restent partiels; acceptance_complete=false. Aucun statut n’a changé.
- Aucun code produit, registre de tâches, Plan, application, base de données ou goal Codex modifié. Aucun install/migration; Cargo a seulement mis à jour target.
- D01-SYS-01-1 et SYS-01.2-02 restent ouverts.

Prochaine unité : choisir un lien requis distinct des items 1001, 1004, 1006, 1011, 1018, 1029, 1036, 1042, 1051 et 1052; vérifier la source native et le consumer, un succès et une limite, sans changer les statuts.

Références : data/4.20/native_item_audit.json; docs/fidelity_sources_4_20.json; data/4.20/shop_foundation.json; data/4.20/map10_shop_admission.json; crates/core/src/shop.rs; crates/core/src/progression.rs; crates/core/src/shop.rs tests.
