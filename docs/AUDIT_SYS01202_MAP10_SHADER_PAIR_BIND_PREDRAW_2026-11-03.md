# V1159 — bind shader pair FOUR_BLEND, arrêt strict pré-draw

## Verdict

**PASS technique borné.** Deux exécutions finales indépendantes composent les deux shaders FOUR_BLEND exacts de V1158, le pair/cache et résolveur 4.20, puis le corps x86 original du binder `0x9BEF40`. Sur le device D3D9 courant, l’ordre observé est `SetVertexShader` puis `SetPixelShader`, avec `HRESULT 0x00000000` pour les deux appels. Les getters D3D9 confirment ensuite que le VS et le PS attendus sont liés.

Ce verdict ne porte que sur le bind pré-draw courant-host. Il ne qualifie ni le runtime Riot de 2014, ni un draw, ni une image, ni la fidélité visuelle du jeu.

## Périmètre et sources

- Source originale : `League of Legends.exe` 4.20, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.
- Binder original : `0x9BEF40..0x9BEF73`, empreinte statique V1157 `f6b38deb08c879b497be81bad3cc345ba24624bef206bc0453a1e0936a526067`.
- Résolveur original : `0x9C22E0`; callsite bind `0x9C2372`; store current pair `0x9C2378`.
- Pair factory/release originaux : `0x9AEE30` / `0x9AEFE0`.
- Base composée : V1158, source épinglée SHA-256 `931882cd991039b52464fea33c87456a998b36923488eb2268ef3cb802444e66`.
- Device courant : `NVIDIA GeForce RTX 3060`, `C:\Windows\System32\d3d9.dll`, SHA-256 `9c2343d50ab0e219d6526be5c419b2c5dc62e88c30444c936927001e3bdc89e6`.
- Les deux shaders sont créés sur cet unique device courant. Ce n’est pas le runtime historique Riot 2014.

Identités FOUR_BLEND reprises et revérifiées :

| Stage | Source SHA-256 | Expansion SHA-256 | Bytecode SHA-256 | CTAB SHA-256 |
|---|---|---|---|---|
| VS | `b7631de1e9c88a91111bf566f4097403a5de2e2bb173ebd6145df6d6c1eb01e5` | `6694b4cb1ea6566ef1c7b85ce9d4f33ea2a35789af073e86615ce9bdd58066ed` | `c1a169e3aabfe63ac7d90413aee2c440acc1525f8c80cafef4bceb08f0c5be42` | `74ac067514e52ea1c3b264110a52ffed8a3103743f69dd10567536d6892ddc40` |
| PS | `d59435b2f2255afd73672da397f464b890923bfdd9b0e9ffacccb01c7b4395f3` | `74858d63d5b4d048d15f472f706ba181a300c20160ea5ea01b8b602a20c6e021` | `3d184c7984532a8177ce3588a66e7bc0b1fc931d46c3d3f79db3026cd1e5ca58` | `791e0d1c2fd7d7804886e10f0862b95da399808aa4f60389b899f1e3a00d03f0` |

## Résultat nominal

Le résolveur original crée/récupère le pair, appelle le binder original et exécute son store du current pair :

- cache value : `0x67000000` ;
- current pair : `0x67000000` ;
- backend pair : `0x68000100` ;
- premier setter : VS, slot D3D9 92, `HRESULT 0x00000000` ;
- second setter : PS, slot D3D9 107, `HRESULT 0x00000000` ;
- `GetVertexShader` et `GetPixelShader` : `HRESULT 0x00000000`, identités égales aux objets courants créés pour FOUR_BLEND ;
- seconde résolution cache-hit/current-equal : aucun nouveau pair, aucune insertion et aucun bind ; cache, current, refcounts et état device inchangés ;
- binder appelé avec un pair nul : aucun setter et état device inchangé. Ce cas est un no-op, pas une primitive d’unbind.

Le préflight `same_device=False` refuse avec `device_not_coresident`, sans entrée native et sans mutation du bitmap pair.

## Atomicité et rollback

