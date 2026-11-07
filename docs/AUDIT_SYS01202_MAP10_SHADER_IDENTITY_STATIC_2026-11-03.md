# V1151 — Identité shader Map10/type 3, chaîne statique originale

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-SHADER-IDENTITY-STATIC-01`  
Verdict : **chaîne d’identité statique clôturée ; identité d’objet compilé historique toujours ouverte**.

## Périmètre et garde-fous

Ce lot relie uniquement le sélecteur terrain type 3 à ses noms, descripteurs, producteurs de records, handles, état backend, paire shader et appels D3D9. Il réutilise les contrats et preuves V1150 existants. Aucune exécution produit, compilation shader réelle, image GPU, installation, migration ou modification de `F:\OpenLeague`, du Goal, du Plan, de l’UI, de la base ou du registre n’a été effectuée.

Exécutable original épinglé :

- `D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`
- taille : `15 973 880` octets ; SHA-256 : `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ; PE32 x86, base `0x400000`.

Contrats réutilisés et réépinglés :

- sélection environnement : SHA-256 `5921c903140cf70fec95625306a9a2b82529c45d4ebb79f4b68e93eabdf63940` ;
- catalogue des descripteurs : SHA-256 `e685343d717e7326f2a5b6bf30d6ea1881b01ac1a3519d42e23a21e7deb5f5e4` ;
- fusion des macros : SHA-256 `e8c78ce146db68b492db92f3be8c7071f0128674d1be09f682f48933fbeecd9e` ;
- validation runtime V1150 : SHA-256 `060ee57e52188db9fba51414b9ef4dedc1a1442be0d67262e21b50d3b5d8f178`.

## Résultat précis

### 1. Sélection type 3

Dans `0x95A730`, pour `pass_selector=0`, `material_type=3` et le bit 2 des options globales à zéro, la branche originale choisit :

- vertex : chaîne PE `Environment_LIT_FOUR_BLEND_VS` à `0x10DAC88`, poussée à `0x95A850`, puis recherche `0x9805C0` à `0x95A85B` ;
- pixel : chaîne PE `Environment_LIT_FOUR_BLEND_PS` à `0x10DA634`, poussée à `0x95A885`, puis recherche `0x9805C0` à `0x95A890`.

Quand le bit 2 est actif, la branche alternative choisit `Environment_LIT_NO_EMISSIVE_VS/PS`. Ces deux branches ne doivent pas être confondues.

Les noms FOUR_BLEND ne sont pas des noms inventés par un adaptateur : ce sont des chaînes exactes du PE et les champs exacts des descripteurs originaux.

### 2. Descripteurs et enregistrement

Les deux descripteurs sont la ligne 10 de leur table respective, avec un pas de 12 octets :

| Stage | Descripteur | Source originale | Defines |
|---|---:|---|---|
| Pixel | `0x123F550` | `Environment/LIT_PS.ps_2_0` | `DISABLE_EMISSIVE;FOUR_BLEND` |
| Vertex | `0x123F678` | `Environment/LIT_VS.vs_2_0` | `DISABLE_EMISSIVE;FOUR_BLEND` |

La fonction `0x959D30` parcourt :

- 23 lignes pixel depuis `0x123F4D8`, produit le record via `0x98C070` (`call 0x95A071`) ;
- 22 lignes vertex depuis `0x123F600`, produit le record via `0x98D960` (`call 0x95A24E`).

Les sources archivées existent et leurs empreintes sont celles déjà déclarées dans le catalogue :

- PS : `d59435b2f2255afd73672da397f464b890923bfdd9b0e9ffacccb01c7b4395f3` ;
- VS : `b7631de1e9c88a91111bf566f4097403a5de2e2bb173ebd6145df6d6c1eb01e5`.

### 3. Index, record et handle réellement consommé par le code

`0x9805C0` ne renvoie pas un objet shader. Il renvoie un **index numérique** ou `-1` :

- table pixel : compteur `manager+0x2D0`, noms `manager+0x30C`, pas `0x80` ;
- table vertex : compteur `manager+0x102D8`, noms `manager+0x10314`, pas `0x80`.

Les producteurs publient ensuite leur handle à `record+4` :

- pixel : appel compilateur virtuel `0x98C2AA`, factory `0x9AEBF0`, store `0x98C2B9` ;
- vertex : appel compilateur virtuel `0x98DB9A`, factory `0x9AEA90`, store `0x98DBA9`.

Le handle publié est une entrée de pool de deux champs : `[pointeur objet de stage backend, refcount]`. Les consommateurs sont :

- `0x95A520` : index vertex -> `manager+0x102E0+index*0x80` -> slot backend `+0x84` ;
- `0x95A570` : index pixel -> `manager+0x2D8+index*0x80` -> slot backend `+0x90`.

Le backend `0x10E2F30` mémorise ces handles :

- `+0x84 -> 0x9C30C0`, champ désiré `backend+0xAC` pour le vertex ;
- `+0x90 -> 0x9C3110`, champ désiré `backend+0xA8` pour le pixel.

### 4. Paire et objets D3D9 bruts

