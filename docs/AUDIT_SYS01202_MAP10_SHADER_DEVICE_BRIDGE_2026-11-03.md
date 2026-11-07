# V1154 — Bridge device D3D9 des objets shader Map10

## Décision bornée

**PASS — le contrat `CreateVertexShader / CreatePixelShader / Release` est fermé pour un bridge D3D9 current-host isolé.**

Ce résultat ne qualifie ni les shaders FOUR_BLEND de Riot, ni le runtime de 2014, ni les producteurs natifs. Il démontre uniquement que le bridge courant sait créer, posséder puis libérer les deux types d’interfaces shader D3D9 sur l’hôte actuel, sans bind ni rendu.

- deux exécutions finales postérieures au dernier changement du probe : `PASS` ;
- projection déterministe commune : `b1ea1ef08ad63f5248cbcfc88e407090889c7a250cbf040abbfd013bfb130930` ;
- ABI statique 4.20/SDK : `PASS`, 24 contrôles ;
- validation indépendante du lot : `PASS`, 45 contrôles.

## Contrat natif et SDK

Le PE32 4.20 épinglé conserve le SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

Les fenêtres natives exactes montrent :

- `0x9BEB6F` : appel device `+0x16C`, identifié par le SDK comme `CreateVertexShader` ;
- `0x9BEC8F` : appel device `+0x1A8`, identifié comme `CreatePixelShader` ;
- `0x9BEBA2` et `0x9BECC2` : stockage de l’interface brute dans `wrapper+0x10` ;
- `0x9BED4B` puis `0x9BED51` : lecture de `wrapper+0x10` et appel `IUnknown::Release` au slot `+0x08/index 2`.

Le header `d3d9.h` 10.0.26100.0, SHA-256 `df78083ee8e75e6d3851422f6aa8abf6213e349f22bf27e7f161e98e8d90df04`, confirme les indices 91/106. Les offsets `0x16C/0x1A8` sont ceux de la vtable x86 du client 4.20 ; sur le processus Python x64 actuel, les mêmes indices correspondent physiquement à `0x2D8/0x350`. Cette différence de taille de pointeur est enregistrée, pas confondue.

La fonction native `0x9BED40` prouve l’ABI Release, mais son orchestration par les records/pools reste un blocker distinct. Elle n’est pas déclarée close par ce lot.

## Fixtures synthétiques traçables

Un HLSL minimal local est compilé avec le `fxc.exe` déjà installé du SDK 10.0.26100.0, SHA-256 `31fa10504b1551337de4d06ec2194143885a76a8b5a81177999e2faa34729183` :

```text
fxc.exe /nologo /T vs_2_0 /E VSMain /Fo synthetic_vs_2_0.cso synthetic_device_bridge.hlsl
fxc.exe /nologo /T ps_2_0 /E PSMain /Fo synthetic_ps_2_0.cso synthetic_device_bridge.hlsl
```

Identités :

- source HLSL : 147 octets, SHA-256 `c83c3431041724afa8d1288464442216393c5bb3f2589dec6229982cc3887ecf` ;
- VS synthétique : 116 octets, SHA-256 `1022732a2bf3fd99c9d476abfa16e57906bf0ae179f8d59cca317baee4703791` ;
- PS synthétique : 128 octets, SHA-256 `75be600a05c4790649621ffe6102bd81af8dc2d6847fcd0353fd760b95344769`.

Ces fichiers ne sont pas des shaders Riot et ne sont pas compilés depuis les HLSL FOUR_BLEND archivés. Ils testent seulement le contrat device sans dépendre du blocker D3DX du client.

## Exécution current-host

Le probe crée une fenêtre système cachée et un device D3D9 hardware sur :

- adaptateur : `NVIDIA GeForce RTX 3060` ;
- driver déclaré : `nvldumdx.dll` ;
- runtime : `C:\Windows\System32\d3d9.dll`, 1 799 712 octets, SHA-256 `9c2343d50ab0e219d6526be5c419b2c5dc62e88c30444c936927001e3bdc89e6`.

Dans chacun des deux runs finaux :

1. `CreateVertexShader` reçoit les 116 octets VS et retourne `HRESULT 0` avec une interface non nulle ;
2. `CreatePixelShader` reçoit les 128 octets PS et retourne `HRESULT 0` avec une interface non nulle ;
3. les deux objets restent simultanément vivants et leurs adresses sont distinctes ;
4. chaque interface suit `AddRef → 2`, `Release → 1`, `Release final → 0` ;
5. le device et `IDirect3D9` sont relâchés à zéro et la fenêtre cachée est détruite.

Les adresses ASLR ne participent pas à la projection déterministe.

## Refus contrôlés

Un flux de tokens terminé mais portant une version invalide (`0x12345678`, `END`) est soumis séparément aux deux méthodes :

| Stage | Résultat attendu | Résultat observé |
|---|---|---|
| vertex | échec HRESULT, sortie nulle | `0x8876086C`, sortie nulle |
| pixel | échec HRESULT, sortie nulle | `0x8876086C`, sortie nulle |

Le SHA-256 de cette entrée invalide est `52ca5063502c085383f56b94dce921ebc99a159546f3533b655d48c466f960c0`. Ce refus est celui du runtime D3D9 actuel, pas une règle Riot historique.

## Borne stricte

Le probe n’entre jamais dans `0x98D960` ou `0x98C070`. Il n’appelle ni `D3DXCompileShader`, ni `SetVertexShader`, ni `SetPixelShader`, ni pool, paire, bind, draw, `Present` ou readback de frame. Le validateur parcourt l’AST et confirme qu’aucun appel `com_method` ne cible les constantes de slots Set.

Les compteurs zéro sont structurels : ils décrivent les capacités absentes du probe et ne sont pas présentés comme une trace du runtime Riot.

## Preuves finales

- producteur : `probe_shader_device_bridge.py`, SHA-256 `eeeea95f666a210a3f7b165fab4610d366857012a72b0cac2d30d3fd756edf51` ;
- run 1 : SHA-256 `3105d638984d0a793ea560b3bceefa8c278307bedf98d2e5812afa3e892011ce` ;
- run 2 : SHA-256 `5db494ed4a8793ce781733009791e21aff2f3396be229325a9e5c4ecd7966de2` ;
- ABI statique : SHA-256 `b8acfed720e7f269930fa76710afc751cf36cddcb6a5a6404964b3e93ce70d12` ;
- validation : SHA-256 `859a72907f1dbb5a1556c56a917ec282d23394f6fc7e74c505e0dc558d446360`.

Les fichiers `debug_run*.json` proviennent de la mise au point des fixtures et sont explicitement exclus des preuves finales. Seuls `shader_device_run1.json` et `shader_device_run2.json` qualifient le résultat.

## Limites et reprise

Ce lot ferme seulement le blocker device du préflight V1152. Il ne ferme pas :

1. le bridge D3DX buffers / constant table ;
2. l’allocation et la libération collision-free des pools shader ;
3. le cleanup possédé des records/objets backend ;
4. la compilation et publication des deux objets FOUR_BLEND réels ;
5. la paire, le bind, le draw, `Present`, les pixels ou la fidélité visuelle.

L’entrée des producteurs reste interdite tant que les contrats restants ne sont pas fermés ensemble. Aucune complétude shader, terrain, Map10 ou jeu n’est déclarée.

Écritures : uniquement sous `E:\mapslol3v3\audit_map10_v1154_shader_device_bridge_20261103`. Aucun fichier produit, asset, registre, Goal, Plan, interface, application, base ou fichier sous `F:` / `D:` n’a été modifié par ce lot.
