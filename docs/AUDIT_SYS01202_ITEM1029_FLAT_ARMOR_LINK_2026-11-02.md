# SYS-01.2-02 — item 1029 : FlatArmorMod (V815)

Date : 2026-11-02

## Périmètre et critère de clôture

Cette unité relie le champ FlatArmorMod de Cloth Armor au catalogue local puis au consommateur courant d’armure. Le sous-audit se ferme pour ce lien si le reçu source 4.20 et la donnée de boutique concordent, si le consumer est localisé et si un cas d’achat courant passe.

Elle ne clôt pas ITEM-1029-SCOPE, ITEM-1029-SERVER, les prix/recettes complets, l’acceptation du jeu, ni SYS-01.2-02.

## Source 4.20 et donnée locale

- Référence : League of Legends PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB.
- Source native enregistrée : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\1029.inibin.
- source_id OLS-4be229f5-8e25-5e28-b080-77c8c9dad43a; version 4.20.0.315; 528 octets; SHA-256 9596f0efec5a87ee6dca380d042f94cff48a1e73ba965fdc61955d72075526ab; source_identity_verified=true; membership enregistrée matches_selected_project_manifest.
- Reçu data/4.20/native_item_audit.json réutilisé sans relecture ni re-hash : FlatArmorMod=15, Price=300, InStore=true, CanBeSold=true.
- data/4.20/shop_foundation.json reprend armor=15, price=300, sell_price=210 et le SHA-256 source identique. data/4.20/map10_shop_admission.json marque 1029 allowed=true.

## Consommateur courant identifié

- crates/core/src/shop.rs::buy_item admet l’achat lorsque les gardes locaux, la carte et l’or le permettent.
- crates/core/src/shop.rs::bonuses additionne le champ armor de l’objet.
- crates/core/src/progression.rs::stats calcule l’armure à partir de la valeur de base, de la croissance du champion et de items.armor.
- La correspondance concerne la statistique locale de la simulation Map10; elle ne démontre pas l’ordre d’application du serveur historique.

## Vérification exécutée

Commande ciblée : cargo test --offline -p openleague-core native_start_and_buy_apply_to_combat_stats -- --nocapture.

Résultat : test shop::tests::native_start_and_buy_apply_to_combat_stats réussi, 1 passed, 0 failed; 1926 tests unitaires filtrés. Le test achète d’abord 1036, puis 1029; après 1029, l’or vaut 165 et l’armure vaut celle de Garen plus 15. Cargo exit 0.

Ce test existant a été exécuté contre les sources courantes. Il couvre l’achat nominal et l’ajout d’armure, mais pas une vente de 1029 ni un refus d’achat de 1029 pour manque d’or.

## Limites et état

- Audit source → catalogue → statistique d’armure clos pour FlatArmorMod=15.
- Le résultat d’un seul chemin Map10 ne prouve pas l’accès historique du serveur, les autres cartes, les recettes ou les règles exactes de cumul/vente.
- Aucun test item-spécifique du refus ou de la vente de 1029 n’a été exécuté dans V815; aucun combat ni résultat PvP n’a été mesuré.
- ITEM-1029-SCOPE et ITEM-1029-SERVER restent partiels; acceptance_complete=false. Aucun statut du registre n’a été changé.
- Aucun code produit, tâche, Plan, application de suivi, base de données ou goal Codex modifié. Aucun logiciel installé, aucune migration exécutée. Cargo a seulement mis à jour ses artefacts dans target.
- D01-SYS-01-1 reste non accepté; le goal parent SYS-01.2-02 demeure actif.

Prochaine unité : choisir un lien requis distinct des items 1001, 1004, 1006, 1011, 1018 et 1029; réutiliser les reçus existants uniquement s’ils attestent exactement la source; vérifier un cas nominal et une limite sans modifier les statuts.

Références : data/4.20/native_item_audit.json; docs/fidelity_sources_4_20.json; data/4.20/shop_foundation.json; data/4.20/map10_shop_admission.json; crates/core/src/shop.rs; crates/core/src/progression.rs.
