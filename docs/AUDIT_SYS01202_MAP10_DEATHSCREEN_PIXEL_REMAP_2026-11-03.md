# V1162 — remapping pixel death-screen de Map10

## Verdict

- Logique de remapping de `0x95A570` : **PROVEN_STATIC** sur le PE 4.20 épinglé.
- Valeur juste après construction du wrapper : **INACTIVE_PROVEN_INITIAL_ONLY** (`0x960A51` écrit `0` dans l’octet `+0x0C`).
- Valeur au démarrage effectif de Map10 : **UNKNOWN_AT_STARTUP**.
- Valeur au draw terrain Map10 : **UNKNOWN_AT_DRAW**.
- L’absence observable d’un écran de mort n’a pas été utilisée comme preuve.

Ce lot ne permet donc pas de promouvoir le bind FOUR_BLEND historique en bind inconditionnel. Il précise exactement quand le handle `record+4` ordinaire est conservé et quand un autre index pixel peut être substitué.

## Référence et méthode

Le travail est une inspection statique bornée du binaire :

`D:\LeagueOfLegendsV2\4.20\Client\League of Legends_UNPACKED\League-of-Legends-4-20\RADS\solutions\lol_game_client_sln\releases\0.0.1.68\deploy\League of Legends.exe`

SHA-256 : `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

Sont aussi épinglés en lecture seule : le contrat de sélection environnement, le run et le rapport V1161, ainsi que sa revue indépendante. Le contrat de sélection indiquait explicitement que son adaptation de `0x95A570` excluait le remapping death-screen ; le présent lot traite uniquement cet écart.

Méthode : désassemblage des fenêtres ciblées, inventaire des 54 occurrences/références absolues alignées de `0x02D78F48`, scan rel32 des callers directs de `0x95A570`, de `0x5BDBA0` et de `0x96DE00`, puis inventaire des stores directs de l’octet du flag. Aucun jeu, device D3D, draw, REA, réseau ou écriture sous `F:` n’a été exécuté.

## Flag et producteurs directs

Le flag consommé par le bind pixel terrain est exactement :

`byte ptr [dword ptr 0x02D78F48 + 0x0C]`.

Preuve locale :

- `0x95A574` charge le wrapper depuis `[0x02D78F48]` ;
- `0x95A579` compare `byte ptr [eax+0x0C]` à zéro ;
- `0x95A57D` va directement à la reprise de l’index original si le flag vaut zéro.

Inventaire strict des stores directs trouvés dans le PE :

| Adresse | Valeur | Rôle borné |
|---|---:|---|
| `0x960A51` | 0 | valeur initiale du constructeur |
| `0x63D99B` | 0 | store runtime direct |
| `0x63E56C` | 1 | store runtime direct |
| `0x63E5C8` | 1 | store runtime direct |
| `0x63EFFB` | 0 | store runtime direct |
| `0x63FFA9` | 1 | store runtime direct |
| `0x63FFC6` | 0 | store runtime direct |

Les six stores runtime appellent ou rejoignent `0x968900` après changement. Le lot reste volontairement borné : il ne reconstruit pas tout le lifecycle des fonctions englobantes. Aucun ordre admissible de ces stores n’est épinglé pour un démarrage ou un draw terrain Map10. Le zéro du constructeur n’est donc pas propagé artificiellement jusqu’au draw.

## Algorithme exact de `0x95A574..0x95A59C`

Entrée : l’index pixel original est l’argument `[ebp+8]`.

1. Si le flag `wrapper+0x0C` vaut zéro, `0x95A59E` recharge immédiatement l’index original.
2. Si le flag est non nul, `0x95A584` adresse le conteneur `this+0x74` et `0x95A58D` appelle le lower-bound `0x5BDBA0` avec la clé égale à l’index original.
3. `0x95A592..0x95A596` compare le résultat au sentinel du conteneur.
4. En cas d’échec de recherche, `0x95A59E` conserve l’index original.
5. En cas de hit, `0x95A599` charge l’index substitué depuis le champ `node+0x14`.
6. `0x95A5A7` stocke l’index sélectionné dans `manager+0x102D4`.
7. Pour un index valide, `0x95A5B2..0x95A5B5` calcule `index*0x80` et charge le handle à `manager+0x2D8+index*0x80`, soit le champ `record+4` du record pixel choisi.

Le remapping est donc actif uniquement si le flag est non nul **et** si la clé a un hit. Un flag non nul sans hit conserve encore le record ordinaire.

## Producteur de l’index substitué

Le seul caller rel32 direct de l’helper d’insertion `0x96DE00` est `0x95A17D` :

- `0x95A17A` adresse le conteneur `this+0x74` ;
- avec `S` égal au `esp` de `0x95A150`, `0x95A157` écrit la clé à `S+0x40` ;
- après le premier `push`, `0x95A167` écrit l’index pixel courant/créé `ECX` dans le mot adjacent `S+0x44` ;
- `0x95A163/0x95A16B` passe l’adresse de cette paire à `0x96DE00` ;
- `0x96DE4A` lit `pair[0]` et le compare à `node+0x10` ;
- `0x5E0A0B..0x5E0A15` copie `pair[0]` dans `node+0x10` et `pair[1]` dans `node+0x14`.

L’index substitué consommé à `0x95A599` est donc le deuxième dword de la paire construite par le registre pixel, pas un index inventé par l’audit.

## Condition précise de conservation de FOUR_BLEND ordinaire

V1161 a relié le lookup `Environment_LIT_FOUR_BLEND_PS` au caller terrain `0x95A8A8 → 0x95A570`. Sur cette route, le handle `record+4` ordinaire est conservé si :

- le flag `[0x02D78F48]+0x0C` vaut zéro ; **ou**
- le flag est non nul mais le conteneur `this+0x74` ne contient pas la clé égale à l’index FOUR_BLEND original.

Il est substitué si le flag est non nul et que la clé a un hit ; le record chargé est alors celui de l’index stocké dans `node+0x14`.

## Vérifications

- Deux runs statiques indépendants : `deathscreen_remap_run1.json` et `deathscreen_remap_run2.json`.
- Digest stable commun : `33a95387290824dd82d116686d3a67c002153955fc209976efc595aee310111b`.
- Validation non mutante : **29/29**.
- 54 occurrences brutes, 54 références alignées, zéro occurrence non alignée.
- Cinq callers rel32 directs de `0x95A570`, dont la route FOUR_BLEND à `0x95A8A8`.
- Un seul caller rel32 direct de `0x96DE00` : `0x95A17D`.
- Sept stores directs recensés, dont le constructeur et six stores runtime.

## Limite et condition de reprise

La classification finale demeure **UNKNOWN_AT_DRAW**. La reprise exige l’une des deux preuves suivantes :

1. un snapshot admissible du client original 4.20, sur Map10, de `[0x02D78F48]+0x0C` au démarrage pertinent et immédiatement avant/pendant `0x95A8A8 → 0x95A570` ; ou
2. une preuve exhaustive de l’ordre de tous les stores post-constructeur atteignant cet octet avant ce draw.

Sans cette entrée, déclarer « remapping inactif » à partir du seul zéro constructeur ou de l’absence d’écran de mort serait une extrapolation refusée.

## Limites d’autorisation

Aucune modification produit, Goal, Plan, UI, base de données ou registre. Aucun jeu original lancé, aucune API D3D appelée, aucune qualification pixel/visuelle et aucune acceptation humaine. Ce lot clôt l’audit statique borné du remap ; il ne clôt pas SYS-01.2-02 ni le jeu.
