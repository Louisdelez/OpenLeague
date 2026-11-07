# V1152 — continuité géométrique Map10 jusqu’aux binds pré-draw

## Décision bornée

La continuité source-backed réellement cohérente est fermée pour le contrat historique `selector 2 / stride 44` du mesh natif `room.nvr` 1093 : les descripteurs exacts, le payload VB1 et le payload IB1 sont remis à trois factories d’enregistrement explicitement nommées, les wrappers retournés sont conservés aux indices vectoriels 1, puis les mêmes valeurs atteignent les trois binds du code original exécuté depuis `0x95AFC0`.

L’exécution s’arrête strictement à l’instruction originale `0x95B112`, avant l’appel du slot wrapper `backend+0x20`. Aucun draw, Present, readback de frame/backbuffer ou pixel rendu n’est produit.

La demande initiale `selector 0` n’est pas déclarée satisfaite pour ce mesh. VB1 contient exactement `60 324 = 1 371 × 44` octets. Le selector 0 impose 36 octets ; il est donc refusé par le preflight du harness avant toute entrée native. Ce refus démontre l’incompatibilité de cette paire, pas un comportement de refus natif Riot.

## Entrées exactes réutilisées

- V1150 runtime, sans rejouer son analyse statique : `probe_map10_draw_boundary_runtime.py`, SHA-256 `6aea9530f8b88e36e5e288a076b1ea0abbeF01bca33a14173a498f4bc253fb5c` ;
- validation V1150 existante : réussie ;
- validation V1151 géométrie existante : réussie ;
- `room.nvr` original : SHA-256 `89e873ec32356312b53628c9773c803b0e6e864a206ac2aafc6a584c8ae27082` ; magic `0x0052564E`, version `0x10009`, comptes `87/107/107/2351/1365`.

Aucun fichier F:, D:, produit, Goal, Plan, interface, base ou registre n’a été modifié. Le fichier D: a uniquement été relu. Tous les livrables sont sous `E:\mapslol3v3\audit_map10_v1152_geometry_continuity_20261103`.

## Mesh et paire VB/IB retenus

Le mesh 1093 est un triangle minimal non dégénéré et déjà borné par les preuves V1151 :

| Champ natif | Valeur |
|---|---:|
| offset du record | `59 952 568` |
| SHA-256 du record 100 octets | `3b084a5387c0381d2c8cf063cc8ae0ffb060dbc8dbd15642b99c37dba6f1cfea` |
| material index | `1` |
| VB index | `1` |
| start vertex / vertex count | `213 / 3` |
| IB index | `1` |
| start index / index count | `252 / 3` |
| primitive count dérivé | `3 / 3 = 1` |

VB1 reste à l’index vectoriel 1. Son payload commence à l’offset fichier `430 312`, contient `60 324` octets et a le SHA-256 `92a9cdf6b29773f49c1eca1a6e462fe61df920054998a61377407fa4b4ee8ac6`.

La tranche de trois sommets commence au sommet 213, contient `132 = 3 × 44` octets et a le SHA-256 `526eb2982e6d9c6452cc4cd2d9ef21611cc77e4422f89961fc310ac3c9ef18a9`.

IB1 reste à l’index vectoriel 1. Son payload commence à l’offset fichier `48 707 442`, contient `3 456` octets, porte le format `0x65` (indices 16 bits) et a le SHA-256 `828c3d271f98cecbc4cc32d6245b111731356607daf9bc8c469a6afe7e73e607`.

Les trois indices à partir de 252 valent exactement `[213, 214, 215]`. Leur tranche de six octets a le SHA-256 `5c738af4f7a32fabfff238adf0cfa3381e7f76f87a337e4399f3683d601a2fb3`. Ils désignent donc précisément les trois sommets qualifiés et restent dans la plage VB1 de 1 371 sommets.

## Déclaration selector 2

