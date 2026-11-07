# Revue indépendante V1154 — bridge device shader D3D9

## Décision

**PASS, 55/55 contrôles ; aucun écart résiduel.**

La décision reste strictement limitée au bridge current-host avec fixtures synthétiques. Elle ne qualifie ni les shaders FOUR_BLEND, ni les producteurs Riot, ni le runtime D3D9 de 2014, ni les pools, le bind ou le rendu.

## Confrontations indépendantes

- Les 12 artefacts du manifeste source ont été rehashés : `12/12`, zéro divergence. Les trois reçus `debug_run*.json` sont bien exclus.
- Le PE 4.20 a été relu directement : SHA-256 `402bf2b9…d37862`, base `0x400000`, x86.
- Les fenêtres `0x9BEB4D..0x9BEB75`, `0x9BEC6D..0x9BEC95` et `0x9BED40..0x9BED76` reproduisent les hashes V1152. Les appels `+0x16C/+0x1A8`, les stores `wrapper+0x10` et le `Release` au slot `+0x08` sont présents aux adresses annoncées.
- Le header SDK relu donne les indices 91/92/106/107 pour `CreateVertexShader`, `SetVertexShader`, `CreatePixelShader`, `SetPixelShader`. L’AST du probe ne contient aucun dispatch vers les deux constantes Set.
- Le HLSL et `fxc.exe` ont été rehashés. Une recompilation indépendante VS/PS dans le dossier de revue reproduit exactement les CSO source : `1022732a…03791` et `75be600a…44769`.
- Le validateur source a été réexécuté, code 0, 45 contrôles ; son contenu est resté byte-identique (`859a7290…6360`).

## Troisième exécution current-host

Le probe final source, SHA-256 `eeeea95f…edf51`, a été réexécuté avec un reçu écrit uniquement dans ce dossier de revue.

Résultat :

- `CreateVertexShader` et `CreatePixelShader` : `HRESULT 0`, interfaces non nulles ;
- deux objets simultanément vivants et distincts ;
- pour chacun : `AddRef 2 → Release 1 → Release final 0` ;
- entrées invalides : `0x8876086C`, sorties nulles ;
- device et `IDirect3D9` relâchés à zéro, fenêtre détruite ;
- projection `b1ea1ef08ad63f5248cbcfc88e407090889c7a250cbf040abbfd013bfb130930`, identique aux deux runs finaux source.

Le reçu indépendant a pour SHA-256 `053a926f5a81a5e8b0ff92c67f4a1d91ffeb06dcd785627d4882701bc12f95ca`.

## Stop et limites confirmés

Aucun producteur `0x98D960/0x98C070`, D3DX, Set shader, pool, paire, bind, draw, `Present` ou readback de frame n’est exécuté. Les zéros restent des compteurs structurels, pas une trace historique Riot.

Le contrat device isolé peut être considéré fermé pour le harness actuel. Restent séparément ouverts le bridge D3DX, les pools, le cleanup composé possédé et la publication/bind/rendu des vrais shaders FOUR_BLEND.

Aucun artefact source ni fichier sous `F:` n’a été modifié en contenu par cette revue. Les seules créations se trouvent sous `E:\mapslol3v3\audit_map10_v1154_shader_device_review_20261103`.
