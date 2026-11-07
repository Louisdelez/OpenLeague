# SYS-01.2-02 — item 1052 : FlatMagicDamageMod (V817)

Date : 2026-11-02

## Périmètre et critère de clôture

Cette unité relie le champ natif FlatMagicDamageMod de l’item 1052 au catalogue local et au calcul courant de puissance. Le lien est documenté si le binaire courant correspond au reçu source, si le champ exact est décodé, si le consumer est inspecté et si un test nominal achat/vente réussit.

La fermeture de cette liaison ne clôt pas ITEM-1052-SCOPE, ITEM-1052-SERVER, la conversion serveur historique, les autres restrictions de boutique ou SYS-01.2-02.

## Source native et donnée locale

- Référence : client PUBLIC 4.20.0.315, Releases/4.20, EUW/en_GB.
- Fichier : D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\1052.inibin.
- Reçu enregistré : OLS-40885383-cc97-5bd3-9f81-211026fb4d4c, 577 octets, SHA-256 ec992cc30be0724ce6cf625ac775d8715417cb35a0eb27315bd6e1284ee93cfd, version 4.20.0.315, membership matches_selected_project_manifest.
- Nouvelle lecture ciblée en V817 avec le lecteur local en lecture seule tools/project-plan/reference_inibin.py : hash de champ Data*FlatMagicDamageMod = 3524488927; champ présent; valeur décodée brute = chaîne 20. SHA-256 et taille courants du fichier = reçu enregistré.
- Autres valeurs lues : Price=435, InStore=1. data/4.20/native_item_audit.json omettait auparavant FlatMagicDamageMod; ce lot complète la preuve de champ sans modifier ce reçu.
- data/4.20/shop_foundation.json contient ability_power=20, price=435, sell_price=305 et source_sha256 identique. data/4.20/map10_shop_admission.json accepte l’item 1052.

Le rapprochement du nom de champ natif et de la chaîne brute 20 avec le nombre local 20 est une interprétation explicite du champ. Le convertisseur original du serveur n’a pas été exécuté.

## Consommateur actuel

- crates/core/src/shop.rs::bonuses additionne item.bonuses.ability_power.
- crates/core/src/progression.rs::stats produit la puissance depuis cette somme et applique ensuite le multiplicateur local d’autels.
- crates/core/src/cooldown.rs::tests::two_altar_power_bonus_uses_the_current_item_power achète 1052, observe l’AP, ajoute les deux autels puis revend l’item.
- Ce parcours est celui de la simulation locale Map10; il ne démontre pas la formule ni l’intégration du serveur original.

## Vérification exécutée

Lecture INIBIN ciblée : fichier 1052 à 577 octets, SHA-256 identique au reçu, FlatMagicDamageMod présent avec valeur brute 20.

Commande : cargo test --offline -p openleague-core two_altar_power_bonus_uses_the_current_item_power -- --nocapture.

Résultat : test cooldown::tests::two_altar_power_bonus_uses_the_current_item_power réussi, 1 passed, 0 failed; 1926 tests unitaires filtrés; Cargo exit 0. Le test constate 20 AP après achat, 22 avec les deux autels et 0 après vente.

## Limites et état

- Sous-audit source → champ décodé → donnée → consumer clos pour FlatMagicDamageMod de 1052, avec la conversion du brut string 20 vers AP numérique explicitement qualifiée d’interprétation.
- Conversion originale serveur, achat/vente en partie Riot, interactions hors Map10, acceptation et disponibilité historique effective restent non établis.
- ITEM-1052-SCOPE et ITEM-1052-SERVER restent partiels; acceptance_complete=false. Aucun statut du registre n’a été changé.
- Aucun code produit, tâche, Plan, application, base de données ou goal Codex modifié. Aucun installateur ni migration; Cargo a seulement écrit ses artefacts dans target.
- D01-SYS-01-1 reste non accepté et SYS-01.2-02 demeure actif.

Prochaine unité : choisir un lien requis distinct des items 1001, 1004, 1006, 1011, 1018, 1029, 1051 et 1052, avec source native actuelle et consumer identifiés; vérifier un cas nominal et une limite sans modifier les statuts.

Références : data/4.20/native_item_audit.json; docs/fidelity_sources_4_20.json; data/4.20/shop_foundation.json; data/4.20/map10_shop_admission.json; tools/project-plan/reference_inibin.py; crates/core/src/shop.rs; crates/core/src/progression.rs; crates/core/src/cooldown.rs.