Le wrapper est publié à `context+0x0C`, soit `context+0x04 + selector×4` pour selector 2. Le stride lu dans la table native vaut 44.

Descripteur abstrait exact, 48 octets :

```text
000000000200000000000c0002000300000018000100040000002000010004010000280004000600ff00000008000000
```

SHA-256 : `a0dae45b432dee6fdc2f4656f13d3f72b692ee4cfbcdc1e9d846389efada3784`.

Il décrit POSITION float3 à 0, NORMAL float3 à 12, TEXCOORD0 float2 à 24, TEXCOORD1 float2 à 32, COLOR D3DCOLOR à 40, puis le terminateur abstrait.

Descripteur D3D9 traduit exact, 48 octets :

```text
000000000200000000000c0002000300000018000100050000002000010005010000280004000a00ff00000011000000
```

SHA-256 : `375b5c8b08666d26c3021e6aad676f5a674e67590bfa363faef2ebc72e543f38`.

## Factories et wrappers explicitement qualifiés

Le probe crée trois wrappers d’enregistrement source-backed dans le même run :

| Factory d’adaptation | Entrée exacte | Wrapper retourné |
|---|---|---|
| `recording_selector2_declaration_factory_adapter` | descripteurs abstrait et D3D9 ci-dessus | `0x41930000` |
| `recording_nvr_vertex_buffer_factory_adapter` | payload complet VB1 | `0x41930100` |
| `recording_nvr_index_buffer_factory_adapter` | payload complet IB1, `0x65`, 16 bits | `0x41930200` |

Les octets sources sont copiés en mémoire guest puis relus et re-hashés avant l’entrée native. Les trois factories portent explicitement `historical_factory_executed=false` et `historical_COM_wrapper=false`.

Le lot ne prétend donc ni avoir exécuté les producteurs originaux `0x9596D0` / `0x958420`, ni avoir créé les wrappers COM historiques. Il prouve la continuité des identités sources au travers de factories d’enregistrement, puis du consommateur/binder original.

## Exécution originale observée

Trace exacte :

```text
0x95AFC0 → 0x95B035 → 0x95AD40 → 0x95B046 → 0x95A730
→ 0x95B063 → 0x95B0A4 → 0x95B0D2 → 0x95B112
```

Les binds adaptés reçoivent, dans cet ordre :

1. déclaration : wrapper `0x41930000` ;
2. stream source : `(stream=0, wrapper=0x41930100, offset=0, stride=44)` ;
3. index buffer : wrapper `0x41930200`.

Ce sont exactement les wrappers retournés par les factories du même run. Les vectors contiennent deux slots et les handles restent dans le slot 1 ; rien n’est replié vers le slot 0.

À `0x95B112`, les arguments bruts observés avant l’appel wrapper `backend+0x20` sont `[0, 0, 213, 3, 252, 1]`. Les instructions natives réutilisées montrent : deux zéros, puis `batch+0x0C`, `+0x10`, `+0x14`, `+0x18`. Ce tableau reste volontairement décrit comme arguments internes du wrapper ; le slot n’est pas exécuté et le lot ne le convertit pas abusivement en appel D3D9 effectif.

Résultat : `actual_DrawIndexedPrimitive_called=false`, aucun HRESULT de draw, zéro accès mémoire invalide.

## Cas nominal et refus

Cas nominal observé : mesh 1093, material/VB/IB index 1, selector 2, stride 44, trois factories source-backed, trois wrappers identiques aux binds, trace native complète et arrêt strict pré-draw.

Refus observé : candidate selector 0 / stride 36 contre VB1 / stride requis 44. Le harness refuse avant `0x95AFC0`, sans trace native et sans continuation. Ce refus n’est pas attribué au binaire original.

## Déterminisme et validation indépendante

Deux runs complets ont réussi. Les reçus native-bytes sont byte-identiques, SHA-256 `350c9a5e86bfeac4df053fc57375bdeafefafce1964155f62c1479afc1cb009b`.