Le corps Riot `0x9BEF40` ne teste aucun des deux `HRESULT` et n’effectue aucun rollback. Le diagnostic borné force donc le second retour à `0x8876086c` au niveau du pont invité→host :

1. le vrai `SetVertexShader` courant-host réussit (`0x00000000`) ;
2. le pont `SetPixelShader` renvoie `0x8876086c` et supprime intentionnellement l’appel host correspondant ;
3. `GetVertexShader` observe le VS FOUR_BLEND, alors que `GetPixelShader` reste nul : l’état partiel est démontré ;
4. le harness, et lui seul, restaure explicitement le snapshot Get* précédent ; les deux getters reviennent à nul.

Cette injection démontre le comportement du binder face à un échec du second slot et la nécessité d’un rollback externe. Elle **ne prétend pas** être un échec généré par le driver NVIDIA et le rollback **n’est pas attribué au code Riot**.

## Cleanup et frontière d’arrêt

Avant fermeture du device :

- VS/PS unbound et vérifiés nuls par Get* ;
- cache, current pair et desired handles à zéro ;
- release pair original exécuté une fois ;
- backend pair libéré ;
- slot bitmap pair libéré par rollback explicite via l’original `0x8E2980`, après retrait du cache ;
- records/bitmaps pair et stages à zéro ;
- proxies D3DX et shaders host à zéro ;
- aucun accès invité invalide.

À la fermeture : aucune release shader forcée, device et D3D9 retournent un refcount nul, fenêtre détruite.

Surface D3D9 exposée : `Set/GetVertexShader` et `Set/GetPixelShader` seulement. Compteurs structurels : trois entrées binder (nominal, null no-op, diagnostic d’échec), deux vrais SetVS, un vrai SetPS, un échec PS injecté, **zéro Draw, zéro Present, zéro readback**. Aucune image n’a été créée.

## Exécutions et validation

Commandes réellement exécutées après la dernière modification du producteur :

```powershell
python E:\mapslol3v3\audit_map10_v1159_shader_bind_20261103\audit_shader_bind.py --run-id final-1 --output E:\mapslol3v3\audit_map10_v1159_shader_bind_20261103\shader_bind_run1.json
python E:\mapslol3v3\audit_map10_v1159_shader_bind_20261103\audit_shader_bind.py --run-id final-2 --output E:\mapslol3v3\audit_map10_v1159_shader_bind_20261103\shader_bind_run2.json
python E:\mapslol3v3\audit_map10_v1159_shader_bind_20261103\validate_shader_bind.py --source E:\mapslol3v3\audit_map10_v1159_shader_bind_20261103\audit_shader_bind.py --run1 E:\mapslol3v3\audit_map10_v1159_shader_bind_20261103\shader_bind_run1.json --run2 E:\mapslol3v3\audit_map10_v1159_shader_bind_20261103\shader_bind_run2.json --output E:\mapslol3v3\audit_map10_v1159_shader_bind_20261103\shader_bind_validation.json
```

Résultats :

- run final-1 : PASS ;
- run final-2 : PASS ;
- projection déterministe commune : `87d0fa59e9ebfaba215d772322bb88cd6e9ec7d3bc1a65fb116b88a0b218d072` ;
- validateur non-mutant : PASS, `87/87`, zéro échec ;
- source producteur : SHA-256 `e0cc246dfe8d4f8c3cad538edc0c707e119c96cadac36f5159156db197e72f77`.

## Limites ouvertes

- Le device, le runtime D3D9 et les shaders créés sont current-host, pas Riot 2014.
- Le backend pair, l’insertion cache, l’objet device invité et le pont setter restent des adapters bornés ; les corps originaux pair/résolveur/binder sont identifiés séparément dans les reçus.
- Le diagnostic d’échec PS est injecté au pont ; un échec natif du driver n’a pas été provoqué.
- La release pair originale ne libère pas son slot bitmap ; le harness applique le rollback explicite déjà qualifié en V1158.
- Aucun draw, Present, readback ou jugement visuel n’est couvert. La tâche SYS-01.2-02 et le jeu complet ne sont pas déclarés terminés par ce lot.
