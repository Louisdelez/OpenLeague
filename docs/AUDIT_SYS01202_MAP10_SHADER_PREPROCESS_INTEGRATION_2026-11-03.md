# V1155 — Expansion native des includes et compilation FOUR_BLEND Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-SHADER-PREPROCESS-INTEGRATION-01`  
Verdict : **PASS pour la jonction bornée helper original + provider adapté + D3DX current-host ; producteurs et publication toujours hors périmètre**.

## Résultat borné

Les deux sources FOUR_BLEND exactes et leurs sept includes ont franchi la chaîne qui manquait entre V1153 et V1154 :

1. les octets 4.20 sont livrés par un provider lecture seule limité aux neuf chemins et SHA épinglés ;
2. le corps original `0x9AE410..0x9AE57E` expanse textuellement les directives `#include` avec les callbacks load/free et sa récursion native ;
3. un modèle indépendant reconstruit le même buffer, octet pour octet ;
4. ce buffer expansé est compilé avec `pInclude=NULL`, `main`, `vs_2_0`/`ps_2_0`, flags `0x1000` et les 26 macros exactes ;
5. code et CTAB sont relus puis leurs proxies sont libérés à zéro.

Ce résultat ne constitue pas une exécution du VFS Riot historique, des producteurs `0x98D960/0x98C070`, du runtime D3DX x86 de 2014 ou d’un draw.

## Outil natif exact

Le prétraitement observé n’est pas `D3DXPreprocessShader`. La factory 4.20 appelle d’abord le helper interne `0x9AE410`, puis seulement le helper D3DX `0x9BE940` avec `pInclude=NULL`.

Le corps `0x9AE410..0x9AE57F` couvre 367 octets, 130 instructions, SHA-256 `c84ac7d6a13a3581660e8db8db92dc831896d2384c7bd159c9ca554ba095d676`. Les instructions contrôlées démontrent :

- recherche textuelle de `#include` par `strstr` ;
- copie du préfixe ;
- recherche des deux guillemets et limite stricte de 512 octets ;
- callback include slot `+0x00`, récursion dans `0x9AE410`, puis callback free slot `+0x04` ;
- ajout de la fin du source ;
- retour `AL=1` ou `AL=0`.

Le helper développe les includes avant l’évaluation des `#ifdef`. Le fichier `HeightBlending.hls` est donc chargé même si `USE_HEIGHT_BLEND` n’est pas défini dans ce profil ; cette sémantique native est conservée.

## Sources et expansion

| Stage | Source exacte | Includes | Entrées helper | Buffer expansé |
|---|---:|---:|---:|---:|
| vertex | 7 825 octets, SHA `b7631de1…01e5` | 2 | 3 | 11 390 octets, SHA `6694b4cb…066ed` |
| pixel | 13 310 octets, SHA `d59435b2…95f3` | 5 | 6 | 25 052 octets, SHA `74858d63…6e021` |

Les sept charges suivent l’ordre des sources : Fog puis FogOfWar VS ; ShadowMap, HeightBlending, DeathScreen, MipLevels puis FogOfWar PS. Chaque payload correspond à sa taille et son SHA épinglés. Sept frees uniques sont observés, aucun buffer include ne reste vivant et aucun accès mémoire invalide n’est enregistré.

Dans les deux stages, le buffer produit par les instructions originales est strictement identique au modèle indépendant et ne contient plus de token `#include`.

## Compilation D3DX current-host

Le bridge V1154 exact, SHA-256 `40e2c2e863c1f9c832bb5d5d51eebad146fb5df1aad0ee97cd0852ce6db903ae`, transmet le buffer expansé à `D3DXCompileShader` current-host avec les trois macros du profil (`COLORPALETTE_DEFAULT`, `DISABLE_EMISSIVE`, `FOUR_BLEND`) suivies des 23 macros natives relues dans le PE.

| Stage | HRESULT | Bytecode | CTAB | Nettoyage |
|---|---:|---:|---:|---|
| vertex `vs_2_0` | `0x00000000` | 992 octets, SHA `c1a169e3…be42` | 464 octets, SHA `74ac0675…c40` | code/CTAB `Release→0`, zéro proxy |
| pixel `ps_2_0` | `0x00000000` | 1 244 octets, SHA `3d184c79…ca58` | 500 octets, SHA `791e0d1c…03f0` | code/CTAB `Release→0`, zéro proxy |

Aucun buffer d’erreur n’est retourné. Les adresses de proxies sont exclues de la projection déterministe.

## Refus et limites du helper

Quatre entrées négatives font retourner `AL=0` sans buffer vivant ni accès invalide : include non allowlisté, guillemet ouvrant absent, guillemet fermant absent et littéral de 512 octets. Le cycle synthétique `A→B→A` est refusé par l’adapter avant entrée native : le helper original ne montre aucune garde de cycle et il serait incorrect de lui attribuer une protection non prouvée.

Le provider du run est exact pour le corpus neuf-SHA mais n’est pas l’implémentation ou l’état historique du VFS Riot. Le D3DX exécuté est la DLL current-host x64 déjà qualifiée en V1154, pas la DLL x86 2014.

## Reproductibilité

Producteur final : `audit_shader_preprocess.py`, 31 469 octets, SHA-256 `4c4f72c75078552e314700e1a4055199920b662fb61ae5b334a0bea66a96e239`.

- run 1 : `PASS 16/16`, SHA-256 `f9a855b53d6a9685e3ed9cda6d7e6fe433a490380b61f43c6f6d6c0494bd2197` ;
- run 2 : `PASS 16/16`, SHA-256 `e15b83d0d12c1f4598eec16d90e03f0940eeebbb7d7061eb5385179f1e5c249d` ;
- projection commune : `2fc74c5dc01a7b57cc03e37710c38949565c0ddd4e12d35a447200c834808998` ;
- validation indépendante : `PASS 54/54`, reçu SHA-256 `7f95f9284e6d7a3022c780ea550d5007a034d3147de678a18f1f7121831db9a1`.

Commandes finales :

```powershell
python .\audit_shader_preprocess.py --run-id final-1 --output .\shader_preprocess_run1.json
python .\audit_shader_preprocess.py --run-id final-2 --output .\shader_preprocess_run2.json
python .\validate_shader_preprocess.py --output .\shader_preprocess_validation.json
```

Les reçus `debug_run*.json` sont supersédés et exclus du manifeste. Le premier debug avait révélé une erreur du hook de test : le stub de `__security_check_cookie` écrasait `EAX`, alors que l’original le préserve. La correction est antérieure aux deux runs finaux.

## Arrêt strict et reprise

Le harness n’entre jamais dans les producteurs `0x98D960/0x98C070`. Il ne crée aucun shader D3D, n’alloue aucun record de pool, n’exécute aucun cleanup possédé, bind, draw, `Present` ou readback.

La prochaine unité peut composer ces sorties exactes avec les bridges device/pool/cleanup V1154, toujours avant paire/bind/draw, puis seulement envisager une entrée producteur bornée. Cette unité ne qualifie ni publication FOUR_BLEND dans les records originaux, ni runtime 2014, ni image rendue, ni fidélité visuelle, ni complétude Map10 ou jeu.

Aucun fichier sous `F:`, produit, asset, registre, Goal, Plan, interface, application ou base n’a été modifié.
