# V1154 — Bridge D3DX buffer / constant table, current-host

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-SHADER-D3DX-BRIDGE-01`  
Verdict : **contrat fermé pour l’adapter/harness current-host borné ; intégration aux producteurs originaux et publication toujours ouvertes**.

## Résultat borné

Le second blocker de publication shader recensé en V1152 est fermé dans la portée exacte de l’adapter/harness :

- l’ABI x86 originale du helper `0x9BE940..0x9BEAFA` est relue dans le PE 4.20 ;
- les paires `D3DXMACRO` invitées 32 bits sont traduites vers l’ABI hôte 64 bits ;
- les sorties shader, diagnostics et constant table sont représentées par des proxies invités distincts ;
- les trois méthodes effectivement consommées par le client sont exercées : `Release`, `GetBufferPointer` et `GetBufferSize` ;
- un vertex shader et un pixel shader synthétiques sans include sont physiquement compilés par le vrai `D3DXCompileShader` de `C:\Windows\System32\d3dx9_39.dll` ;
- l’échec de compilation et six refus avant appel hôte sont nettoyés sans proxy COM vivant.

Ce résultat n’est ni une exécution du runtime 2014, ni une compilation des deux fichiers FOUR_BLEND complets, ni une publication de shader Riot.

## Contrat original relu

L’exécutable est le PE32 x86 exact, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

Le helper original couvre 442 octets, de `0x9BE940` à `0x9BEAFA`, SHA-256 `494cf3e135f0a42981886996b36b02cd485f7ea1a4f29d64dd770e662139f800`. Les 150 instructions décodées confirment l’appel IAT `0xFA4800` et ses dix arguments :

1. source et taille ;
2. tableau de macros terminé par deux pointeurs nuls ;
3. include nul ;
4. point d’entrée `main` ;
5. profil `vs_2_0` ou `ps_2_0` ;
6. flags `0x1000` ;
7. sorties code, diagnostics et constant table.

Le chemin original utilise ensuite les slots invités :

| Interface | Offset x86 | Index |
|---|---:|---:|
| `Release` | `+0x08` | 2 |
| `GetBufferPointer` | `+0x0C` | 3 |
| `GetBufferSize` | `+0x10` | 4 |

Le helper copie d’abord les macros du caller puis les 23 paires natives de `0x1225B10`. Leur ordre et leurs textes ont été relus dans le PE. Le harness utilise donc les trois paires du profil FOUR_BLEND sélectionné en V1151 :

- `COLORPALETTE_DEFAULT=1` ;
- `DISABLE_EMISSIVE=1` ;
- `FOUR_BLEND=1` ;

puis les 23 paires natives, de `VCOLORSWIZZLE=rgba` et `IS_OPENGL=0` jusqu’aux alias de sémantiques `X3D_VSIN_*`. Le tableau traduit contient exactement 26 paires et un terminateur nul.

## Compilations physiques current-host

Les DLL sont épinglées séparément :

- hôte x64 : `aecbe2965f7c9aa60257670114c06b21a3de914b03e20ff569c5cb44ec4807fd` ;
- invitée x86 de référence : `5d29988cad858f754ecc62c3d30de555f82cc21b5b26c448b890295e9b7bee82`.

Les deux fixtures sont volontairement courtes, sans include, et portent le contrat exact des macros/profils. Elles ne remplacent pas les sources historiques.

| Cas | HRESULT | Bytecode | Constant table | Nettoyage |
|---|---:|---:|---:|---|
| vertex `vs_2_0` | `0x00000000` | 272 octets, SHA `54e82f72…c2821` | 144 octets, `gWorldViewProjection` présent | deux `Release → 0` |
| pixel `ps_2_0` | `0x00000000` | 184 octets, SHA `a94c8cfb…c36a` | 128 octets, `Tint` présent | deux `Release → 0` |

Les miroirs invités retournés par `GetBufferPointer` sont des copies bornées de la taille donnée par `GetBufferSize`. Ils sont supprimés avec leur proxy ; aucun pointeur hôte 64 bits n’est exposé comme pointeur invité 32 bits.

## Échec et refus contrôlés

Une source pixel syntaxiquement invalide produit `0x80004005`, sans code ni CTAB, avec un buffer de diagnostic de 123 octets contenant `error X3000`. Le buffer de diagnostic est lu puis libéré ; son `Release` retourne zéro.

Six entrées sont refusées avant tout appel D3DX, avec sorties maintenues à zéro :

1. interface include non nulle ;
2. profil hors `vs_2_0/ps_2_0` ;
3. source nulle ;
4. flags différents de `0x1000` ;
5. paire macro partielle ;
6. tableau de 1 024 paires sans terminateur.

Une lecture et une seconde libération après `Release` sont également refusées comme `proxy_already_released`. Au total, seuls trois appels physiques D3DX ont lieu : vertex nominal, pixel nominal et erreur syntaxique.

## Reproductibilité et contrôles

Après la dernière modification du producteur `audit_shader_d3dx_bridge.py` (SHA-256 `40e2c2e863c1f9c832bb5d5d51eebad146fb5df1aad0ee97cd0852ce6db903ae`) :

- run 1 : `PASS`, 21 contrôles ;
- run 2 : `PASS`, 21 contrôles ;
- validation indépendante : `PASS 38/38` ;
- projection sémantique commune : `af9799640f32244f8d954bd841c89305777921767891ca62706216addc2441da`.

Commandes réellement exécutées :

```powershell
python .\audit_shader_d3dx_bridge.py --output .\shader_d3dx_bridge_run1.json
python .\audit_shader_d3dx_bridge.py --output .\shader_d3dx_bridge_run2.json
python .\validate_shader_d3dx_bridge.py --output .\shader_d3dx_bridge_validation.json
```

Le validateur est non mutant par défaut ; l’option `--output` est nécessaire pour régénérer le reçu daté. Le fichier `debug_run.json` est un reçu de mise au point supersédé. Ses compilations avaient réussi, mais le contrôle statique associait par erreur `push edi` à `0x9BEA38` au lieu de `0x9BEA39`. Il n’est utilisé ni par la validation finale ni par le manifeste.

## Condition d’arrêt et limites

Les compteurs structurels du harness restent à zéro pour :

- entrées originales `0x98D960` et `0x98C070` ;
- `CreateVertexShader` et `CreatePixelShader` ;
- allocation/libération des pools ;
- bind, Draw, Present et readback frame/ressource.

Il s’agit de compteurs du harness, pas d’une trace Riot.

Les deux vrais fichiers `Environment/LIT_VS.vs_2_0` et `Environment/LIT_PS.ps_2_0` ne sont pas compilés dans ce lot. Le client original fournit à `0x9BE940` un buffer déjà produit par sa chaîne VFS/préprocesseur avec `pInclude=NULL`. Le raccord entre le provider V1153 et ce buffer prétraité doit donc être exercé dans une unité d’intégration ultérieure ; utiliser directement un callback include D3DX ne reproduirait pas ce chemin.

Trois blockers de publication restent séparément ouverts :

1. bridge `CreateVertexShader/CreatePixelShader` et `Release` ;
2. pools shader sans collision, avec allocation/libération prouvées ;
3. nettoyage possédé complet via `0x9AED50/0x9AEDC0 → 0x9BED40`.

Le draw, `Present`, les pixels, le runtime 2014 et l’intégration Rust restent hors de ce lot. Aucun fichier produit, asset, registre, Goal, Plan, interface, application ou base n’a été modifié ; aucun logiciel ou modèle n’a été installé ; REA n’a pas réimporté le PE.
