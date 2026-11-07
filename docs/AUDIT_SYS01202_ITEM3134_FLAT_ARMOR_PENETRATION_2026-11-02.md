# SYS-01.2-02 — item 3134 : pénétration d’armure plate et consumer actuel

Date de contrôle : 2026-11-02 UTC. Unité : `AUD-SYS01202-ITEM3134-FLAT-ARMOR-PENETRATION-01`. Exigence parente : `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`.

## Lot, frontière et décision

Question : la valeur d’armure pénétrée par le Brutaliseur dans le client 4.20 est-elle reliée à la donnée Map10 et au consumer Rust courant ?

Résultat attendu de la cartographie : identifier le champ natif `Effect2Amount`, vérifier sa valeur et sa relation au bonus local `armor_penetration`, confirmer l’admission Map10 et relier le bonus au calcul de dégâts physiques. Nominal local retenu : 100 armure avec 10 de pénétration plate donne 90 armure avant mitigation. Limite : l’armure nulle ou négative n’est pas modifiée; une armure positive inférieure à 10 est ramenée à zéro après pénétration.

**Décision :** audit statique source→catalogue→consumer terminé pour la pénétration plate du 3134. Le bonus est présent dans les données et emprunte le chemin physique déjà cartographié dans V841. La vérification d’exécution actuelle et la fidélité historique ne sont pas établies. Cette unité ne clôt ni l’item entier ni l’exigence parente.

## Source et identité

La source native `DATA/Items/3134.inibin` est inscrite dans `docs/fidelity_sources_4_20.json` sous `OLS-9e285db5-909d-5449-a57a-de07c85fc9d9` : 564 octets, SHA-256 `3c9076c0f152da74ecbc7d593f27984bf8c3b3ad07b2deafaa79a534d5a4ba77`. La source est sous la release client `0.0.1.68` attribuée au build PUBLIC `4.20.0.315 EUW/en_GB`; le hash a été relu et correspond.

Le reçu de membership signale une correspondance du chemin, des octets et du MD5 dans le manifeste sélectionné, avec un membre `lol_game_client` project release `0.0.1.7`, release `0.0.0.242`. Il ne qualifie pas la precedence effective de la ressource au runtime historique.

Le reçu de comparaison communautaire donne 72 champs égaux, 0 différents, 0 clé native manquante. Le miroir `LeagueSandbox-Default/Items/3134/3134.json` a pour SHA-256 `7dc077c3b61e7c3249877314e6d304872a1b989070d7f4439fbb41ac029e000f`; `ContentFormatVersion=4` est un numéro de schéma d’export, pas un patch, et le commit exact du fichier reste inconnu.

Le lecteur existant en lecture seule `tools/project-plan/reference_inibin.py` décode `Data*Effect2Amount` à `10`. Le même fichier décode `Data*FlatPhysicalDamageMod=25`, `Data*Effect1Amount=-0.10000000149011612` et `Data*Price=617`, avec composants 1036 et 1036. Seul le champ 2 est dans le périmètre de cette unité; les autres champs ne sont pas requalifiés ici.

## Donnée et consumer courant

`data/4.20/shop_foundation.json` (item 3134) déclare `armor_penetration=10`, `armor_penetration_percent=0`, `unique_penetration=true`, `damage=25`, `cooldown_reduction=0.1`, recette 1036+1036 et coût total 1337. Son `source_sha256` est le même que celui du fichier natif. `data/4.20/map10_shop_admission.json` indique `3134` autorisé.

Le chemin partagé déjà vérifié pour l’effet physique est réutilisé depuis `AUDIT_SYS01202_ITEM3035_ARMOR_PENETRATION_2026-11-02.md`, sans rescanner ses callsites : `shop::bonuses` → `progression::stats` → `penetration::effective` → `damage`. Les empreintes actuelles des quatre fichiers de code sont identiques à celles consignées en V841. Pour le 3134, le code agrège 10 en pénétration plate et la fonction actuelle soustrait cette valeur de l’armure positive avant le plancher à zéro; `damage.rs` applique le résultat avant mitigation des champions et unités.

Tests présents mais non exécutés :

- `penetration.rs::unique_passives_deduplicate_but_direct_stats_stack` achète deux 3134 et attend une seule pénétration plate de 10.
- `penetration.rs::source_owned_items_change_damage_without_mutating_target_stats` achète le 3134 avec le 3035 et compare les dégâts physiques à la formule combinée.
- `penetration.rs::world_targets_receive_identical_post_mitigation_amount_once` mélange également 3134 et 3035; ce n’est pas un contrôle isolé du 3134.

## Attendu, observé et contrôles

- Nominal attendu dans le modèle local : `effective(100, 10, 0) = 90` avant mitigation.
- Limite attendue dans le modèle local : `effective(5, 10, 0) = 0`; `effective(0, 10, 0) = 0`; `effective(-20, 10, 0) = -20`.
- Observé statiquement : le champ natif décodé vaut 10; le catalogue reprend la valeur 10, le hash source concorde et Map10 admet le 3134. Le code courant exprime bien la soustraction et le plancher. Aucun achat ni dégât n’a été observé en exécution.
- Contrôles effectués : lecture en lecture seule du champ ciblé; SHA-256 de la ressource native; réutilisation ciblée du reçu 72/72 et du reçu de membership; lecture des seules lignes de catalogue/admission, du chemin de test 3134 et comparaison des empreintes courantes avec V841.
- Contrôles non exécutés : tests Rust, compilation, lancement de binaire, achat, observation de statistiques ou dégâts, réseau, client graphique, serveur historique.

## Écarts et reprise

L’identité source, la membership selon le reçu existant, le lien de donnée et le consumer actuel sont établis dans les bornes documentées. Restent ouverts : precedence effective au runtime, règle serveur 4.20.0.315, résultat isolé du seul 3134 sur un build lié aux empreintes présentes, comportement réseau, acceptation humaine et interaction historique entre passifs « uniques » d’objets différents. La concordance du champ numérique ne démontre pas à elle seule sa sémantique serveur.

Proposition documentaire non inscrite au registre : `OPEN-ITEM-3134-CURRENT-PENETRATION-VERIFY`. Conditions de reprise : vérification autorisée et liée aux sources courantes; achat isolé qui donne `Stats.armor_penetration=10`; cas nominal à 100 armure donnant 90 avant mitigation; limite sous 10 et résistance non positive; second 3134 sans doublement; hit physique observé séparément sur champion et unité. Toute comparaison historique doit citer une autorité versionnée. L’acceptation humaine reste distincte.

## Relecture des sept critères

1. Exigence et frontière limitées au champ d’armure plate du 3134.
2. Fichier natif, identité, valeur décodée, membership et limites du miroir communautaire consignés.
3. Donnée Map10 et chemin consumer actuel établis en réutilisant V841.
4. Attendus et constat statique explicites; tests et runtime non présentés comme exécutés.
5. Inconnues et conditions de reprise précises.
6. Vérification restante dotée d’un ID stable proposé et de critères; aucun statut modifié.
7. Rapport daté avec source, reçus et empreintes vérifiés.

**Clôture limitée :** cartographie statique du bonus physique 3134 terminée. Implémentation locale présente; vérification d’exécution et fidélité serveur non établies. Aucun code de jeu, registre, goal, Plan, application ou base modifié; aucun logiciel installé, aucune migration, aucun test/build/runtime lancé.
