# SYS-01.2-02 — item 3035 : pénétration d’armure physique et consumer actuel

Date de contrôle : 2026-11-02 UTC. Unité : `AUD-SYS01202-ITEM3035-ARMOR-PENETRATION-01`. Exigence parente : `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`.

## Lot, frontière et décision

Question : la propriété d’armure physique de l’objet 3035 de la référence LoL 4.20 est-elle reliée à la donnée Map10 et au consumer Rust courant ?

Résultat attendu pour cette cartographie : identifier la valeur source du passif, la donnée locale correspondante, l’admission Map10 et le chemin utilisé avant mitigation. Cas limite retenu : armure nulle ou négative, que la fonction actuelle doit laisser inchangée. L’audit se limite à cette relation. Il ne qualifie ni tout l’objet, ni la règle serveur historique, ni le parcours réseau ou client.

**Décision :** l’audit statique source→catalogue→consumer est terminé pour le passif d’armure physique du 3035. L’implémentation locale existe dans les données et le calcul de dégâts. La vérification dynamique actuelle n’a pas été exécutée; la fonctionnalité historique complète, l’acceptation humaine et l’exigence parente restent ouvertes.

## Source et identité

Source native déclarée pour `PUBLIC 4.20.0.315 EUW/en_GB` :

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\3035.inibin`

Le registre `docs/fidelity_sources_4_20.json` l’identifie sous `OLS-fabaaa47-3c8c-578e-a191-1f550edf29cc`, 513 octets, SHA-256 `c84453eb7de3c9511c71ccc131d0fdfd866e9f79cd43f8230f04e86aa82974db`. Le hachage relu pendant ce lot correspond.

Le membership conservé indique une correspondance octets/MD5 dans le manifeste sélectionné; le membre correspondant est listé sous projet `lol_game_client` version `0.0.1.7`, release `0.0.0.239`. La priorité effective du fichier dans le runtime historique n’est pas qualifiée par cette correspondance.

Le reçu existant `docs/fidelity_community_review_4_20.json` compare 68 champs au miroir `LeagueSandbox-Default/Items/3035/3035.json` : 68 égaux, 0 différents, 0 clé native manquante. Le SHA du miroir est `13cbb229ecc789fa53f16e192ae1b3d5663f0ccc382ec49e8b48bc232c64c4a4`. Son `ContentFormatVersion=4` est un format d’export; le commit exact du fichier et l’autorité serveur historique ne sont pas établis.

Le lecteur local en lecture seule `tools/project-plan/reference_inibin.py` a décodé le fichier nommé. Le champ `Data*Effect1Amount` vaut `0.3499999940395355` en float32 (valeur attendue : 0,35); `Data*FlatPhysicalDamageMod` vaut 40; `Data*Price` vaut 1065, avec composants 1037 et 1036. Les champs natifs servent ici à vérifier l’identité et la valeur; le miroir communautaire ne remplace pas la source native.

## Donnée et consumers courants

`data/4.20/shop_foundation.json`, item 3035, porte `damage=40`, `armor_penetration_percent=0.35`, `unique_penetration=true`, recette 1037+1036, coût total local 2300 et le même `source_sha256` que le fichier natif. `data/4.20/map10_shop_admission.json` déclare `3035` autorisé.

Chemin identifié dans le code actuel :

- `crates/core/src/shop.rs:223-234` agrège les bonus d’inventaire. Il compose les pourcentages multiplicativement et n’ajoute pas deux fois le passif d’un même ID lorsque `unique_penetration` est vrai.
- `crates/core/src/progression.rs:82-86` transmet la pénétration d’armure aux `Stats`.
- `crates/core/src/penetration.rs:4-15` traite les dégâts physiques par `effective(armure, pénétration plate, pourcentage)`. Pour une armure positive, le code calcule `max(armure × (1 − pourcentage) − pénétration plate, 0)`; une armure nulle ou négative est laissée inchangée. Les entrées non finies, pourcentage hors `[0,1]` ou pénétration plate négative sont refusées.
- `crates/core/src/damage.rs:91,119` passe par `penetrated_defenses` avant mitigation pour les champions et les unités.

Tests déjà présents, non exécutés dans ce lot : `penetration.rs` contient un cas de dégâts physiques qui achète 3035 avec 3134, et un cas sur les unités du monde. Ils vérifient une combinaison, pas le cas isolé du seul 3035. Le test des bornes de `effective` vérifie la formule générique, sans prouver le runtime actuel.

## Attendu, observé et contrôles

- Nominal attendu dans le modèle local : avec 100 armure, 35 % et aucune pénétration plate, l’armure transmise à la mitigation vaut 65.
- Limite attendue dans le modèle local : avec 0 ou −20 armure, cette fonction retourne respectivement 0 ou −20 sans appliquer le pourcentage.
- Observé statiquement : champ natif décodé à 0,349999994 en float32; donnée locale à 0,35 avec source SHA identique; admission Map10 vraie; consumers et garde de résistance repérés. La formule du code correspond à 65 pour l’exemple nominal et préserve les résistances non positives. Aucun résultat de gameplay n’a été observé.
- Contrôles réellement effectués : SHA-256 du fichier natif et des fichiers courants; décodage en lecture seule du seul INIBIN 3035; lecture ciblée des reçus de comparaison, des deux entrées JSON et des callsites.
- Contrôles non exécutés : tests Rust, compilation, binaire, achat en jeu, dégâts observés, réseau, client graphique et serveur historique.

Empreintes courantes utiles pour la reprise :

| Fichier | SHA-256 |
|---|---|
| `data/4.20/shop_foundation.json` | `504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae` |
| `data/4.20/map10_shop_admission.json` | `6393e7c2a39abed63b6f3db36c265e94d5ce2fc5435e29c17ccf012f288ad485` |
| `crates/core/src/shop.rs` | `3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0` |
| `crates/core/src/progression.rs` | `eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766` |
| `crates/core/src/penetration.rs` | `7a4e2b53c0f8bbcdd0c0047a880e393d2dfcfaa6e6496ddff6bc83acdc87fd41` |
| `crates/core/src/damage.rs` | `0d579a7b4e7a3941df7e70f78d62029c9f34df0c345749c2adc17153f9624387` |

## Écarts et condition de reprise

Restent ouverts : autorité et sémantique du serveur 4.20.0.315; sélection/precedence effective de la ressource dans le runtime; résultat avec le seul objet 3035 lié à un build courant; interaction sur champion, unité et réseau; affichage client; acceptation humaine. Le comportement d’empilement entre objets différents n’est pas déduit de la seule propriété locale `unique_penetration`.

Proposition documentaire non inscrite au registre : `OPEN-ITEM-3035-CURRENT-PENETRATION-VERIFY`. Pour la reprendre, il faudra une vérification autorisée et liée aux empreintes courantes, avec achat isolé de 3035, `Stats.armor_penetration_percent=0.35`, un nominal à 100 armure donnant 65 avant mitigation, une limite à armure non positive, puis un résultat séparé sur champion et unité. Toute comparaison serveur devra nommer sa source versionnée; l’acceptation humaine reste distincte.

## Relecture des sept critères

1. Exigence parente et frontière limitée à un seul passif du 3035.
2. Source native identifiée, rehachée, décodée et comparée; limites de version et de precedence déclarées.
3. Chaîne actuelle d’agrégation, de `Stats` et de mitigation identifiée.
4. Cas nominal/limite définis et résultats statiques explicités; aucun test/runtime n’est présenté comme exécuté.
5. Écarts et conditions de reprise nommés.
6. Vérification fonctionnelle restante dotée d’un ID proposé et de critères précis; aucun statut de tâche n’est modifié.
7. Rapport daté, empreintes et chemins de preuve consignés.

**Clôture limitée :** cartographie statique du passif 3035 terminée. Implémentation locale présente; comportement en exécution et fidélité serveur non vérifiés. Aucun code de jeu, registre, goal, Plan, application de suivi ou base modifié. Aucun logiciel installé, aucune migration appliquée, aucun test/build/runtime exécuté.
