# SYS-01.2-02 — ITEM-3117-SCOPE : Boots of Mobility, source et consommateur actuel

Vérification du 2026-11-03. Unité `AUD-SYS-01.2-02-ITEM3117-SCOPE-SOURCE-CONSUMER-01`.

## 1. Périmètre et critère de fin

Audit **statique borné** du lien entre la définition native 4.20 de l'objet 3117, le comparatif officiel 4.20.1 et la réponse de la boutique OpenLeague courante. Le lot est clos si les identités et valeurs pertinentes sont contrôlées, si l'entrée réellement consommée et le refus applicable sont établis, et si les questions historiques non résolues ont une condition de reprise.

La tâche `ITEM-3117-SCOPE` (D07, exigence `OLF-38c1f7c7-f098-5df1-8af3-6a57e029f071`) reste **`a_qualifier`** : son critère exige une décision prouvée de disponibilité historique, que cet audit ne fournit pas. `SYS-01.2-02`, le prérequis `D01-SYS-01-1` et le jeu restent ouverts. Aucun statut, case, goal ou registre n'est modifié.

## 2. Sources et provenance

- Client fourni, sélection EUW 4.20.0.315 : `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\DATA\Items\3117.inibin`. Taille 569 octets, SHA-256 `717e289dfee290305cdd25b56ce0d177c68ebeaf0a30bfd54a535bb7503ab051`, MD5 `dd964fc3a98ec6381183ef97bc2689ac`, contrôlés sur les octets actuels. Le manifeste `docs/reference_native_skin_loader_sources/native-release-membership.json` à la ligne 31490 le rattache au projet `lol_game_client` 0.0.1.7, membre 0.0.0.243. La priorité effective des surcharges au runtime n'est pas qualifiée.
- Le lecteur existant `tools/project-plan/reference_inibin.py` décode directement ce fichier : `Data.Price=475`, `InStore=1`, `CanBeSold=1`, `RecipeItem1=1001`, `FlatMovementSpeedMod=105`. Le décodage antérieur `data/4.20/native_item_audit.json` à la ligne 3960 correspond au même SHA. Son `InventoryIcon=3004_Assault_Treads.dds` est une valeur native observée ; cet audit ne juge ni l'identité visuelle ni une corruption.
- Comparatif officiel enregistré : `E:\mapslol3v3\Full_project_audit_2026-10-20\official_reference\item.json`, Riot Data Dragon **4.20.1 en_US**, 237361 octets, SHA-256 `676c7ec03d389de78f40f8a769804b59636e5245386ce200da5310e72ae259c1`. `/data/3117` donne recette 1001, prix de combinaison 475, prix total 800, revente 560 et `purchasable=true`. Le texte décrit +25 vitesse, puis +105 après cinq secondes hors combat ; `Effect8Amount=25` et `FlatMovementSpeedMod=105` sont présents. Cette version et cette locale sont distinctes du binaire client sélectionné.
- La ligne 3117 n'a pas de propriété `maps` propre dans ce comparatif ; `basic.maps[10]=true` est une valeur générale. La ressource native `LEVELS/Map10/Items.inibin` a déjà été qualifiée dans l'addendum V1075 de `docs/AUDIT_SYS01202_ITEM3116_RYLAIS_CRYSTAL_SCEPTER_2026-11-03.md` : ses 98 clés sont `UnpurchasableItemList.Item0..97`. La lecture ciblée indique 3117 absent de cette liste. Cela signifie seulement qu'il n'est pas explicitement listé comme non achetable dans **cette** ressource. La décision finale dépend encore d'autres listes, paramètres et consommateurs natifs non établis ; aucune disponibilité historique sur Map10 n'est déduite.

## 3. Consommateur réel et réponse actuelle

La trace `docs/fidelity_requirement_trace_4_20.json` à la ligne 2517012 associe l'INIBIN `OLS-085082a5-ef77-5a37-8a87-be60e6dad36e`, le catalogue officiel `OLS-b3343643-2fe6-513b-b286-7c03b86b8409` et le consommateur `OLC-77cae4b8-d7e1-5c66-b00b-880660dbf57b` ancré à `crates/core/src/shop.rs:86`. Son statut `associated_sources_and_current_entrypoints` décrit une association, pas une fonctionnalité acceptée. Plusieurs chemins de source courante du registre gardent l'ancien préfixe `E:\OpenLeague` ; les fichiers effectifs inspectés sont sur `F:\OpenLeague` et leurs SHA figurent dans le résultat du contrôle.

`data/4.20/items.ron:1162` contient 3117 comme donnée héritée. La recherche littérale de `items.ron` dans `crates`, `launcher` et `tools` n'a trouvé aucun chargement nommé ; elle n'exclut pas toute lecture dynamique non repérée. Le consommateur boutique inspecté charge explicitement `data/4.20/shop_foundation.json` (`shop.rs:39`), dont les 33 entrées ne contiennent pas 3117. `data/4.20/map10_shop_admission.json` a aussi 33 entrées, sans 3117.

La cotation `quote_with_counts` appelle `item(target)` et renvoie `item behavior not implemented` si l'ID manque (`shop.rs:86`). L'achat `buy_item` fait la même vérification (`shop.rs:263`) **avant** `map10_available`. Pour 3117, le chemin actuel s'arrête donc à l'absence du catalogue ; l'absence d'admission Map10 constitue une deuxième lacune, non la raison du premier refus. Le témoin 1001 existe dans le catalogue courant avec prix 325 et dans l'admission locale.