`0x9C22E0` lit `backend+0xAC/+0xA8`, cherche la paire dans son cache et appelle `0x9AEE30` en cas d’absence. Le record de paire contient `[pointeur paire backend, refcount, handle vertex, handle pixel]`.

Sur la branche identifiée D3D9 par ses appels directs à la vtable `IDirect3DDevice9` :

- `0x9BEB00` crée le vertex shader via offset `0x16C` (`CreateVertexShader`) et place l’interface brute à `wrapper+0x10` ;
- `0x9BEC20` crée le pixel shader via offset `0x1A8` (`CreatePixelShader`) et place l’interface brute à `wrapper+0x10` ;
- `0x9BEE80` construit la paire backend ;
- `0x9BEF40` lit les deux wrappers et appelle offset `0x170` (`SetVertexShader`) puis `0x1AC` (`SetPixelShader`).

Ainsi, les couches d’objet consommées sont distinguées : index de registre -> handle de pool par stage -> état désiré backend -> record de paire -> paire D3D9 -> interfaces D3D9 brutes.

### 5. Le slot `+0x98` n’est pas un objet shader

Dans la même vtable, `+0x98 -> 0x9C3140` est la frontière d’envoi de **constantes shader**. V1150 l’a franchie avec un adaptateur ABI explicite. Cela ne prouve ni la compilation, ni la publication, ni l’identité d’un vertex/pixel shader historique.

## Ce que V1150 prouve réellement

Le probe V1150 a configuré :

- options globales `4`, donc branche type 3 `NO_EMISSIVE` ;
- flags de caches `1|2|0x4000|0x8000` ;
- indices en cache `0x2D90F94` et `0x2D8DF28` à `-1`.

Il a donc demandé des handles shader nuls via `0x95A520/0x95A570`. Il n’a ni créé ni lié les objets FOUR_BLEND. Il s’est arrêté sur l’instruction originale `0x95B112`, avant `DrawIndexedPrimitive`; aucun Draw, Present ou pixel de frame ne constitue une preuve V1150.

## Distinction des preuves

| Élément | État |
|---|---|
| Noms FOUR_BLEND | exacts dans le PE, pas seulement adaptés |
| Source et defines | exacts dans les descripteurs originaux |
| Macros à la frontière de soumission | vérifiées par le contrat isolé existant |
| Compilation physique de ces deux variantes | **ouverte** ; le contrat existant renvoyait un handle factice |
| Chemin de création/liaison D3D9 | exact statiquement |
| Handles publiés et interfaces COM de l’exécution historique | **non observés** |
| `SetVertexShader/SetPixelShader` avec ces objets | **non observés** |
| Draw, pixels et fidélité de frame | **non observés** |

## Prochain lot clôturable

`V1152 targeted FOUR_BLEND compiled-object publication` doit appeler uniquement `0x98D960` et `0x98C070` avec les lignes `0x123F678` et `0x123F550` :

Critères de succès :

1. les sources et tableaux de macros exacts atteignent la vraie frontière compilateur ;
2. les deux producteurs réussissent et publient un `record+4` non nul ;
3. chaque handle résout un objet backend non nul et, sur D3D9, un `wrapper+0x10` non nul ;
4. le probe libère uniquement ses propres objets et ne laisse aucune allocation vivante.

Refus à conserver : prérequis compilateur/device absent, échec compilation, handle nul ou backend différent. Aucun de ces cas ne doit devenir une réussite inventée.

**Condition d’arrêt stricte :** arrêter après capture de l’identité publiée et nettoyage. Ne pas appeler `0x9C22E0`, `0x9BEF40`, `DrawIndexedPrimitive`, `Present` ni faire de readback de frame dans ce lot. La liaison réelle sera un lot ultérieur seulement après publication réussie.

## Vérifications exécutées

- `python -m py_compile inspect_shader_identity.py` : succès ;
- `python inspect_shader_identity.py` : `15/15` contrôles vrais ;
- `python -m py_compile validate_shader_identity.py` : succès ;
- `python validate_shader_identity.py` : `16/16` contrôles vrais.

Le validateur recalcule toutes les empreintes d’entrée, les fenêtres PE, les chaînes et descripteurs natifs, la vtable backend, la chaîne d’objets, les slots D3D9, la borne V1150 et la décision bornée.

## Livrables

- `shader_identity_static.json` — 465 298 octets, SHA-256 `e900434c11142f7106c21836cff18e6b00a1eeaf688cdc272e80e598d4c2749d` ;
- `shader_identity_static_validation.json` — 1 904 octets, SHA-256 `55905ae4c61b6e02be4fb7f346a07affccab3134f01740e3ef89d9efbc0eae8c` ;
- `inspect_shader_identity.py` — 23 564 octets, SHA-256 `c72870e33c3861fe32e6ec497c5b8136a502479b1c8511faebf81221f449371c` ;
- `validate_shader_identity.py` — 6 886 octets, SHA-256 `81bda90d7b1bdbe7107dd2a121aec6b1ba8cba4d69a5cca5fbfbcb4d53d0b38e`.

Le rapport lui-même est volontairement exclu des empreintes ci-dessus pour éviter une référence circulaire.
