# Audit de liaison — passif et cumul de l’objet 3101 (Stinger)

Date : 2026-11-02  
Unité : `AUD-SYS01202-ITEM3101-PASSIVE-01`  
Tâche existante : `ITEM-3101-SERVER-PASSIF`  
Exigence : `OLF-de9f7f88-3320-5d28-8a89-8511691a0284`  
Prérequis : `ITEM-3101-SCOPE` (`partiel_a_terminer`)  
Source native principale : `OLS-446a1b39-0e8e-59a2-a11b-4ca0af960dab`

## Question, périmètre et critères de sortie

Question : le passif unique de réduction des délais de Stinger est-il relié à des données et à des consommateurs réels d’OpenLeague, et que démontrent les preuves 4.20 disponibles sur son cumul ?

Résultat attendu pour cette unité d’audit : identifier l’affirmation native, ses artefacts et leur provenance, le chemin local effectif jusqu’au calcul des délais, un cas nominal et les refus pertinents, puis isoler ce qui reste indémontré. La tâche du registre porte sur « Objet 3101 — Stinger : implémenter son passif et ses règles de cumul » ; elle est conditionnelle à la résolution du périmètre historique Map10.

Cette unité examine seulement la liaison statique de la réduction de délai de 3101 et les tests locaux existants. Elle ne qualifie pas la disponibilité historique de l’objet sur Map10, les autres statistiques/prix/recette, l’ensemble des règles de cumul de LoL, le client en partie, ni l’acceptation du jeu. Aucun code ni registre n’est modifié par cet audit.

## États séparés

- **Audit : terminé pour la liaison statique, les preuves locales et les limites énumérées ici.** Cela ne clôt pas l’exigence parente ni d’autres clauses de 3101.
- **Implémentation : partielle.** La donnée locale de 10 %, son agrégation et son acheminement vers les délais existent ; l’équivalence avec la mécanique serveur 4.20 et l’ensemble des règles « unique » restent à établir.
- **Vérification : partielle.** Deux tests d’un binaire local existant ont réussi. Ils ne sont ni une compilation de la source actuelle ni une exécution du serveur/client LoL 4.20.
- **Acceptation humaine : non demandée.** Aucune acceptation humaine n’est revendiquée.

## Sources et identité

### Source 4.20 fournie

Le dossier source est le client LoL 4.20 décompressé fourni par l’utilisateur, identifié dans les preuves du projet comme LoL 4.20.0.315, EUW/en_GB. Les trois artefacts suivants ont été relus dans `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\` :

| Fichier | Taille | SHA-256 | Observation |
|---|---:|---|---|
| `3101.inibin` | 547 octets | `1c38a8625b5295556fdb4f699d6c21a8871c82f3e6345699f313a21b0f20cc39` | Identité et membership déjà documentés dans l’audit 3101 attaque-speed. Le décodeur donne `Effect1Amount=10`; les clés ciblées `PercentCooldownMod`, `PercentCooldownReductionMod` et `CooldownReduction` n’y sont pas résolues. La signification de `Effect1Amount` n’est pas inférée ici. |
| `3101.luaobj` | 56 octets | `7402c8224b5579477d61f9160c326c9fce72bce179bc62645d5851983555beb0` | Source enregistrée `OLS-386803f0-bf2d-50e0-bd9b-f3a5de951010`. Membership exact du projet `lol_game_client` release `0.0.1.7`, membre `0.0.0.254`, empreinte manifeste MD5 `623b11414d3c337a0d501a5c0ee114bb`. La priorité runtime des overlays n’est pas qualifiée. |
| `3101.preload` | 82 octets | `f5e286bc20ed703efe4c34e5aef86d952fa3ce5b147178147aa8f7d17ddc7c2f` | Déclare `BBPreloadSpell` pour `sting`; ce préchargement d’asset n’établit pas le comportement du passif. |

Le parseur Lua 5.1 en lecture seule a validé le chunk de `3101.luaobj` : un seul opcode `RETURN` sans résultat, zéro constante et zéro prototype, fin exacte du fichier à l’octet 56. Cet artefact précis ne contient donc pas de corps de passif exploitable. La structure de chunk et l’opcode sont décrits par les sources Lua 5.1 officielles : [lundump.c](https://www.lua.org/source/5.1/lundump.c.html) et [lopcodes.h](https://www.lua.org/source/5.1/lopcodes.h.html). Cela ne prouve pas l’absence d’une règle serveur dans un autre binaire, une autre ressource ou un service non fourni.

La chaîne de texte native en_GB précédemment recensée (source `OLS-4bfd2207-a3dc-5790-871c-8816e9a7b10d`, SHA-256 `1dd19dfeb272790230ac2525ab83a71ca285546df21d271257ef6b5ea26941b3`) affiche « Stinger », « +40% Attack Speed » et « UNIQUE Passive: +10% Cooldown Reduction ». Cette preuve établit le texte présenté par le client, pas la mécanique faisant autorité côté serveur. L’entrée officielle de catalogue 4.20.1 citée dans la tâche donne la même description. Le catalogue 4.20.1 et les binaires client 4.20.0.315 restent des références distinctes.

### Donnée et code actuels sur F

`data/4.20/shop_foundation.json#/items/23` (`OLS-0423131f-6ac0-52ed-8973-d56afac44144`) porte `id=3101`, `cooldown_reduction=0.1`, `attack_speed=0.4`, et le SHA-256 natif exact de l’INIBIN ci-dessus. Sa description locale reprend la mention de passif unique à +10 %.

