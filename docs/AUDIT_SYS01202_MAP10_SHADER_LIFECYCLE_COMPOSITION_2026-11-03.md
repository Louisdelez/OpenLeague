# V1155 — Composition du cycle de vie shader current-host

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-SHADER-LIFECYCLE-COMPOSITION-01`  
Verdict : **PASS pour l’adapter/harness composé ; producteurs Riot, fichiers FOUR_BLEND et rendu toujours hors périmètre**.

## Résultat borné

Les quatre contrats V1154 sont exercés dans un même cycle, sur les fixtures HLSL synthétiques déjà épinglées :

1. compilation physique par le vrai `D3DXCompileShader` current-host ;
2. allocation par la primitive originale 4.20 `0x8E28C0` ;
3. création réelle `IDirect3DDevice9::CreateVertexShader/CreatePixelShader` ;
4. publication dans un record stride 8 et un wrapper exact-layout (`CTAB +0x00`, shader `+0x10`) ;
5. cleanup original `0x9AED50/0x9AEDC0 → 0x9BED40 → 0x8E2980`, dont les appels `Release` rejoignent les vrais objets hôte possédés.

Deux runs finaux postérieurs au producteur passent avec la même projection `99723283e226e83fe9369895a8602762598cf7b93422852bcda655aec1da4e8e`. Le validateur indépendant passe **98/98**.

Ce lot ne compile pas les fichiers Riot FOUR_BLEND complets et n’entre jamais dans `0x98D960` ou `0x98C070`.

## Entrées réutilisées et épinglées

| Contrat V1154 | Producteur réutilisé | SHA-256 |
|---|---|---|
| D3DX buffers / CTAB | `audit_shader_d3dx_bridge.py` | `40e2c2e863c1f9c832bb5d5d51eebad146fb5df1aad0ee97cd0852ce6db903ae` |
| device Create/Release | `probe_shader_device_bridge.py` | `eeeea95f666a210a3f7b165fab4610d366857012a72b0cac2d30d3fd756edf51` |
| pools | `audit_shader_pool_adapter.py` | `90a7232b0c945cdcd392387a070e386aa96604260ab860a35bb81092b500c14c` |
| cleanup possédé | `audit_shader_owned_cleanup.py` | `0e2096213acd06c89488f5c65ba2cf7c9a6777aa389deb612f04df6e161d8f78` |

Les objets D3DX et D3D9 appartiennent au runtime Windows actuel et à la RTX 3060 actuelle. Les managers, records et wrappers invités sont des fixtures exact-layout synthétiques. Aucun état vivant Riot 2014 n’est revendiqué.

## Deux cycles nominaux

Chaque stage part d’un manager vierge distinct ; l’allocateur original retourne donc l’index 0 dans le pool VS et l’index 0 dans le pool PS. Ces tokens restent distincts par leur stage et leurs bases de records.

| Stage | Bytecode D3DX | CTAB | Création device | Allocation / cleanup |
|---|---|---|---|---|
| vertex | 272 octets, `54e82f72…c2821` | 144 octets, `5df95847…a2b4` | `HRESULT 0`, objet non nul | alloc original 102 instructions ; cleanup original 94 instructions |
| pixel | 184 octets, `a94c8cfb…2c36a` | 128 octets, `7815182a…482d` | `HRESULT 0`, objet non nul | alloc original 102 instructions ; cleanup original 94 instructions |

Dans les deux cas :

- le buffer de bytecode est libéré à zéro après `Create*Shader` ;
- le CTAB et le shader restent possédés par le wrapper publié ;
- le record a `refcount=1` avant cleanup ;
- les deux `Release` rappelés par le cleanup original retournent zéro ;
- le wrapper est libéré une fois ;
- `record[0]`, `record[1]` et le bit de pool reviennent à zéro ;
- le même index est immédiatement réalloué puis libéré, preuve de réutilisabilité ;
- aucune mémoire invitée invalide n’est observée.

## Incompatibilité de harness détectée et résolue localement

La composition a révélé une différence importante entre les deux preuves V1154 séparées :

- l’allocateur original met à 1 le **bit feuille** du slot ;
- les bits des niveaux supérieurs ne signifient pas « ce slot est possédé » : ils résument qu’un mot/enfant complet est saturé ;
- le harness cleanup V1154, construit isolément, avait mis manuellement les trois niveaux à 1 et son preflight exigeait les trois.

Le gate composé exige donc le bit feuille possédé et conserve les bits supérieurs à zéro pour une allocation unique. Le code original de free efface ensuite correctement le slot. Il s’agit d’une correction de compatibilité du harness, pas d’une modification du produit Riot ou d’OpenLeague.

## Rollbacks atomiques

Trois cas séparés sont passés :

1. **échec compilation** : source invalide, `HRESULT 0x80004005`, diagnostic `error X3000`, seul le proxy d’erreur existe puis revient à zéro ; aucun pool ni device appelé ;
2. **échec device** : compilation valide et slot pixel alloué, bytecode de version invalide refusé par le runtime actuel avec `0x8876086C` et sortie nulle ; code, CTAB et slot sont libérés, aucun record publié ;
3. **saturation** : 4 096 indices vertex uniques `0..4095`, puis sentinelle exacte `0x1000` ; le device n’est pas appelé, code/CTAB sont libérés et les 4 096 slots reviennent à zéro.

Après ces cas, aucun proxy D3DX, shader hôte, bitmap ou record ne reste possédé.

## Nettoyage hôte et borne stricte

État final des deux runs :

- proxies D3DX vivants : 0 ;
- shaders current-host vivants avant fermeture du device : 0 ;
- release forcée de secours : aucune ;
- `IDirect3DDevice9::Release → 0` ;
- `IDirect3D9::Release → 0` ;
- fenêtre cachée détruite.

Le harness ne dispose d’aucune capacité pour `SetVertexShader`, `SetPixelShader`, paire, bind, draw, `Present` ou readback de frame. Les compteurs zéro sont structurels et ne sont pas présentés comme une trace Riot.

## Preuves finales

- producteur : `audit_shader_lifecycle.py`, SHA-256 `cd97bb0cdc6eadf2a9ac93a2b2f3726cafb52cc0d8b90fdf9c775ecadb9b4ab5` ;
- run 1 : `a07cdd298aaaca0027e3ddda1a9e45d55c68aa7afbce125dc7cd6dbe6d6e59cf` ;
- run 2 : `b45251b7ed62a67aafaad8fbf51ed3052da77c663b82fc48603258ac1d21e094` ;
- validateur : `2528999f15405dc7a312f802da795f0b92068e8114ae5198efdc2ef24d196e77` ;
- reçu de validation : `7cc54b474d8cb23939a6f9a2848a6274c6af55bacd4ee57ec84bde3e457392b7`.

Commandes finales :

```powershell
python .\audit_shader_lifecycle.py --run-id final1 --output .\shader_lifecycle_run1.json
python .\audit_shader_lifecycle.py --run-id final2 --output .\shader_lifecycle_run2.json
python .\validate_shader_lifecycle.py --output .\shader_lifecycle_validation.json
python .\validate_shader_lifecycle.py
```

Le validateur est non mutant sans `--output`.

## Limites et reprise

- sources : fixtures V1154 sans include, pas `Environment/LIT_VS.vs_2_0` et `LIT_PS.ps_2_0` complets ;
- runtime : D3DX/D3D9 actuels, pas runtime 2014 ;
- état invité : managers/records/wrappers exact-layout synthétiques, pas état vivant Riot ;
- producteurs originaux, publication FOUR_BLEND, paire, bind, draw, `Present`, pixels, fidélité visuelle et intégration Rust : non exécutés.

La reprise doit d’abord qualifier la chaîne des neuf sources/includes vers les buffers prétraités complets. Seulement ensuite, une unité distincte pourra tenter les producteurs originaux avec les gates et rollbacks désormais composés.

Écritures : uniquement sous `E:\mapslol3v3\audit_map10_v1155_shader_lifecycle_20261103`. Aucun fichier sous `F:`, aucun produit, asset, registre, Goal, Plan, interface, application ou base n’a été modifié.
