# V1154 — Pools shader : allocation/libération bornée sans collision

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-SHADER-POOL-ADAPTER-01`  
Verdict : **contrat pool fermé pour l’adapter borné sur les primitives originales ; état historique vivant et cleanup des objets shader toujours ouverts**.

## Résultat borné

Le contrat d’indexation et de réservation des pools vertex/pixel est maintenant exécuté sans entrer dans les producteurs de shader. Les fonctions originales et autonomes `0x8E28C0` (allocate) et `0x8E2980` (free) tournent dans Unicorn sur deux managers synthétiques ayant exactement la disposition native et une capacité de `0x1000` slots chacun.

Dans chacun des deux runs finaux :

- les pools vertex et pixel allouent chacun les indices `0..4095`, sans collision ;
- l’appel suivant renvoie la sentinelle native `0x1000` ;
- les indices `0,31,32,63` libérés sont réalloués dans cet ordre, avec une génération distincte ;
- 4 100 allocations et 4 100 libérations possédées sont achevées par pool ;
- le cleanup final laisse zéro token possédé et 532 octets de bitmap à zéro dans les deux pools ;
- les refus stale/double-free, mauvaise famille, hors plage et saturation ne modifient aucun bitmap.

Ce résultat ferme le blocker `shader_pool_allocation_and_free_state` seulement pour cet adapter. Il ne reconstitue pas le contenu des pools d’une partie Riot de 2014 et n’exécute pas les factories ni les destructeurs de records.

## Contrat natif exact

L’exécutable PE32 x86 exact est épinglé par SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

| Fenêtre | Octets | SHA-256 | Rôle |
|---|---:|---|---|
| `0x8E2770..0x8E28C0` | 336 | `fb9ce17daa8c9aa72433f352296b426e8f1612599335a73c15541d311b69343e` | construction du manager et hiérarchie bitmap |
| `0x8E28C0..0x8E2976` | 182 | `8f00a3523e09c7add64d765bb91842b8f10eea0209022c1599ada966e6e44870` | allocation du premier bit libre |
| `0x8E2980..0x8E29C4` | 68 | `28e3dab3f83375f2bdc1e212ecce1f402f5a77ee9e0a20c8d14b1c6e82fea29b` | libération d’un index |
| `0x9AE580..0x9AEA82` | 1 282 | `8e0b16e5e99b4a0105742f065c4876f78340cb2d7a5f7bb74999595bd29323c0` | création/destruction des tableaux et managers shader |
| `0x9AEA90..0x9AEE30` | 928 | `13abd6fb52b33de16d90d6678ddd2b5b358373ea6b1933bb4d10bdc6d30f4cf4` | factories VS/PS et releases de records |

Les deux tableaux de records contiennent `0x1000` entrées de huit octets : `[pointeur stage backend, refcount]`.

| Pool | Base records | Manager | Factory | Release |
|---|---|---|---|---|
| vertex | `0x2D79574` | `0x2D79638` | `0x9AEA90` | `0x9AED50` |
| pixel | `0x2D791D0` | `0x2D792CC` | `0x9AEBF0` | `0x9AEDC0` |

Les factories appellent `0x8E28C0`, refusent l’index égal à `0x1000`, calculent `base + index*8`, publient le pointeur et fixent le refcount à 1. Quand le refcount atteint zéro, les releases calculent `(record-base)>>3`, appellent `0x8E2980`, puis mettent `record[0]` à zéro.

Pour une capacité de 4 096, le manager construit trois niveaux de bitmaps, `128 + 4 + 1` DWORD, soit 532 octets. Les pointeurs sont exposés du niveau sommet vers les feuilles ; les octets physiques restent contigus des feuilles vers le sommet. Les deux managers du harness occupent des adresses et des bitmaps distincts.

## Exécution originale contrôlée

Une allocation nominale traverse 103 instructions et reste dans `0x8E28C0..0x8E2976` avant la sentinelle de retour ; SHA de la séquence d’adresses : `9294c64e1a376382035a9f3cee16d8414f153528e5f4767d0cb16fd45496c7df`.

Une libération nominale traverse 55 instructions et reste dans `0x8E2980..0x8E29C4` ; SHA de la séquence : `1ef85660f8b1c27f2039e7fe2d43614b66266db3080f343a16fa609860a005be`.

À saturation, les 4 096 indices distincts sont présents, min 0 et max 4 095. Le bitmap complet a SHA `9c4b2a8529a741011bf514bb5f3f778705aa49bd6122e4cc1049bcc7345fd70b`. Après libération complète, son SHA revient à `47bed81b9dd45f914b6f4c65d96eb6803050cbb576f6f4d2e7911d0b35983b51`, avec zéro octet non nul.

## Garde d’ownership et refus

La primitive native free est **non gardée** : une seconde libération directe du même index laisse le bitmap inchangé. Ce constat est qualifié, pas promu en comportement sûr.

L’adapter ajoute donc un token `(pool, index, génération)` et refuse avant l’entrée native :

- six tokens stale ou non possédés par pool, dont une seconde libération et quatre anciennes générations après réallocation ;
- un token de la mauvaise famille de pool ;
- les indices `-1` et `0x1000` ;
- une allocation supplémentaire à saturation.

Chaque refus compare le SHA du bitmap avant/après et démontre l’absence de mutation. Ces refus sont des règles de sécurité de l’adapter, pas un comportement Riot revendiqué.

## Reproductibilité et validation

Après la dernière modification du producteur `audit_shader_pool_adapter.py` (25 750 octets, SHA-256 `90a7232b0c945cdcd392387a070e386aa96604260ab860a35bb81092b500c14c`) :

- run 1 : `PASS 12/12`, SHA-256 `41f2c09cbba53be4b586a913afccbe5abef7ccb7876fbefdcdfd57eab22f78cc` ;
- run 2 : `PASS 12/12`, SHA-256 `62ced86e221bd24c3c62512af7298f816beac695efd789203cc82d47f456869a` ;
- projection sémantique commune : `103685e29e8a292f246078f6fc815b5ab2f9b01f23c0c186c68eb35e81839c9e` ;
- validation indépendante : `PASS 46/46`, reçu SHA-256 `9cf8906b078c8bccbfee0fbc653d02cec66315fad3a139e22ceb243e4dca9edb`.

Le validateur est non mutant par défaut ; `--output` est nécessaire pour régénérer son reçu daté. Les reçus `debug_run*.json` sont des mises au point supersédées et ne sont ni des preuves finales ni des entrées du manifeste.

Commandes finales :

```powershell
python .\audit_shader_pool_adapter.py --run-id 1 --output .\shader_pool_adapter_run1.json
python .\audit_shader_pool_adapter.py --run-id 2 --output .\shader_pool_adapter_run2.json
python .\validate_shader_pool_adapter.py --output .\shader_pool_adapter_validation.json
python .\validate_shader_pool_adapter.py
```

## Borne stricte et reprise

Seules les fonctions originales `0x8E28C0` et `0x8E2980` sont entrées. Les compteurs structurels restent à zéro pour :

- producteurs `0x98D960/0x98C070` ;
- compilation D3DX ;
- `CreateVertexShader/CreatePixelShader` ;
- factories `0x9AEA90/0x9AEBF0` et releases `0x9AED50/0x9AEDC0` ;
- bind, draw, `Present` et readback.

Ces compteurs appartiennent au harness, pas au runtime Riot.

Le blocker pool est fermé pour l’adapter. Restent séparément ouverts le cleanup possédé complet des objets/records via `0x9AED50/0x9AEDC0 → 0x9BED40`, l’intégration des contrats VFS/D3DX/device/pool aux producteurs, les sources FOUR_BLEND compilées par ce chemin, puis bind/draw/`Present`/pixels. Le runtime 2014 et l’intégration Rust ne sont pas qualifiés.

Aucun fichier sous `F:` ou `D:`, produit, asset, registre, Goal, Plan, interface, application ou base n’a été modifié. Aucun logiciel n’a été installé et le PE n’a pas été réimporté dans REA.