Chemin réel observé :

1. `crates/core/src/shop.rs:69` résout l’ID dans le catalogue ; `shop.rs:216,225-226` ajoute les réductions de délai en dédupliquant les occurrences du même ID d’objet.
2. `crates/core/src/progression.rs:88` borne le total à `cooldown::maximum_reduction()`.
3. `crates/core/src/cooldown.rs:13` calcule `base_seconds * (1 - reduction bornée)`, applique le minimum configuré, puis convertit en ticks.
4. Des consommateurs de sorts lisent ensuite cette stat et appellent le calcul de délai, notamment `annie.rs`, `annie_w.rs`, `annie_r.rs`, `ezreal_q.rs`, `ezreal_w.rs`, `ezreal_e.rs`, `ezreal_r.rs`, `spells.rs` et les modules de Trundle.

Le registre de trace rattache actuellement cette exigence à `OLC-b38bc16e-af3e-565e-8e4a-e8549549a702`, qui pointe seulement vers la recherche du catalogue. Les consommateurs précis sont déjà recensés dans `docs/fidelity_sources_4_20.json` : `OLC-be153768-fdac-5822-a737-7ffdbcb30611` (`progression.rs:88`, agrégation/cap de la stat) et `OLC-74c1a701-282b-5e1a-b9c2-34a27e61f7ab` (`cooldown.rs:11`, garde et réduction du délai). Les callsites de sorts confirment que la stat atteint des consommateurs de capacité ; les règles natives de leurs délais ne sont pas qualifiées par cette unité.

La configuration locale `data/4.20/cooldown_rules.json` fixe un plafond de `0.4` et un minimum de `0.0` seconde. Ses notes indiquent que le plafond natif Map10 de 40 % est directement récupéré, tandis que les corps des scripts serveur d’objets ne le sont pas ; le décodage de l’INIBIN ne fournit pas ici un mapping vérifié de `Effect1Amount` au CDR. La constante de 40 % n’établit pas à elle seule la fidélité de la mécanique complète de Stinger.

## Cas attendus, résultats observés et contrôles

### Cas nominal — partiellement démontré

- **Attendu local :** un 3101 admissible fournit une réduction locale de `0.1` ; elle est ajoutée au total puis plafonnée selon la règle locale.
- **Observé statiquement :** la ligne locale porte `0.1`; le code d’inventaire la somme et passe le résultat au calcul des délais.
- **Contrôle exécuté :** `cooldown::tests::different_unique_components_stack_up_to_native_cap --exact --nocapture` — réussi, 1 test. Le scénario inclut 3101 parmi les objets, observe un total de `0.4`, et vérifie qu’un délai de 10 s à 40 % donne 180 ticks. Il vérifie aussi le clamp des entrées `0.5` et `-0.2`.
- **Limite :** ce test ne distingue pas la contribution individuelle de 3101 au sein de l’ensemble et ne compare pas la cadence avec le serveur 4.20.

### Cumul du même objet — couverture indirecte

- **Attendu local :** les doublons du même ID ne multiplient pas la réduction ; les statistiques ordinaires d’un objet peuvent continuer à s’accumuler selon le code local.
- **Observé par test :** `cooldown::tests::unique_same_item_cdr_does_not_prevent_power_stacking --exact` — réussi, 1 test ; il utilise 3108, pas 3101.
- **Limite :** le mécanisme partagé est visible dans `shop.rs`, mais un cas direct avec deux 3101 n’a pas été exécuté. Le regroupement d’une passive « unique » entre des IDs différents n’est pas établi par ce test ni par l’artefact LuaObj vide.

### Refus et limites

- **Refus attendus par inspection statique :** ID absent du catalogue → `item behavior not implemented`; disponibilité Map10 explicitement fausse → `item unavailable on Map10`; disponibilité non renseignée → `item map availability not qualified` (`shop.rs:263-270`).
- **Résultat observé :** les gardes et messages sont présents dans le code ; aucun de ces refus n’a été exécuté pendant ce lot. Le prérequis `ITEM-3101-SCOPE` étant encore partiel, l’admissibilité historique de 3101 sur Map10 reste inconnue.
- **Règle locale de cumul :** les doublons du même ID sont dédupliqués ; les IDs distincts s’additionnent jusqu’au plafond local de 40 %. L’identité de groupe passif et les règles historiques de cumul entre items distincts ne sont pas prouvées par la source actuellement disponible.

