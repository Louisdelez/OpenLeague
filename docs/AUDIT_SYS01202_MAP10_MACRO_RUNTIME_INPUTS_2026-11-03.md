# SYS-01.2-02 — V1162 — entrées de démarrage des macros terrain Map10

Date : 2026-11-03  
Lot : `AUD-SYS-01.2-02-MAP10-MACRO-RUNTIME-INPUTS-01`  
Répertoire de preuve : `E:\mapslol3v3\audit_map10_v1162_macro_runtime_inputs_20261103`

## 1. Verdict borné

Les neuf globals requis par V1161 ont tous une classification, un producteur ou une absence de store direct documentée, une limite et une condition de reprise précise. **Le périmètre d'audit V1162 est terminé.**

Ce résultat ne prouve pas une frame historique exécutée :

- une valeur est statique et épinglable dans le PE : `0x2D78FAC = 0` ;
- une valeur est déterminable depuis la configuration Map10 épinglée : `0x14BE79F = true` pour `Fog/Enable=1` ;
- sept valeurs restent dépendantes d'une transaction de configuration utilisateur, d'un provider/overlay ou d'un objet runtime non épinglé.

Comme au moins une entrée obligatoire reste inconnue, **aucun vecteur historique complet de macros n'a été construit**. Le verdict exact est `NOT_BUILT_REQUIRED_INPUTS_UNKNOWN`. La fonctionnalité runtime, la carte, le renderer et le jeu ne sont pas déclarés terminés.

## 2. Sources réutilisées et identités

Le binaire original reste :

- `League of Legends.exe`, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ;
- Map10 `terrain.inibin`, SHA-256 `1a82e51b6be12e6091fb50859b93e8ac13de86f4e38e162570388d88ede9fba1` ;
- `DATA/CFG/defaults/Game.cfg`, SHA-256 `02c41cb9a5068f8bc993435557fd7b159bddbcda1f022605d284d9ea51d72b0e`.

Les contrats existants ont été réutilisés avant toute nouvelle lecture :

- `environment_shader_macros_contract.json` pour le builder `0x9593C0` ;
- `environment_render_config_contract.json` pour les valeurs Map10 déjà décodées ;
- `environment_quality_contract.json` pour le setter `0x8376DD` et l'initiale 3 ;
- `environment_shader_selection_contract.json` pour le consommateur ;
- `native_fog_consumer_contract.json`, `native_fog_macros_contract.json` et `native_environment_fog_profile_contract.json` pour l'activation et les modes de fog ;
- les audits unitaires ShadowQuality, EnvironmentQuality et ColorPalette ;
- V1161, dont le rapport réutilisé a le SHA-256 `27f7fcdadbb9a5c1f9b64b0e62def6c2d6a095f341a6308f7be0ab569494ef9a`.

Le fichier de preuve épingle les tailles et SHA-256 de chaque source. Aucune source F n'a été modifiée.

## 3. Classification des neuf globals

| Global | Rôle | Initiale PE | Producteur direct borné | Classification au démarrage Map10 | Valeur épinglée |
|---|---|---:|---|---|---:|
| `0x12258F4` | ShadowQuality | 1 | getter `0x835080` puis store `0x837434` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue |
| `0x12258D8` | EnvironmentQuality | 3 | store constructeur 3 à `0x960A55`, setter `0x83771F` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue |
| `0x2D78FAC` | override Animate FoW | 0 | aucun store direct ; trois littéraux, trois lectures | `STATIC_CODE_OWNED` | **0** |
| `0x123F5F8` | objet feature Animate FoW | 0 | store zéro `0x531D8E`, publication non directe | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue |
| `0x123F7E0` | objet feature nuages | 0 | store zéro `0x531DFE`, publication non directe | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue |
| `0x2D78FB0` | options globales terrain | 0 | store `0x960A67`, OR `0x10` à `0x95912C` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue |
| `0x2D79058` | palette | 0 | stores `0x97CCF8`, `0x97CDB6`, repli `0x97CDD1` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue |
| `0x14BE79F` | activation fog | 0 | init `0x986FE5`, setter `0x987370` | `MAP10_CONFIG_DETERMINABLE` | **true** |
| `0x1225904` | mode/qualité fog | 2 | setter `0x987600`, store `0x987616` | `RUNTIME_OR_FRAME_NOT_PINNED` | inconnue |

### Précisions de portée

`0x2D78FAC` se trouve dans la partie zéro de `.data`. Les trois occurrences littérales du texte sont exactement les comparaisons à `0x6B389A`, `0x6B3B18` et `0x95944C` ; aucune écriture ni adresse prise distincte n'a été trouvée. La valeur 0 est donc épinglée dans le périmètre statique direct. Une écriture externe ou une écriture indirecte calculée sans littéral absolu n'est pas prétendue impossible.

