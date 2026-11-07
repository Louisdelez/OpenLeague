# SYS-01.2-02 — quatre objets 4.20, sources et refus de boutique

Lot documentaire du 2026-11-03. Quatre unités atomiques distinctes :

| Audit | Exigence | Tâche source |
| --- | --- | --- |
| `AUD-SYS-01.2-02-ITEM3122-SCOPE-SOURCE-CONSUMER-01` | `OLF-2995fca1-b55f-58f3-bcc8-699842bb0449` | `ITEM-3122-SCOPE` |
| `AUD-SYS-01.2-02-ITEM3123-SCOPE-SOURCE-CONSUMER-01` | `OLF-54d66b94-a6ef-5b89-85fa-0b681946a168` | `ITEM-3123-SCOPE` |
| `AUD-SYS-01.2-02-ITEM3124-SCOPE-SOURCE-CONSUMER-01` | `OLF-9d4308da-54fa-5bf7-b3a7-93c617b9bdfa` | `ITEM-3124-SCOPE` |
| `AUD-SYS-01.2-02-ITEM3128-SCOPE-SOURCE-CONSUMER-01` | `OLF-d02758c6-662a-5547-9c7b-b65522ca5670` | `ITEM-3128-SCOPE` |

Chaque unité ferme seulement le **sous-audit statique source → consommateur actuel/refus**. Les quatre tâches `SCOPE` restent `a_qualifier` : leur critère de décision historique sur les cartes et restrictions n'est pas satisfait par ce lot. L'audit, l'implémentation, la vérification runtime et l'acceptation sont comptés séparément.

## Question, entrées et arrêt du lot

Question : pour chacun des quatre IDs, la définition native choisie appartient-elle à la référence 4.20, quelles valeurs de base et quelles restrictions la source donne-t-elle, et quelle est la réponse du consommateur boutique réel aujourd'hui ?

Critère de sortie : preuve individuelle des octets, du membership RADS, du décodage prix/recette, du comparatif officiel et de l'état des deux données consommées ; preuve commune de l'ordre des gardes Rust ; attendu/observé et inconnues spécifiques. Arrêt après ces quatre IDs. Ni le lancement du jeu original, ni Cargo, ni une recherche REA répétée ne sont nécessaires à ce sous-audit ; l'exécution et la politique historique finale demeurent des travaux distincts.

Le registre `docs/fidelity_requirement_trace_4_20.json` associe les quatre exigences aux INIBIN et au consommateur `OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b` (`crates/core/src/shop.rs:86`) aux lignes 2517532, 2518104, 2518676 et 2519248. Son statut `associated_sources_and_current_entrypoints` et `unknown_ids=[]` ne valent pas preuve d'une mécanique ou d'une disponibilité historique complète. Le prérequis D01 et `SYS-01.2-02` restent ouverts.

Le validateur projette en une seule recherche `rg` quatre fenêtres de cette grande trace et contrôle pour chaque unité l'ID de tâche, l'ID d'exigence, la source native, le sélecteur officiel, le consommateur, le statut de lien et `unknown_ids=[]`. Il ne recharge pas les trois registres massifs ni ne transforme leurs liens structurels en audits terminés.

## Source commune et consommateur réellement chargé

Les quatre INIBIN viennent du client fourni `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\<ID>.inibin`, référence `4.20.0.315`, EUW/en_GB. Le lecteur existant `F:\OpenLeague\tools\project-plan\reference_inibin.py` décode directement les champs `Data`. Les empreintes actuelles concordent avec `data/4.20/native_item_audit.json` et avec les lignes propres à chaque objet de `docs/reference_native_skin_loader_sources/native-release-membership.json`. Ce dernier manifeste contient d'autres écarts dans le corpus global (`all_payloads_match=false`) ; seuls ces quatre membres ont été vérifiés ici.

Le comparatif est le fichier Riot Data Dragon `E:\mapslol3v3\Full_project_audit_2026-10-20\official_reference\item.json`, version **4.20.1 en_US**, 237361 octets, SHA-256 `676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1`. Ce snapshot distinct ne remplace pas une politique serveur/cliente observée pour le build 4.20.0.315. `basic.maps[10]=true` est général ; une surcharge par objet peut le restreindre.

Le consommateur Rust courant charge `data/4.20/shop_foundation.json` dans `crates/core/src/shop.rs:39`. Ce catalogue a 33 entrées ; les quatre IDs en sont absents. `items.ron` possède les quatre lignes, mais la recherche littérale de `items.ron` dans `crates`, `launcher` et `tools` (fichiers `.rs`, `.py`, `.ts`, `.tsx`, `.js`) n'a trouvé aucun consommateur nommé ; cela ne démontre pas l'absence de toute résolution dynamique. L'admission locale `data/4.20/map10_shop_admission.json` compte elle aussi 33 entrées, sans ces IDs.

La garde `quote_with_counts` de `shop.rs:86` retourne `item behavior not implemented` quand `item(target)` manque. La garde `buy_item` à `shop.rs:263` fait le même lookup avant `map10_available`. Le refus courant des quatre IDs résulte donc d'abord de l'absence du catalogue, quel que soit le statut Map10. Le témoin 1001 est présent avec prix 325. Ceci est une **déduction statique contrôlée sur le code actuel**, pas un achat ou un appel Rust exécuté.

