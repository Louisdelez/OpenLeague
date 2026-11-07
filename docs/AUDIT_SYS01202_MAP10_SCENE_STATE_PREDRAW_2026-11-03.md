# V1160 — Map10 scene / targets / viewport, current-host pre-draw

## Verdict borné

**PASS — composant pré-draw current-host uniquement.** Deux exécutions indépendantes ont établi, sur un même `IDirect3DDevice9` jetable, un render target et un depth-stencil compatibles, un viewport et un scissor dans les limites, une scène acquise une seule fois par le harnais puis rendue par `EndScene`, et un rollback exact vers le snapshot initial.

Ce verdict ne qualifie ni l'exécution Riot 2014, ni un draw, ni une image, ni la fidélité visuelle de Map10. Aucun shader n'a été lié. Aucun `Draw*`, `Present`, `GetRenderTargetData` ou `GetFrontBufferData` n'a été exposé par l'adapter ou appelé.

## Périmètre et provenance

- Répertoire d'écriture unique : `E:\mapslol3v3\audit_map10_v1160_scene_state_20261103`.
- Exécutable 4.20 épinglé, seulement comme identité/statique : `League of Legends.exe`, 15 973 880 octets, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- V1159 draw preflight réutilisé : `map10_v1159_draw_preflight.json`, SHA-256 `61c743abbbb25b598c52d4eed93e0b08aece9324b4f5dc68dcd04715f0bac69a` ; validation V1159, SHA-256 `9e5c6fcde2309803093e153c4b557dd599532a6d6d2f6bada2e748f87341bfbb`.
- Harnais current-host réutilisé : `audit_shader_lifecycle.py`, SHA-256 `cd97bb0cdc6eadf2a9ac93a2b2f3726cafb52cc0d8b90fdf9c775ecadb9b4ab5`, et son bridge, SHA-256 `eeeea95f666a210a3f7b165fab4610d366857012a72b0cac2d30d3fd756edf51`.
- Layout COM vérifié dans le SDK épinglé `d3d9.h`, SHA-256 `df78083ee8e75e6d3851422f6aa8abf6213e349f22bf27e7f161e98e8d90df04`. Les indices des 13 méthodes autorisées ont été recalculés depuis l'ordre `IDirect3DDevice9`, notamment scissor 75/76.

Les chemins originaux V1159 restent qualifiés **statiquement seulement** :

| Rôle | Route originale épinglée |
|---|---|
| BeginScene | backend `+0x28 -> 0x9C24F0 -> 0x9C55C0 -> slot 41/+0xA4` |
| EndScene | backend `+0x2C -> 0x9C2500 -> 0x9C56D0 -> slot 42/+0xA8` |
| SetRenderTarget | backend `+0xC8 -> 0x9C3620 -> 0x9C6FB0 -> slot 37/+0x94` |
| SetDepthStencilSurface | backend `+0xD0 -> 0x9C36B0 -> 0x9C71B0 -> slot 39/+0x9C` |
| SetViewport | backend `+0xDC -> 0x9C3820 -> 0x9C74C0 -> slot 47/+0xBC` |

Le code original ci-dessus n'est pas exécuté dans V1160. L'exécution native passe par l'adapter exact-layout current-host.

## Environnement réellement exécuté

- GPU/adapter : **NVIDIA GeForce RTX 3060**, pilote utilisateur `nvldumdx.dll`.
- Runtime : `C:\Windows\System32\d3d9.dll`, 1 799 712 octets, SHA-256 `9c2343d50ab0e219d6526be5c419b2c5dc62e88c30444c936927001e3bdc89e6`.
- Qualification : runtime Windows courant ; **pas** le runtime historique Riot/Windows de 2014.
- Fenêtre cachée 64×64 et device jetable ; aucun produit, Goal, Plan, UI, base ou registre n'a été modifié.

## Snapshot initial observé

| État | Observé |
|---|---|
| `TestCooperativeLevel` | `0x00000000` |
| RT0 | format 22, usage 1, pool 0, MSAA 0/0, 64×64 |
| Depth initial | absent, `GetDepthStencilSurface = 0x88760866 (D3DERR_NOTFOUND)` |
| Viewport | `{0,0,64,64,0.0,1.0}` |
| Scissor | `{0,0,64,64}` |
| Scène détenue par le harnais | non |

Les getters RT/depth ne lisent aucun pixel : ils prennent seulement une référence COM sur l'objet d'état courant.

## Cas nominal exécuté

1. Création d'un RT jetable 32×32, format 22, MSAA 0/0 : `S_OK`.
2. Création d'un depth-stencil jetable 32×32, format 75 (`D24S8`), MSAA 0/0 : `S_OK` au premier essai.
3. `GetDevice` sur RT initial, RT jetable et depth jetable : même pointeur de device, références libérées.
4. Compatibilité dimensions/MSAA RT-depth : exacte.
5. `SetRenderTarget`, `SetDepthStencilSurface`, `SetViewport`, `SetScissorRect` : quatre `S_OK`.
6. Getters de vérification : mêmes objets et valeurs exactes.
7. `TestCooperativeLevel` avant scène : `S_OK`.
8. Premier `BeginScene` : `S_OK` ; ownership du harnais acquis.
9. Second `BeginScene` : `0x8876086c (D3DERR_INVALIDCALL)` ; le nested Begin est bien refusé.
10. Un seul `EndScene` sur l'ownership acquis : `S_OK` ; ownership rendu.
11. `TestCooperativeLevel` après scène : `S_OK`.

Les deux runs ont le même digest de projection stable : `e78e55b0ba1ca58ac6da78efedef0afbb4d547fb6f6d1387023908360ec96263`.

