# SYS-01.2-02 — item 1051 : FlatCritChanceMod (V816)

Date : 2026-11-02

## Périmètre et critère de clôture

Cette unité relie la chance critique native de Brawler’s Gloves à la donnée locale et au consommateur courant. Elle se clôt pour cette liaison si le reçu 4.20, le catalogue, l’admission Map10 et le chemin achat → cumul → vente sont concordants.

Elle ne clôt pas ITEM-1051-SCOPE, ITEM-1051-SERVER, le tirage RNG en combat, l’équilibrage historique ou SYS-01.2-02.

## Source 4.20 et donnée locale

- Référence : client PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB.
- Source enregistrée : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\1051.inibin.
- source_id OLS-52920235-455a-506b-a9a5-8c32fbda196c; 526 octets; SHA-256 ad41973e83a09bd9138de4a06b3025c0c6aae48028e5405a4386cf9d3553a681; version 4.20.0.315; membership matches_selected_project_manifest.
- Reçu natif réutilisé, aucun re-hash : FlatCritChanceMod=0.07999999821186066; Price=400; InStore=true; CanBeSold=true.
- shop_foundation.json a critical_chance=0.07999999821186066, price=400, sell_price=280 et le même SHA. map10_shop_admission.json marque 1051 allowed=true.

## Consommateur courant identifié

- shop::bonuses additionne le bonus critical_chance des items détenus.
- progression::stats calcule la chance de base plus croissance et bonus objets, avec clamp entre 0 et 1.
- critical::tests::native_crit_components_stack_sell_and_cap_without_changing_base_damage couvre le chemin normal d’achat de deux objets 1051, la vente d’un, et l’absence de changement de dégâts.
- Le chemin testé est une simulation Map10 locale; il ne prouve ni le tirage statistique en partie ni la formule historique côté serveur.

## Vérification exécutée

Commande ciblée : cargo test --offline -p openleague-core native_crit_components_stack_sell_and_cap_without_changing_base_damage -- --nocapture.

Résultat : critical::tests::native_crit_components_stack_sell_and_cap_without_changing_base_damage réussi, 1 passed, 0 failed; 1926 tests unitaires filtrés; Cargo exit 0. Deux achats 1051 produisent 0,16 de chance critique sur Garen, la vente d’un ramène à 0,08; dégâts et multiplicateur de critique restent inchangés par ces achats.

La même fixture injecte ensuite six exemplaires de 1018 directement dans l’inventaire pour vérifier un résultat local de 0,9, puis remet l’inventaire vide. Cette partie ne prouve pas le parcours normal de boutique de 1018 et n’est pas utilisée pour clore l’audit de 1051.

## Limites et état

- Audit du lien source → catalogue → chance critique locale clos pour FlatCritChanceMod de l’objet 1051.
- Aucun achat refusé par manque d’or, distribution de coups critiques en combat, passage par action réseau ou comparaison avec une partie Riot 4.20 exécuté dans V816.
- ITEM-1051-SCOPE et ITEM-1051-SERVER restent partiels; acceptance_complete=false. Aucun statut du registre n’a changé.
- Aucun code produit, tâche, Plan, application de suivi, base de données ou goal Codex modifié. Pas d’installation ni de migration. Cargo a seulement vérifié le test ciblé et mis à jour target.
- D01-SYS-01-1 et SYS-01.2-02 restent ouverts.

Prochaine unité : choisir une exigence requise distincte des items 1001, 1004, 1006, 1011, 1018, 1029 et 1051; confirmer sa source native et son consumer courant; vérifier une réussite et une limite, sans changer les statuts.

Références : data/4.20/native_item_audit.json; docs/fidelity_sources_4_20.json; data/4.20/shop_foundation.json; data/4.20/map10_shop_admission.json; crates/core/src/shop.rs; crates/core/src/progression.rs; crates/core/src/critical.rs.