Les JSON d’exécution bruts diffèrent seulement par l’horodatage et les valeurs du thread ID hôte, sept différences toutes classifiées. Après normalisation de ces seuls champs :

- exécutions complètes identiques, SHA-256 canonique `ce52ca2aea3ab3e9ae62f796e28afd406c31aa8411b2836576b9cd14fc10fea8` ;
- projection géométrique identique, SHA-256 canonique `2410fa49350367ae24f8602ec5091dea92583ab99393cc6fcad3826e0f4629d9` ;
- validateur : 11/11 contrôles globaux ; 21/21 contrôles par run.

Commandes réellement exécutées :

```text
python -m py_compile probe_map10_v1152_geometry_continuity.py validate_map10_v1152_geometry_continuity.py
python probe_map10_v1152_geometry_continuity.py
python probe_map10_v1152_geometry_continuity.py
python validate_map10_v1152_geometry_continuity.py
```

Un premier run de mise au point avait échoué avant la composition à cause d’une constante magic NVR mal transcrite. La valeur relue `0x0052564E` a été corrigée ; aucun reçu de cet essai n’est conservé comme preuve finale. Les deux reçus finaux ont été régénérés après la dernière modification du probe.

## Livrables finaux

| Fichier | Octets | SHA-256 |
|---|---:|---|
| `probe_map10_v1152_geometry_continuity.py` | 21 477 | `165dc538391421a925c72fd32eefcf13a92872ca254bc95ea3a8b93f12e90b6a` |
| `validate_map10_v1152_geometry_continuity.py` | 24 647 | `ff90f9588cf0d90c2938d3e4a86490de000d85f76fd924043dbada9cf3a8dce4` |
| `map10_v1152_geometry_continuity_execution_run1.json` | 219 935 | `2a18e86ad085190bfe86a931c2ce7c38009b5360e6010486ada77a293280ac5c` |
| `map10_v1152_geometry_continuity_execution_run2.json` | 219 935 | `47251d3c6127fe9067a70805bb4725c1bacbf6905d8939210fa30d0545662e27` |
| `map10_v1152_geometry_continuity_native_bytes_run1.json` | 165 453 | `350c9a5e86bfeac4df053fc57375bdeafefafce1964155f62c1479afc1cb009b` |
| `map10_v1152_geometry_continuity_native_bytes_run2.json` | 165 453 | `350c9a5e86bfeac4df053fc57375bdeafefafce1964155f62c1479afc1cb009b` |
| `map10_v1152_geometry_continuity_normalized_projection.json` | 10 870 | `3d40438f2271de032498b305e91513fdcb110ffcc9742b332f05750bb8842648` |
| `map10_v1152_geometry_continuity_validation.json` | 9 428 | `4adb459c6695fe1b4c9c43b66a8a1583ac6d3c02bb4bbfda27c1a6320a253afb` |

## Limites et condition d’arrêt

- selector 2 / stride 44 est la continuité réellement fermée pour mesh1093/VB1/IB1 ; selector 0 reste explicitement non clos pour cette paire ;
- les factories et wrappers sont des adaptateurs d’enregistrement source-backed, pas les factories originales ni des objets COM historiques ;
- l’objet matériau et les stages détail hérités de V1150 restent des fixtures explicites ; ce lot ne les requalifie pas ;
- les trois readbacks hérités de V1148 concernent le contenu de textures, pas une frame ni des pixels géométriques ;
- `backend+0x20`, DrawIndexedPrimitive, shader-pair effectif, Present, frame, pixel et fidélité visuelle restent hors périmètre ;
- aucune déclaration de produit, map, jeu, Goal ou tâche globale terminée n’est faite.

Condition d’arrêt satisfaite : les trois mêmes wrappers source-backed atteignent les binds originaux et l’émulation s’arrête à `0x95B112` avant l’appel `backend+0x20`. Aucun prolongement vers draw/Present/pixel n’est autorisé dans ce lot.
