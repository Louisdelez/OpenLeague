# V1148 — exécution post-publication Map10

## Périmètre clos

Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-POST-PUBLICATION-RUNTIME-01`.

Ce lot reprend les trois DDS Map10 exacts déjà validés par V1147 et continue le loader original depuis `0x98962A` jusqu’au retour `0x989695`. L’autorité est limitée aux octets épinglés de l’exécutable original et au runtime borné Unicorn/current-host D3D9. Aucun résultat de modèle n’est utilisé comme preuve.

## Résultat attendu et observé

Attendu : initialiser le gestionnaire natif, exécuter l’`AddRef` post-publication, l’insertion dans les structures du gestionnaire, l’affectation de `owner+0x88`, la libération de la référence temporaire, le flag prêt et le retour complet du loader.

Observé pour chacun des trois fichiers :

- le constructeur original `0x9783D0` publie un gestionnaire non nul à `[0x2D79030]` ; le builder `0x978820` n’est pas remplacé par un stub ;
- le refcount du wrapper suit exactement `1 → 2` au premier `0x9AB730`, appelé par `0x989630`, puis `2 → 3` lorsque l’enregistrement conserve sa propre référence ;
- le compteur de l’arbre `manager+0x20` suit `1 → 2`, `2 → 3`, puis `3 → 4` ; chaque nœud se retrouve aussi dans la collection `manager+0x40` ;
- `0x9696BC` affecte le nœud à `owner+0x88` ;
- `0x6B586E` ramène le compteur du nœud de 2 à 1 après la libération temporaire ;
- `0x98967E` écrit `node+0x15=1` ;
- `0x989695` est atteint trois fois avec `AL=1`, puis le `ret 0x0C` revient au caller borné avec le delta de pile attendu ;
- les trois readbacks level-0 restent identiques aux payloads DDS :
  - `terrainHeightScale.dds` : `6d98a9a8aacd4bee2ce1077ea1367bb9c3a7862fc86b1e3316d9a70041d6d199` ;
  - `compositeColorMap.dds` : `98cb9477fe84418dafea41a206db7e927c7341d486ccf310a0476bfbc36ab0a8` ;
  - `fogLightingMap.dds` : `a540fd476743a80ca0bfc69f5905ea389835d9de6b0801d78d80feb16a1bb35a`.

Le probe parcourt 5 934 adresses originales, observe zéro accès mémoire invalide, n’effectue aucun `Draw`/`Present`, détruit la fenêtre cachée et libère toutes les ressources current-host qu’il possède. Les allocations natives synthétiques demeurent présentes : `native_full_teardown=false`.

## Refus et limites

- Gestionnaire absent : `[0x2D79030]==0` est réellement observé avant le constructeur et le harness refuse d’entrer dans `0x989500`. Il n’exécute la suite qu’après le retour réussi de `0x9783D0`.
- Source altérée : une mutation d’un octet produit un SHA différent et est refusée avant upload.
- Ces deux cas sont des gardes du harness, pas des refus natifs Riot.
- Le résultat concerne le runtime D3D9 actuel sous profil privé `escape_refusal`, pas le runtime historique 2014.
- Le gestionnaire et le renderer ne subissent pas leur teardown natif complet.
- Aucune preuve de draw, `Present`, pixel de frame, sampler ou fidélité visuelle n’est revendiquée.

## Reproductibilité

Deux exécutions successives ont réussi. Les octets natifs collectés sont strictement identiques entre les deux runs, SHA-256 `0507686aad151b6a938764c5812f15450663849326e8db51ccb4180269ac58fd`. La projection normalisée des résultats est identique, SHA-256 `540dbbabda0e225bd850c9c795ea6a934fa56856bd226e76b1c767dfbb88b57a`.

Contrôles réellement exécutés :

- `python -m py_compile probe_post_publication_runtime.py` : réussi ;
- deux exécutions complètes du probe : réussies ;
- `python -m py_compile validate_post_publication_runtime.py` : réussi ;
- validation indépendante structurée : réussie ;
- parsing JSON et comparaison normalisée : réussis.

## Livrables

- `probe_post_publication_runtime.py` — `244b77f66c886070e32917b90d042fabd5d9af0689ce6cbc94a6e81ca1ef64c3` ;
- `post_publication_runtime_execution.json` — `a2fbd67a7b9d33ad0012e698dd4574b626d9f5991379a0ceae5a11f2cbefb6fe` ;
- `post_publication_runtime_native_bytes.json` — `0507686aad151b6a938764c5812f15450663849326e8db51ccb4180269ac58fd` ;
- `validate_post_publication_runtime.py` — `1b39d8c234996d72ff4cda2dc09c7856bf22679b653243e04b875ffdf2b8a980` ;
- `post_publication_runtime_validation.json` — `82017bdce51ea9b420e969920b2a7d41fd8839867b0da8235e2de5b526a798c3`.

Aucun fichier de `F:`, produit, Goal, Plan, interface ou base n’a été modifié.