Le contrat fog existant exécute l'initialiseur original `0x986FD0` et le consommateur `0x9870E9` sur le vrai `terrain.inibin` Map10 ; il observe `Fog/Enable=1` et `fog_enabled=true`. Le cache est adapté et les overlays/listeners/la frame complète sont hors de ce contrat. La conclusion est donc « déterminable depuis la configuration Map10 », pas « capturé dans un processus historique en direct ».

Pour `0x1225904`, le suffixe qualité établi donne : EnvironmentQuality 0 ou 1 → fog mode 1 ; 2 à 4 → fog mode 2. Le défaut original EnvironmentQuality=3 implique conditionnellement 2, mais le provider utilisateur effectif n'est pas épinglé.

## 4. Valeurs conditionnelles connues sans les promouvoir en valeurs actives

Le `Game.cfg` original par défaut contient :

- `EnvironmentQuality=3` ;
- `ShadowsEnabled=1` ;
- `ShadowQuality=1` ;
- `ColorPalette=0` ;
- `ColorPaletteSpectator=1`.

Ces valeurs sont des baselines de source, pas une preuve de sélection effective : le chemin utilisateur, les overlays, l'ordre d'initialisation et le contexte spectateur peuvent les remplacer. De même, l'initiale PE de fog mode 2 et le store constructeur EnvironmentQuality 3 ne certifient pas leur état lorsque `0x9593C0` et `0x987830` construisent les macros.

## 5. Ruptures et conditions de reprise

1. **ShadowQuality `0x12258F4`** — établir le provider sélectionné de `Performance/ShadowQuality`, `ShadowsEnabled` et l'ordre de dispatch avant `0x9593C0`.
2. **EnvironmentQuality `0x12258D8`** — établir la valeur/provider effective et la transaction du setter `0x8376DD` avant le builder.
3. **Override Animate FoW `0x2D78FAC`** — ne rouvrir que sur un producteur indirect calculé concret ou une observation runtime autorisée contredisant zéro.
4. **Objet Animate FoW `0x123F5F8`** — suivre la publication/registration indirecte et le retour virtuel `+0x18` consommé à `0x959455`.
5. **Objet nuages `0x123F7E0`** — suivre la publication/registration et le retour virtuel `+0x18` à `0x95949B`.
6. **Options globales `0x2D78FB0`** — identifier le provider `0x8B1C20` de `SimpleEnvironment/DefaultFlags`, celui de `Environment/Lighting` à `0x8B1A80`, leur ordre, puis la valeur avant `0x95956F`.
7. **Palette `0x2D79058`** — épingler le contexte `0x2D7905C`, le provider/overlay et la valeur rendue à `0x97CD90` avant `0x959DA0`.
8. **Activation fog `0x14BE79F`** — seulement pour une certification runtime : observer le cache/overlay effectivement sélectionné et le setter `0x987370` lors d'un démarrage autorisé.
9. **Fog mode `0x1225904`** — épingler EnvironmentQuality effectif et sa propagation vers `0x987600` avant `0x987830`.

La rupture commune est donc précise : transaction/provider/overlays de configuration utilisateur et publication/état des deux objets feature. Une nouvelle recherche sans l'une de ces entrées ne dépasserait pas la frontière actuelle.

Le remapping death-screen est explicitement hors de V1162 et n'a pas été audité.

## 6. Vérifications réellement exécutées

Deux productions indépendantes ont été exécutées :

- `macro_runtime_inputs_run1.json` ;
- `macro_runtime_inputs_run2.json`.

Leur empreinte canonique de preuve stable est identique : `2edd222c5873a4b18cb0ff3c67c2ec77e4c788101a059855a7067498d2bc60d4`.

Le validateur séparé obtient **31/31 contrôles réussis** : identité PE/Map10, deux runs, égalité de la preuve stable, neuf classifications, inventaire exact des stores directs, catégories 1/1/7, conditions de reprise, refus du vecteur incomplet et limites d'exécution.

Exécuté : lecture statique du PE épinglé, désassemblage de douze fenêtres productrices bornées, lecture des contrats et des deux fichiers de configuration épinglés, génération des deux reçus et validation.

Non exécuté : jeu/client historique, frame, D3D/GPU, réseau, REA, capture, changement de configuration, remapping death-screen, code produit, goal, Plan, UI, base ou migration. Écritures sur F : zéro.

## 7. Livrables

- `probe_macro_runtime_inputs.py` — producteur déterministe ;
- `macro_runtime_inputs_run1.json` et `macro_runtime_inputs_run2.json` — reçus ;
- `validate_macro_runtime_inputs.py` — validateur indépendant des classifications déclarées ;
- `macro_runtime_inputs_validation.json` — résultat 31/31 ;
- `artifact_manifest.json` — manifeste d'identité ;
- ce rapport.

V1162 est clos comme audit de classification. V1161 reste ouvert sur le vecteur historique exact et l'admission des candidats, conformément à la règle d'arrêt demandée.