### Binaire de test réellement exécuté

Les deux tests cités ont été lancés directement, sans rebuild, depuis `F:\OpenLeague\target\debug\deps\openleague_core-21eb81eb13817108.exe` : 787 789 824 octets, SHA-256 `46d3732181601e8bfdc1923857d66192fd2a18fba13fe7aa3bd2f80876f74e6d`, horodatage UTC du fichier `2026-10-21 10:19:25`. Chaque commande a renvoyé le code 0, 1 réussi, 0 échoué. Aucun `cargo test`, lancement de jeu, serveur historique ou client LoL n’a été exécuté. Les résultats qualifient uniquement cet exécutable et ces deux cas.

## Écarts et condition précise de reprise

1. Résoudre `ITEM-3101-SCOPE` avec une preuve de disponibilité historique 4.20/Map10. Tant que ce préalable demeure partiel, l’exigence fonctionnelle reste conditionnelle et non clôturable.
2. Pour confirmer le comportement natif, apporter une définition serveur faisant autorité, un mapping vérifiable des champs/effets vers le CDR, ou une observation isolée du serveur 4.20. Le texte du tooltip, `Effect1Amount=10` non interprété et le chunk client à retour vide ne suffisent pas.
3. Après obtention de cette source, exécuter un scénario direct : zéro/un/deux Stinger, autre item partageant éventuellement le même groupe unique, plafond, item refusé/inadmissible, puis comparer les sorties avec le contrat natif. Garder séparés les tests simulés Rust et l’exécution du jeu original.
4. Compléter la traçabilité en reliant l’exigence aux consommateurs recensés `OLC-be153768-fdac-5822-a737-7ffdbcb30611` et `OLC-74c1a701-282b-5e1a-b9c2-34a27e61f7ab`, en gardant le lien catalogue existant. Cette correction est identifiée, non appliquée : le registre et les bases du suivi sont hors périmètre d’édition pour ce travail.

Ne reprendre les recherches natives qu’à l’apparition d’un artefact serveur identifié, d’un mapping explicite de la clé d’effet, d’une trace native pertinente ou d’un nouveau callsite. Ne pas relancer les mêmes recherches de fichiers et parseurs en l’absence d’un tel indice.

## Vérification des sept rubriques et décision

- Exigence atomique, prérequis et frontières : identifiés.
- Source, identité, membership, empreintes et limites : documentés ; le fichier client précis est analysé, l’autorité serveur manque.
- Consommateur réel : chemin donnée → agrégation/cap → calcul → callsites identifié ; lien de registre incomplet noté.
- Cas nominal, cumul, refus : attendu et observé séparés ; deux tests existants réussis, refus statiques non exécutés.
- Manques et condition de reprise : nommés avec artefact/entrée requis.
- Tâche à réutiliser : `ITEM-3101-SERVER-PASSIF`; aucune nouvelle tâche fonctionnelle proposée. Le statut `a_faire`, `required=false` conditionnel et les cases du registre ne sont pas changés.
- Cohérence/portée : aucun succès technique n’est converti en acceptation humaine, validation serveur ou achèvement du jeu.

**Décision limitée :** l’audit de liaison statique est documenté pour cette unité. Le passif fidèle à LoL 4.20 et ses règles natives de cumul restent non vérifiés ; la tâche fonctionnelle n’est pas déclarée terminée. Le goal SYS-01.2-02 reste actif et partiel.

## Fichiers modifiés et empreintes de l’inspection

Seul fichier créé par ce lot : `docs/AUDIT_SYS01202_ITEM3101_PASSIF_2026-11-02.md`.

Aucun changement de code, d’application OpenLeague Plan/UI, de base de données, de registre de tâches, de goal, d’installation ou de migration n’a été effectué. Fichiers F inspectés :

| Fichier | SHA-256 |
|---|---|
| `data/4.20/shop_foundation.json` | `504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae` |
| `data/4.20/cooldown_rules.json` | `f35a4ce2aee181900555993d6824fd17c61c22a2d0e63b0ebb6d613f42e68805` |
| `crates/core/src/shop.rs` | `3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0` |
| `crates/core/src/progression.rs` | `eab515371edafb139b439028ad9f2828ed31cbfc90bb6d8ad54441fcc903f766` |
| `crates/core/src/cooldown.rs` | `fa6acaedb363c33e32e345511740b7e03df80891e2f8f0e718060f17f7083c61` |
| `docs/fidelity_requirement_trace_4_20.json` | consulté en lecture seule ; non modifié |
| `docs/completion_tasks_2026-10-20.json` | consulté en lecture seule ; non modifié |