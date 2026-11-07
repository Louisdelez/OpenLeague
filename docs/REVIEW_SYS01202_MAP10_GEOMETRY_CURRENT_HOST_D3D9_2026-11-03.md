# Revue indépendante V1153 — géométrie Map10 D3D9 current-host

## Verdict

**PASS — 53/53 contrôles indépendants.** Aucun écart n’a été relevé dans la frontière déclarée du lot.

La revue confirme que les deux reçus finaux sont postérieurs au probe final épinglé, qu’ils utilisent le même SHA-256 de probe, et que leur projection sémantique est identique. Le validateur du lot a été réexécuté avec un code de sortie `0` et ses `29/29` contrôles sont vrais.

Cette revue ne transforme pas le lot en preuve de rendu. Elle qualifie uniquement la création current-host des trois objets de géométrie, leur transfert, leur bind par le chemin original 4.20, puis l’arrêt pré-draw et le nettoyage.

## Contrôles indépendants de source

- Exécutable 4.20 relu directement : SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, image base `0x400000`.
- `room.nvr` relu et reparsé directement : SHA-256 `89e873ec32356312b53628c9773c803b0e6e864a206ac2aafc6a584c8ae27082`.
- Mesh 1093 recomposé depuis la table NVR : matériau 1, VB 1, sommets `213..215`, IB 1, indices à partir de 252, valeurs `[213,214,215]`.
- Le triangle source est non dégénéré ; aire calculée `17618.668659319083`.
- VB1 : 60 324 octets, SHA-256 `92a9cdf6b29773f49c1eca1a6e462fe61df920054998a61377407fa4b4ee8ac6`.
- IB1 : 3 456 octets, format `0x65`, SHA-256 `828c3d271f98cecbc4cc32d6245b111731356607daf9bc8c469a6afe7e73e607`.
- Le descripteur selector 2 a été reconstruit indépendamment depuis les écritures machine et les tables de traduction du PE : SHA source `a0dae45b432dee6fdc2f4656f13d3f72b692ee4cfbcdc1e9d846389efada3784`, SHA D3D9 `375b5c8b08666d26c3021e6aad676f5a674e67590bfa363faef2ebc72e543f38`.
- La table de stride relue dans le PE donne bien 36 pour selector 0 et 44 pour selector 2.

Les deux fichiers de trace native contiennent chacun 6 722 entrées. Les 13 444 entrées ont été comparées à l’exécutable source par traduction VA → offset PE : zéro divergence. Les deux traces sont byte-identiques.

## Création, transfert et continuité

Dans chacun des deux reçus :

- `CreateVertexDeclaration`, `CreateVertexBuffer` et `CreateIndexBuffer` sont recensés comme appels `real_COM`, avec trois proxies distincts et `HRESULT 0` ;
- les paramètres déclarent exactement le descripteur D3D9, VB1 de 60 324 octets et IB1 de 3 456 octets/format `0x65` ;
- les deux séquences sont `Lock → Unlock → Lock READONLY → Unlock`, avec `HRESULT 0` ;
- les SHA source, upload guest et readback CPU sont identiques pour les payloads complets ;
- les binds nominaux passent par `0x9C2BB0`, `0x9C2C40`, `0x9C2B50`, puis par les setters D3D9 correspondants, tous avec `HRESULT 0` ;
- les arguments de bind sont les trois proxies créés et un stride de 44.

Le terme « réel » reste borné : ce sont des objets COM du `d3d9.dll` courant sur la RTX 3060, pas des objets du runtime de 2014.

## Frontière et refus

La frontière observée est `0x95B112`, avec les arguments internes `[0,0,213,3,252,1]`. L’instruction suivante `backend+0x20` n’est pas exécutée.

Les événements ne contiennent aucun `DrawPrimitive`, `DrawIndexedPrimitive`, `Present`, `GetRenderTargetData`, `GetFrontBufferData`, frame readback ou backbuffer readback. Le compteur de rendu reste à zéro et `render_complete=false`.

Le cas selector 0 est refusé avant entrée native parce que son stride 36 est incompatible avec le VB1 exact en stride 44. Le reçu le qualifie correctement comme garde du harness : aucun comportement de refus Riot n’est revendiqué.

## Nettoyage

Les trois ressources sont déliées avec des valeurs nulles et `HRESULT 0`. Les trois refcounts de wrappers atteignent zéro. Les trois `IUnknown::Release` des objets de géométrie retournent zéro. La dernière ligne de nettoyage de chaque proxy current-host recensé termine avec `remaining_owned=0`, toutes les paires Lock/Unlock sont fermées, `host_cleanup_complete=true`, et la fenêtre cachée est détruite.

## Intégrité des preuves

L’index V1153 comporte 12 entrées. Les 12 chemins, tailles et SHA-256 ont été recalculés, y compris le producteur V1152 épinglé : zéro divergence.

Livrables de cette revue :

- `review_v1153_geometry_d3d9.py` ;
- `geometry_d3d9_independent_review.json` ;
- le présent rapport ;
- `artifact_manifest.json`.

## Limites conservées

- Le probe graphique complet n’a pas été réexécuté par cette revue ; elle vérifie les deux exécutions finales déjà produites, les sources immuables, leurs octets et leurs contrats, puis réexécute le validateur borné.
- Les factories historiques `0x9596D0` et `0x958420` ne sont pas exécutées.
- Le readback est celui des buffers CPU via `D3DLOCK_READONLY`, pas celui d’une frame, d’un backbuffer ou d’un pixel rendu.
- Aucun draw, Present, frame, fidélité visuelle ou complétude Map10/jeu n’est prouvé.
- Shaders, constantes, détails de matériau et textures de détail restent hors de ce lot.