Empreintes communes contrôlées une seule fois : `shop.rs` SHA-256 `3db7b79f20d15e95b6b92affe0087e730c9110d876ea41cc36416435159a2cd0`, `shop_foundation.json` `504ad86b20157b91b4aee8c174dbee43a5689dcb2cdee3975e8dbbdf804852ae`, `map10_shop_admission.json` `6393e7c2a39abed63b6f3db36c265e94d5ce2fc5435e29c17ccf012f288ad485`. La ressource native `LEVELS/Map10/Items.inibin` a le SHA-256 `2e0e874e036429fee1bda6c5d1942f8e217eda7468b6b5bea5eac0a4288456f7` ; ses 98 clés correspondent exactement à `UnpurchasableItemList.Item0..97`. Sa liaison statique à une garde de boutique cliente et ses limites de provider/flags/serveur sont déjà documentées dans `docs/AUDIT_SYS01202_MAP10_NATIVE_SHOP_GUARD_2026-11-03.md`. Ce lot relit seulement les quatre présences/absences ; il ne rejoue pas son désassemblage ni ne démontre la sélection effective de cette ressource en partie.

## Résultats individuels, attendus et observés

| ID et nom officiel | INIBIN exact, membership | Décodage natif `Price` + recette | Comparatif 4.20.1 | Liste native Map10 | Consommateur courant |
| --- | --- | --- | --- | --- | --- |
| **3122 Wicked Hatchet** | 570 o, SHA `13ec74463971dbc77e186a621a03db824e68863b0534a978707088280b544116`, MD5 `561bbcafa9bc99b969e8786338c210dd`, release membre `0.0.0.243` | 440 ; 1051 + 1036 | total 1200, vente 840 ; `maps[1]=false`, aucune surcharge Map10 | 3122 absent | Absent du catalogue/admission ; garde de refus |
| **3123 Executioner's Calling** | 576 o, SHA `31ef1bac2d01a27223b0827020ee071bc433c3a05498e8f0c5989f5cc45ea971`, MD5 `f108b3f6fbc5d2271b43a759a4e168bf`, release `0.0.0.243` | 740 ; 3093 + 1036 | total 1900, vente 1330 ; pas de surcharge `maps` | 3123 absent | Absent du catalogue/admission ; garde de refus |
| **3124 Guinsoo's Rageblade** | 582 o, SHA `4246f73600fa093cb281dc8bfd44297ec752ce6ef3d163eb48963c633c9dc3cd`, MD5 `5cfbdf568e63c128176b02da78fc6a0d`, release `0.0.0.242` | 865 ; 1026 + 1037 | total 2600, vente 1820 ; pas de surcharge `maps` | 3124 absent | Absent du catalogue/admission ; garde de refus |
| **3128 Deathfire Grasp** | 602 o, SHA `d0bfaf23bbc3a7165f3f01d54d627cec58e37f72db50cde8a8f8a41559f64f34`, MD5 `cba897606fadbf17caf62be758ffc48c`, release `0.0.0.254` | 680 ; 1058 + 3108 | total 3100, vente 2170 ; **`maps[10]=false`** | **3128 présent** | Absent du catalogue/admission ; garde de refus générique |

Pour chaque ligne, `Data.InStore=1`, `Data.CanBeSold=1`, le champ natif `Price` égale `gold.base` (prix de combinaison) du comparatif 4.20.1 et les deux premiers composants concordent, après normalisation stricte des entiers INIBIN parfois stockés comme chaînes ; les slots de recette 3 et 4 valent zéro. Le membre RADS est `lol_game_client` 0.0.1.7 avec bytes et MD5 concordants. Ces constats identifient la source et les valeurs ; ils ne prouvent pas à eux seuls l'achetable sur toute carte. Les prix totaux et de vente proviennent du comparatif officiel 4.20.1, pas du seul champ `Price` natif.

### 3122 — décision propre et reprise

**Attendu/observé :** la source 4.20 porte le prix 440 et la recette 1051+1036 ; le comparatif 4.20.1 confirme ces deux valeurs, total 1200, vente 840 et exclut explicitement la carte 1. La source Map10 consultée ne liste pas 3122 comme non achetable. Le code actuel, lui, refuse l'ID faute de catalogue.

**Limite/correction :** l'absence de surcharge `maps[10]` et de 3122 dans une liste Map10 ne prouve pas l'admission finale 4.20.0.315. Le saignement après coup critique décrit dans le comparatif n'est pas testé. Reprendre `ITEM-3122-SCOPE` avec le provider/flags et la décision serveur ou une observation native attribuable ; réutiliser `ITEM-3122-SHOP-PRIX`, `ITEM-3122-SHOP-RECETTE`, `ITEM-3122-SERVER-PASSIF` et `ITEM-3122-SHOP` pour les corrections fonctionnelles, avec prix/composants/effet/refus vérifiés en runtime après qualification du périmètre.