## 4. Attendu, observé et contrôles

| Cas | Attendu dans ce lot | Observé | Portée |
| --- | --- | --- | --- |
| Source 3117 | Fichier 4.20 membre et valeurs relisibles | 569 octets, SHA/MD5 et cinq champs décodés concordent | Octets et décodage, pas exécution Riot |
| Comparatif 4.20.1 | Version, recette, prix et texte identifiés | SHA et `/data/3117` concordent | Référence distincte du client 4.20.0.315 |
| Témoin courant 1001 | ID présent dans l'entrée boutique | Présent, prix 325 ; admission locale présente | Vérification JSON statique, aucun `quote(1001)` exécuté |
| Refus courant 3117 | ID absent ; garde explicite avant admission | Absent des deux JSON ; garde `quote` et garde `buy_item` vérifiées dans la source actuelle | Conclusion statique du chemin ; aucun `quote(3117)` ni achat exécuté |
| Admission historique Map10 | Décision sur preuve native complète | Non décidée | `InStore` et absence d'une liste ne suffisent pas |

Commande exécutée : `python E:\mapslol3v3\audit_sys01202_item3117_scope_20261103\validate_item3117.py`. Résultat : `PASS_STATIC_SCOPE`, **26/26** contrôles ; détail attendu/observé et SHA courants dans `E:\mapslol3v3\audit_sys01202_item3117_scope_20261103\result.json`. Le script vérifie le vrai fichier natif, les 98 clés de la liste Map10, le comparatif, les deux JSON consommés et l'ordre des gardes dans `shop.rs` sans écrire dans le produit.

Aucun Cargo, test Rust courant, jeu Riot, serveur, client graphique, achat, vente, déplacement, pixel ou acceptation humaine n'a été exécuté. Le binaire de test préexistant date du 2026-10-21 et n'est pas utilisé pour qualifier le code courant.

## 5. Écarts et inconnues

1. `ITEM-3117-SCOPE` ne peut pas être clos : `InStore=1`, `purchasable=true` et `basic.maps[10]=true` ne prouvent pas ensemble l'admission finale dans le client 4.20.0.315 et sur Map10. Reprendre avec le lecteur et les paramètres effectifs de `ItemInclusionList`/`UnpurchasableItemList`, une configuration serveur attribuable à cette version, ou une observation native reproductible. Ne pas refaire le census V1075 sans nouvelle entrée.
2. Le `+105` statique ne prouve ni la transition `+25 → +105` après cinq secondes ni la règle de cumul et le traitement du combat. Reprendre avec une source de règle serveur versionnée et un test courant ciblé après implémentation autorisée.
3. `items.ron` contient une ligne 3117, mais la boutique inspectée ne la consomme pas. Le catalogue et l'admission effectifs sont incomplets pour cet objet. Ni achat, ni vente, ni présentation n'ont été qualifiés.
4. Le critère `acceptance` de `ITEM-3117-SHOP` parle de modèles, animation, VFX, audio et HUD, alors que son titre porte sur la boutique, la recette, l'achat, la vente et l'inventaire. Cette incohérence de plan doit être corrigée dans un lot autorisé distinct ; aucun registre n'est modifié ici.
5. Les chemins historiques `E:\OpenLeague` dans certains liens de registre doivent être rapprochés du dépôt actuel `F:\OpenLeague` avant toute vérification globale d'ancres. Le contrôle ciblé de ce lot utilise les fichiers actuels et leurs SHA.

## 6. Corrections et conditions de fin distinctes

Réutiliser les tâches existantes, sans créer de doublons : `ITEM-3117-SCOPE` pour la décision historique documentée ; `ITEM-3117-SHOP-PRIX` et `ITEM-3117-SHOP-RECETTE` pour les montants, composants et refus ; `ITEM-3117-SERVER-STAT-FlatMovementSpeedMod` et `ITEM-3117-SERVER-PASSIF` pour les valeurs, transition hors combat, cumul et tests ; `ITEM-3117-SHOP` pour l'intégration boutique et présentation après ses dépendances. Leurs critères de fin doivent exiger une version/source identifiée, un nominal et les refus applicables, puis une preuve runtime actuelle. Ces travaux ne sont ni exécutés ni déclarés terminés par le présent audit.

## 7. Relecture et décision

Les sept rubriques de `docs/audit/AUDIT_CHARTER.md` sont couvertes pour **ce seul sous-audit source → consommateur/refus** : périmètre, source, consumer, attendu/observé statiques, écarts, corrections existantes et preuves datées. Verdict : `AUDIT_BORNÉ_TERMINÉ`, implémentation boutique `ABSENTE_DU_CATALOGUE_CONSOMMÉ`, vérification `STATIQUE_26/26`, acceptation humaine `NON_DEMANDÉE_POUR_CET_AUDIT`. `ITEM-3117-SCOPE` et `SYS-01.2-02` restent ouverts.

Relecture indépendante non mutante du 2026-11-03 : **PASS** sur les 26 résultats, les sources, les ancres, les limites Map10 et la séparation entre audit et fonctionnalité. Elle n'a relancé aucun test.

Éléments conservés : `docs/fidelity_requirement_trace_4_20.json:2517012`, `docs/reference_native_skin_loader_sources/native-release-membership.json:31490`, `data/4.20/native_item_audit.json:3960`, le rapport V1075 ci-dessus, le script et son résultat. Aucune donnée du plan, base, interface, code produit, asset ou goal n'est modifiée.
