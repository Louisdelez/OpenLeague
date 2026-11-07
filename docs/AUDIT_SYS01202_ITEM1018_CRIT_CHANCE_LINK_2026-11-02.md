# SYS-01.2-02 — item 1018 : FlatCritChanceMod (V814)

Date : 2026-11-02

## Périmètre et critère de clôture

Cette unité relie le champ natif de l’objet 1018 à sa donnée locale et au calcul Rust courant de chance critique. Elle se clôt pour cette relation si l’identité et l’appartenance de la source sont établies, si la donnée catalogue concorde, et si l’achat/refus/vente sont observés sur une simulation Map10.

Ce résultat ne clôt ni ITEM-1018-SCOPE, ITEM-1018-SERVER, l’application du tirage critique en combat, le prérequis D01-SYS-01-1 ou SYS-01.2-02.

## Source 4.20 et donnée locale

- Référence : client PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB.
- Source : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\1018.inibin.
- Registre source : OLS-0d8167ff-4a6a-5162-aaa4-070ff1c5814d; 533 octets; SHA-256 3cdd918dd0e86ac8cf43a36424e2aab965c2cfcd26c11f301f5dd3e9efb4bf5b; identity verified=true.
- Appartenance enregistrée : matches_selected_project_manifest, projet lol_game_client, version de projet 0.0.1.7, release de contenu 0.0.0.242; taille 533 et MD5 fa0fa28ff311e5021766f10b9641f46a concordants.
- Valeur native décodée dans le reçu local, réutilisée sans relecture/re-hash : FlatCritChanceMod=0.15000000596046448; Price=730; InStore=true; CanBeSold=true.
- data/4.20/shop_foundation.json reprend critical_chance=0.15000000596046448, price=730, sell_price=511 et le SHA-256 source identique. data/4.20/map10_shop_admission.json admet l’objet.

## Consommateur courant identifié

- crates/core/src/shop.rs::buy_item valide l’or et l’admission Map10; crates/core/src/shop.rs::bonuses additionne le champ critical_chance des objets détenus.
- crates/core/src/progression.rs::stats calcule chance de base + croissance + bonus objets, puis borne le résultat entre 0 et 1.
- crates/core/src/shop.rs::sell_item retire l’objet, crédite le prix local et rafraîchit les statistiques.
- La preuve porte sur la statistique calculée par Simulation; elle ne mesure pas la fréquence réelle de coups critiques ni la parité du serveur Riot.

## Vérification exécutée

Probe Rust temporaire, hors du dépôt, référencé au crate courant openleague-core et à la navigation TT. Garen a rejoint Map10 au spawn. L’or a été fixé à 729 pour le refus, puis à 730 pour l’achat nominal; la vente a été exécutée à la boutique alliée.

| Cas | Attendu | Observé |
|---|---|---|
| 729 or | refus sans mutation | refus sur l’or; inventaire et chance critique inchangés |
| Achat à 730 or | +0,15 de chance | 0,000000000 → 0,150000006; dégâts inchangés |
| Vente | retrait du bonus, crédit local 511 | retour à 0; or=511 |

Résultat final : PASS, cargo run --offline, code 0. Le crate courant a compilé avec 24 avertissements non bloquants. Le dossier du probe sous E:\mapslol3v3 a été supprimé après l’exécution; les artefacts Cargo ont été écrits dans le target existant de F:\OpenLeague. Aucun binaire de jeu ni installateur n’a été lancé.

## Limites et état

- Le lien source → catalogue → statistique locale est clos pour FlatCritChanceMod.
- Aucun test d’attaque réelle, de tirage RNG, d’observation statistique, de plafonnement avec plusieurs objets achetés, ni d’effet serveur historique n’a été exécuté dans V814.
- Une fixture Rust existante mentionne 1018 en injectant directement six slots, mais elle ne prouve pas le parcours normal d’achat. Elle n’a pas été exécutée ni utilisée comme résultat du probe.
- ITEM-1018-SCOPE et ITEM-1018-SERVER restent partiels; acceptance_complete=false. Aucun statut du registre n’a changé.
- Aucun code produit, registre de tâches, plan, application de suivi, base ou goal Codex modifié; aucune installation ou migration.
- D01-SYS-01-1 reste non accepté; le goal SYS-01.2-02 demeure actif.

Prochaine unité : choisir un lien source-consommateur requis distinct des lots 1001, 1004, 1006, 1011 et 1018; réutiliser une source déjà établie seulement si elle correspond exactement à l’exigence; vérifier un succès et une limite; laisser les statuts inchangés.

Références : data/4.20/native_item_audit.json; docs/fidelity_sources_4_20.json; data/4.20/shop_foundation.json; data/4.20/map10_shop_admission.json; crates/core/src/shop.rs; crates/core/src/progression.rs; crates/core/src/critical.rs.
