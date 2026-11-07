# SYS-01.2-02 — item 1053 : FlatPhysicalDamageMod et PercentLifeStealMod (V820)

Date : 2026-11-02

## Périmètre et critères de clôture

Cette unité relie la recette et les deux champs natifs pertinents de Vampiric Scepter à sa donnée locale et au consumer courant d’attaque/vol de vie. Elle se ferme pour ce lien si la source, le calcul local de recette, les statistiques après achat/vente et un cas de vol de vie en attaque réussissent dans le code courant.

Elle ne clôt pas ITEM-1053-SCOPE, ITEM-1053-SERVER, la fidélité des règles d’attaque Riot 4.20 ou SYS-01.2-02.

## Source native et donnée locale

- Référence : client PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB.
- Fichier : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\1053.inibin.
- Source OLS-db739366-3781-58b7-b7c8-dbc67a297e8f; 563 octets; SHA-256 bb7db97c466730d2b2902d68fd64b4341f322b3352d936d0621670b05756d05d; version 4.20.0.315; membership matches_selected_project_manifest.
- Reçu natif réutilisé sans re-hash : Price=440, RecipeItem1=1036, FlatPhysicalDamageMod=string 10, PercentLifeStealMod=0.07999999821186066, CanBeSold=true.
- shop_foundation.json traduit la recette locale en recipe=[1036], prix total 800 (440 + l’épée 1036 à 360), dégâts 10, life_steal=0.07999999821186066, vente 560, source_sha256 identique. map10_shop_admission.json autorise 1053.

La conversion de la chaîne native FlatPhysicalDamageMod=10 en dégâts numériques 10 est une interprétation du champ; le convertisseur serveur original n’a pas été exécuté.

## Consommateurs locaux identifiés

- shop::bonuses agrège damage et life_steal; progression::stats applique ces champs aux statistiques de l’attaquant.
- lifesteal::basic_attack_hit applique des dégâts physiques, lit stats.life_steal et soigne l’attaquant d’après outcome.post_mitigation; les structures et les attaquants morts sont exclus par le code courant.
- Les commentaires du module indiquent que les cas historiques et modificateurs de champion restent non qualifiés.

## Vérifications exécutées

1. cargo test --offline -p openleague-core native_recipe_credits_sword_and_sale_removes_attack_and_lifesteal_stats -- --nocapture : 1 passed, 0 failed, 1926 filtrés, Cargo exit 0. Le test achète 1036 puis 1053, constate la recette fusionnée dans le slot 0, l’or restant 25, +10 dégâts et +0,08 vol de vie; la vente rend 560 et retire les bonus.

2. cargo test --offline -p openleague-core ordinary_attack_heals_from_mitigated_damage_without_overheal -- --nocapture : 1 passed, 0 failed, 1926 filtrés, Cargo exit 0. Le helper active Map10 et achète 1053; l’attaque soigne 8 % des dégâts après mitigation puis l’overheal est borné aux PV max.

Ces résultats vérifient le comportement implémenté dans la simulation locale. Ils ne prouvent pas que le serveur Riot 4.20 appliquait les mêmes règles.

## Limites et état

- Sous-audit source → recette/données → stats → consumer d’attaque/vol de vie clos pour ce périmètre de 1053.
- Aucun refus propre à l’achat 1053, autre type de cible, bonus de champion, combat réseau, probabilité de kills ou comparaison avec un serveur Riot historique testé.
- ITEM-1053-SCOPE et ITEM-1053-SERVER restent partiels; acceptance_complete=false. Aucun statut du registre n’a changé.
- Aucun code produit, tâche, Plan, application, base de données ou goal Codex modifié; aucun install/migration. Cargo a seulement mis à jour target.
- D01-SYS-01-1 et SYS-01.2-02 restent ouverts.

Prochaine unité : choisir un lien requis distinct des items 1001, 1004, 1006, 1011, 1018, 1029, 1036, 1042, 1051, 1052 et 1053; auditer un cas nominal et une limite sans modifier les statuts.

Références : data/4.20/native_item_audit.json; docs/fidelity_sources_4_20.json; data/4.20/shop_foundation.json; data/4.20/map10_shop_admission.json; crates/core/src/shop.rs; crates/core/src/progression.rs; crates/core/src/lifesteal.rs.