### 3123 — décision propre et reprise

**Attendu/observé :** la source porte prix 740 et recette 3093+1036 ; le comparatif donne total 1900, vente 1330 et n'a pas de surcharge `maps`. 3123 est absent de la liste native Map10 et du catalogue actuel ; la garde courante refuse l'ID.

**Limite/correction :** ni cette absence ni `basic.maps[10]=true` ne prouvent l'admission historique finale. L'effet Grievous Wounds, sa durée et ses cibles ne sont pas qualifiés par cet audit. Reprendre `ITEM-3123-SCOPE` sur provider/flags et serveur ou observation native ; réutiliser `ITEM-3123-SHOP-PRIX`, `ITEM-3123-SHOP-RECETTE`, `ITEM-3123-SERVER-PASSIF` et `ITEM-3123-SHOP` pour les comportements et leurs tests propres.

### 3124 — décision propre et reprise

**Attendu/observé :** la source porte prix 865 et recette 1026+1037 ; le comparatif donne total 2600, vente 1820 sans surcharge `maps`. 3124 est absent de la liste native Map10 et du catalogue actuel ; le refus courant est explicite dans le code.

**Limite/correction :** les stacks de vitesse/puissance et l'effet sous 50 % de PV du comparatif ne sont pas vérifiés sur la référence serveur. L'admission Map10 finale reste inconnue. Reprendre `ITEM-3124-SCOPE` sur provider/flags et serveur ou observation native ; réutiliser `ITEM-3124-SHOP-PRIX`, `ITEM-3124-SHOP-RECETTE`, `ITEM-3124-SERVER-PASSIF` et `ITEM-3124-SHOP`, avec contrôle du cumul, des seuils, des prix et des refus après qualification historique.

### 3128 — décision propre et reprise

**Attendu/observé :** la source porte prix 680 et recette 1058+3108 ; le comparatif donne total 3100, vente 2170 et **`maps[10]=false`**. La liste native `UnpurchasableItemList` contient également 3128. Ces deux éléments indépendants convergent vers une exclusion côté Map10, mais le provider exact et la décision serveur au runtime ne sont pas observés. Le code courant retourne le refus générique d'objet absent **avant** de lire son admission Map10.

**Limite/correction :** ne pas qualifier ce rapprochement comme une transaction historique refusée ni comme une admission Rust fidèle. L'actif Deathfire Grasp du comparatif, ses dégâts et son amplification restent hors de ce sous-audit. Reprendre `ITEM-3128-SCOPE` sur la configuration/provider/flags effectifs et la règle serveur ou une capture attribuable ; réutiliser `ITEM-3128-SHOP-PRIX`, `ITEM-3128-SHOP-RECETTE`, `ITEM-3128-SERVER-ACTIF` et `ITEM-3128-SHOP` selon la décision de carte, avec un refus Map10 explicite et vérifié si l'exclusion est confirmée.

## Contrôles, preuves et décisions de clôture

Commande réellement exécutée : `python E:\mapslol3v3\audit_sys01202_item_scope_batch_20261103\validate_item_scope_batch.py`. Résultat `PASS_STATIC_SCOPE`, **151/151** assertions attendues/observées : 15 contrôles communs, puis **34/34 par objet**. Reçu détaillé : `E:\mapslol3v3\audit_sys01202_item_scope_batch_20261103\result.json`. Script SHA-256 `fb8dff5360473fc1c0381cb42e7387e4f7aa0e7476e64112f1c0340d4eee480f` ; reçu de ce run SHA-256 `669a53d16e700bc2b16e6eec5d8a2eb0fa3d53864162dc281e032b47f5e9d56c`. Ces empreintes identifient ce run ; tout nouveau run change potentiellement l'horodatage du reçu.

Aucun Cargo, test Rust actuel, partie 4.20, achat/vente, effet serveur, affichage, pixel, audio ou acceptation humaine n'a été exécuté. Les résultats `quote`/`buy_item` sont déduits statiquement du code actuel et de ses JSON, avec un témoin présent ; ils ne sont pas présentés comme observations d'exécution. Le rapport de garde native Map10 cité est une preuve antérieure réutilisée, pas un nouveau test.

Les quatre tâches `ITEM-xxxx-SHOP` existent, mais leur champ `acceptance` dit « Modèles/animation/VFX/audio/HUD reliés à l'événement accepté » alors que leurs titres portent sur la boutique, l'achat, la vente et l'inventaire. Corriger ce critère dans un lot de plan autorisé avant toute clôture fonctionnelle ; le registre reste inchangé ici.

La relecture indépendante des sept rubriques pour **chacune** des quatre unités conclut **PASS** sur les liens de trace, les valeurs natives, les limites Map10, les corrections existantes et le compte 151 = 15 + 4 × 34. Verdict : les quatre sous-audits statiques sont clos ; aucun `ITEM-xxxx-SCOPE` ni comportement de jeu n'est terminé. Aucun Plan, goal, application de suivi, interface, base, registre protégé, code produit ou asset n'est modifié par ce lot documentaire.
