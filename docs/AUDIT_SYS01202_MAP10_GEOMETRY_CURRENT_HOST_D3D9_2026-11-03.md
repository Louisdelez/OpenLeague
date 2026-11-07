# V1153 — Géométrie Map10 D3D9 current-host jusqu’à `0x95B112`

## Résultat borné

Le lot est fermé pour sa frontière déclarée. Deux exécutions finales, lancées après la dernière modification du probe, créent trois vrais objets D3D9 sur l’hôte courant (`NVIDIA GeForce RTX 3060`, `C:\Windows\System32\d3d9.dll`) : une déclaration de sommets, le vertex buffer NVR 1 et l’index buffer NVR 1. Les trois créations, les uploads, les lectures CPU sûres, les binds et les unbinds retournent `HRESULT 0`.

Le chemin original 4.20 est conservé pour les binds :

- `0x95B063 → 0x9C2BB0 → 0x9C5F60 → IDirect3DDevice9::SetVertexDeclaration` ;
- `0x95B0A4 → 0x9C2C40 → 0x9C5D30 → IDirect3DDevice9::SetStreamSource` ;
- `0x95B0D2 → 0x9C2B50 → 0x9C5E50 → IDirect3DDevice9::SetIndices`.

L’exécution s’arrête strictement à l’instruction originale `0x95B112`, avant l’appel `backend+0x20`. Aucun `DrawPrimitive`, `DrawIndexedPrimitive`, `Present`, readback de frame/backbuffer ou pixel rendu n’est exécuté.

## Sources et identités stables

- exécutable 4.20 : `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ;
- `room.nvr` : `89e873ec32356312b53628c9773c803b0e6e864a206ac2aafc6a584c8ae27082` ;
- mesh 1093 : matériau 1, VB 1, sommets `213..215`, IB 1, indices à partir de 252, valeurs `[213,214,215]` ;
- descripteur source selector 2 : 48 octets, SHA-256 `a0dae45b432dee6fdc2f4656f13d3f72b692ee4cfbcdc1e9d846389efada3784` ;
- descripteur D3D9 traduit, avec `D3DDECL_END` : 48 octets, SHA-256 `375b5c8b08666d26c3021e6aad676f5a674e67590bfa363faef2ebc72e543f38` ;
- VB1 : 60 324 octets, `1371 × 44`, SHA-256 `92a9cdf6b29773f49c1eca1a6e462fe61df920054998a61377407fa4b4ee8ac6` ;
- IB1 : 3 456 octets, format `D3DFMT_INDEX16` (`0x65`), SHA-256 `828c3d271f98cecbc4cc32d6245b111731356607daf9bc8c469a6afe7e73e607`.

La stabilité repose sur ces identités sources et non sur les adresses de processus.

## Création, upload et vérification

Le bridge current-host hérité a été étendu localement avec `IDirect3DVertexDeclaration9` et `CreateVertexDeclaration`. Les méthodes déjà présentes `CreateVertexBuffer`, `CreateIndexBuffer`, `Lock`, `Unlock`, `SetVertexDeclaration`, `SetStreamSource` et `SetIndices` sont réutilisées.

Les trois proxies guest sont distincts et typés :

1. `IDirect3DVertexDeclaration9`, créé depuis le descripteur D3D9 exact ;
2. `IDirect3DVertexBuffer9`, 60 324 octets, usage 0, FVF 0, pool managed 1 ;
3. `IDirect3DIndexBuffer9`, 3 456 octets, usage 0, format 101, pool managed 1.

VB1 et IB1 sont copiés intégralement par `Lock/Unlock`. Une seconde ouverture avec `D3DLOCK_READONLY` relit uniquement la mémoire des buffers ; les SHA-256 complets avant upload, dans la shadow guest et après lecture sont identiques. Cette vérification CPU ne lit ni frame, ni backbuffer, ni pixel rendu.

## Wrappers et continuité originale

Les wrappers d’enregistrement V1152 sont remplacés par des wrappers guest minimaux adossés aux trois vrais proxies current-host. Ils fournissent uniquement le comptage de références attendu et l’accesseur du proxy nécessaire aux fonctions originales. Ils ne sont pas présentés comme les wrappers COM historiques.

Dans chacun des deux runs, les appels nominaux observés sont :

- `SetVertexDeclaration(declaration_proxy)` → `0x0` ;
- `SetStreamSource(0, vertex_proxy, 0, 44)` → `0x0` ;
- `SetIndices(index_proxy)` → `0x0`.

À `0x95B112`, les arguments internes observés restent `[0,0,213,3,252,1]`. L’instruction suivante n’est pas exécutée.

## Refus et nettoyage

Le cas selector 0 est refusé par le préflight du harness : son stride 36 ne correspond pas au VB1 exact en stride 44. Aucune entrée native n’est tentée pour ce cas. Ce refus est une garde du harness, pas un comportement Riot revendiqué.

Après la frontière nominale, les mêmes setters originaux délient les ressources avec des valeurs nulles. Les trois refcounts de wrappers atteignent zéro. Les trois `IUnknown::Release` des objets D3D9 current-host retournent zéro, toutes les locks sont fermées, et la fenêtre cachée est détruite.

## Exécutions finales et contrôle indépendant

Les fichiers `map10_v1153_geometry_d3d9_execution_run1.json` et `run2.json` proviennent du même hash de probe final. Le validateur contrôle notamment les trois créations réelles, les deux payloads complets, les HRESULT, la trace native originale, le refus selector 0, la borne pré-draw, l’absence de rendu, les unbinds, les Releases à zéro et la reproductibilité des octets natifs.

Un run temporaire de mise au point, antérieur aux deux runs finaux, a échoué après un `SetVertexDeclaration(NULL)` pourtant réussi : le helper `invoke()` hérité ne connaissait pas encore le `ret 4` de `0x9C2BB0` ni les deltas des deux autres setters. La liste bornée a été complétée avec `0x9C2BB0:4`, `0x9C2C40:16` et `0x9C2B50:4`. Ce run n’est pas utilisé comme preuve finale.

## Limites explicites

- Les objets sont ceux du runtime D3D9 actuel et de la RTX 3060 actuelle, pas ceux du runtime 2014.
- Les factories historiques `0x9596D0` et `0x958420` ne sont pas exécutées ; la création et l’upload passent par le bridge current-host.
- Les fonctions de bind `0x9C2BB0`, `0x9C2C40` et `0x9C2B50` sont bien les fonctions originales de l’exécutable 4.20.
- Les shaders, constantes, détails de matériau et textures de détail restent des fixtures qualifiées héritées.
- Ce lot ne prouve ni draw, ni Present, ni frame, ni fidélité visuelle, ni complétude du jeu.

## Livrables

- `probe_map10_v1153_geometry_d3d9.py` ;
- `map10_v1153_geometry_d3d9_execution_run1.json` et `run2.json` ;
- `map10_v1153_geometry_d3d9_native_bytes_run1.json` et `run2.json` ;
- `validate_map10_v1153_geometry_d3d9.py` ;
- `map10_v1153_geometry_d3d9_validation.json` ;
- `v1153_geometry_d3d9_proof_index.json`.
