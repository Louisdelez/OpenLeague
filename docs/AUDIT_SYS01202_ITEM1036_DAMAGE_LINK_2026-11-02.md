# SYS-01.2-02 — item 1036 : FlatPhysicalDamageMod (V818)

Date : 2026-11-02

## Périmètre et critère de clôture

Cette unité relie FlatPhysicalDamageMod de Long Sword à la donnée locale et au consommateur courant de dégâts d’attaque. Elle se ferme pour ce champ si la source native et son identité correspondent au reçu, si la donnée du catalogue correspond et si un test d’achat courant vérifie l’augmentation de la statistique.

Elle ne clôt pas ITEM-1036-SCOPE, ITEM-1036-SERVER, l’impact exact sur les dégâts d’un coup en partie, la sémantique historique du serveur ou SYS-01.2-02.

## Source et donnée locale

- Référence : client PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB.
- Fichier source : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\1036.inibin.
- Source OLS-69ccc5a1-3126-52c6-a584-f9cfe8f7b781; 578 octets; SHA-256 e6ed2a72317ed8295f74351663e0d94124b46c48f61db02cbc479849a3e86731; version 4.20.0.315; membership matches_selected_project_manifest.
- Reçu natif existant réutilisé sans re-hash : FlatPhysicalDamageMod=string 10; Price=360; InStore=true; CanBeSold=true.
- shop_foundation.json : damage=10, price=360, sell_price=252 et source_sha256 identique. map10_shop_admission.json : allowed=true.

La conversion de la chaîne native 10 en nombre local 10 est l’interprétation du champ FlatPhysicalDamageMod; le convertisseur original du serveur n’est pas exécuté ici.

## Consommateur courant identifié

- shop::bonuses additionne item.bonuses.damage.
- progression::stats utilise cette somme dans le calcul courant des dégâts d’attaque via ad_components.
- shop::buy_item achète l’item sous les gardes locaux de boutique/Map10/or.
- Aucun coup réel, armure de cible ni dégâts réseau n’est observé par le test source réutilisé.

## Vérification exécutée et réutilisée

Le test courant native_start_and_buy_apply_to_combat_stats a été exécuté en V815 contre les sources courantes : il achète 1036 à Garen, vérifie l’or restant à 465 et constate stats.damage = dégâts de base +10. Le même test poursuit avec l’achat de 1029. Résultat enregistré : 1 passed, 0 failed, 1926 tests unitaires filtrés; Cargo exit 0.

V818 réutilise ce résultat du même run, sans relancer le test. Il s’agit d’une statistique locale calculée, pas d’une mesure de dégâts en combat.

## Limites et état

- Lien source → catalogue → statistique damage locale clos pour FlatPhysicalDamageMod.
- Vente, refus d’achat propre à 1036, cumul, interactions des autres bonus et dégâts réels d’une attaque non vérifiés dans ce lot.
- Les règles serveur 4.20, l’intégration réseau et l’acceptation restent inconnues.
- ITEM-1036-SCOPE et ITEM-1036-SERVER restent partiels; acceptance_complete=false. Aucun statut n’a changé.
- Aucun code produit, tâche, Plan, application, base ou goal Codex modifié. Aucun install/migration. Aucun nouveau test exécuté en V818.
- D01-SYS-01-1 et SYS-01.2-02 demeurent ouverts.

Prochaine unité : choisir un lien requis distinct des items 1001, 1004, 1006, 1011, 1018, 1029, 1036, 1051 et 1052, avec source native et consumer actuels identifiés; vérifier un nominal et une limite, sans modifier les statuts.

Références : data/4.20/native_item_audit.json; docs/fidelity_sources_4_20.json; data/4.20/shop_foundation.json; data/4.20/map10_shop_admission.json; crates/core/src/shop.rs; crates/core/src/progression.rs; docs/AUDIT_SYS01202_ITEM1029_FLAT_ARMOR_LINK_2026-11-02.md.