## Refus et limites exercés

### Mismatch de dimensions

Une description depth candidate 33×32 face au RT 32×32 est refusée par le preflight du harnais. Le compteur de calls natifs est strictement identique avant/après ce refus : aucun setter ni `BeginScene` n'est entré avec cet état invalide.

Ce refus qualifie la barrière du harnais, pas un HRESULT historique Riot.

### Double BeginScene

Le second `BeginScene`, exécuté pendant que le harnais détient déjà la scène, renvoie `D3DERR_INVALIDCALL`. Un seul `EndScene` est ensuite émis, conformément à l'ownership réellement acquis.

### Device lost

Le device observé est coopératif (`S_OK`). L'injection forcée de `D3DERR_DEVICELOST` n'a pas été exécutée : elle demanderait une transition d'affichage/reset hors de ce lot sûr et borné. Le contrat est néanmoins explicite : tout résultat différent de `S_OK` à `TestCooperativeLevel` arrête le chemin avant `BeginScene`. Cela documente une limite ; ce n'est pas présenté comme un test device-lost réussi.

## Rollback et nettoyage

L'ordre de rollback a été : scissor, viewport, depth initial nul, RT0 initial ; la scène avait déjà été rendue. Tous les setters de rollback ont renvoyé `S_OK`.

La relecture finale confirme :

- même pointeur RT0 ;
- depth de nouveau absent avec `D3DERR_NOTFOUND` ;
- viewport et scissor exactement égaux au snapshot 64×64 ;
- aucun ownership de scène restant ;
- toutes les références de getters/owners et les deux surfaces jetables libérées ;
- `IDirect3DDevice9::Release = 0`, `IDirect3D9::Release = 0`, fenêtre détruite.

Ce rollback est complet pour **ce sous-ensemble** RT/depth/viewport/scissor/scène. Il ne ferme pas le rollback de toute la pipeline (shaders, constantes, textures, samplers, render states, géométrie et caches).

## Frontière négative vérifiable

Le ledger autorisé contient exactement 28 appels par run : 3 cooperative checks, 2 créations, 8 setters nominaux/rollback, 12 getters snapshot/verify/rollback, 2 `BeginScene` et 1 `EndScene` (le détail exact est dans les JSON).

L'adapter ne publie aucune méthode pour :

- `DrawPrimitive` / `DrawIndexedPrimitive` ;
- `Present` ;
- `GetRenderTargetData` / `GetFrontBufferData` ;
- `SetVertexShader` / `SetPixelShader`.

Les compteurs structuraux de ces slots interdits sont tous zéro. Cette preuve est une allowlist de l'adapter plus son ledger ; elle n'est pas annoncée comme une instrumentation générique de tout le processus.

## Effet précis sur les blocages V1159

| Blocage V1159 | Après V1160 |
|---|---|
| `RENDER_TARGET_DEPTH_VIEWPORT_SCENE_NOT_COMPOSED` | **Fermé comme composant current-host pré-draw séparé** : RT/depth compatibles, viewport/scissor bornés, device coopératif, Begin/End ownership et rollback de ce sous-ensemble sont maintenant exercés deux fois. |
| `BIND_TO_DRAW_SAME_RUN_COMPOSITION_NOT_QUALIFIED` | **Ouvert** : V1160 ne compose pas ce composant avec shaders, géométrie, material et futur draw dans un même run. |
| `FULL_PIPELINE_SNAPSHOT_AND_ROLLBACK_NOT_QUALIFIED` | **Ouvert** : seul le sous-ensemble scène/surfaces/viewport/scissor est restauré ici. |
| `DRAW_HRESULT_CAPTURE_AND_FAILURE_ROLLBACK_NOT_QUALIFIED` | **Ouvert** : aucun draw n'a été exécuté. |
| Constantes/material/textures/samplers | **Inchangés par ce lot**. |

Ainsi, V1160 retire bien l'inconnue autonome « peut-on établir et restaurer proprement la scène/les targets/viewport sur un device current-host ? ». Il ne rend pas le draw global READY à lui seul.

## Contrôles exécutés

```text
python audit_scene_state.py --run-id run1 --output scene_state_run1.json
=> exit 0, 20/20 checks, aucune erreur

python audit_scene_state.py --run-id run2 --output scene_state_run2.json
=> exit 0, 20/20 checks, aucune erreur

python validate_scene_state.py --output scene_state_validation.json
=> exit 0, 30/30 checks

python validate_scene_state.py
=> exit 0, output=null ; hashes des trois entrées inchangés avant/après
```

La validation par défaut est non mutante et écrit seulement sur stdout. `--output` est requis explicitement pour produire le reçu JSON.

## Livrables

- `audit_scene_state.py` — producteur current-host borné.
- `scene_state_run1.json` et `scene_state_run2.json` — deux exécutions natives.
- `validate_scene_state.py` — validateur indépendant du producteur, non mutant par défaut.
- `scene_state_validation.json` — reçu 30/30.
- `artifact_manifest.json` — tailles et SHA-256 des livrables.
- Revue indépendante : à joindre dans un répertoire sibling si un slot agent devient disponible ; son absence éventuelle ne doit pas être confondue avec la validation automatisée déjà passée.

## Conclusion

Le composant scene/targets/viewport/scissor est **READY comme preuve current-host séparée**, avec refus dimensionnel avant entrée native, refus réel du double BeginScene, ownership équilibré et rollback exact. L'exécution originale 4.20, la composition full-pipeline, tout draw/Present/readback et toute fidélité visuelle restent hors preuve et ouverts.
