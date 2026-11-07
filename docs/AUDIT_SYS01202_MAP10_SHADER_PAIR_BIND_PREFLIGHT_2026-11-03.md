# V1157 — Préflight statique paire shader, résolution et bind D3D9

Date : 2026-11-03  
Périmètre : étape **après producteurs** et arrêt strict avant draw  
Mode : lecture statique seulement, E-only pour les livrables

## Verdict

- préflight statique : **READY** ;
- exécution de `0x9AEE30 → 0x9C22E0 → 0x9BEF40` : **BLOCKED** ;
- draw, Present et readback : **interdits et non exécutés** ;
- aucun producteur, setter, factory de paire, resolver ou bind n’a été appelé.

Le contrat binaire est suffisamment fermé pour préparer l’étape suivante. Il
n’est pas encore suffisamment réversible pour l’entrer dans le renderer hôte.
Les quatre écarts bloquants sont : rollback cache/pool, atomicité des deux binds,
co-résidence sur le même device et confinement des échecs de factory.

## Sources réutilisées

- PE 4.20 : SHA-256
  `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`,
  x86, image base `0x400000` ;
- V1151 identité shader et première chaîne paire/bind ;
- V1154 pools, device bridge et cleanup des records VS/PS ;
- V1155 composition du cycle de vie ;
- V1156 préflight producteurs ;
- snapshot REA existant. Aucun import, réanalyse ou logiciel supplémentaire.

V1151 épinglait seulement le préfixe du hash de paire jusqu’à `0x9AF1A0`.
V1157 ferme la fonction complète `0x9AF140..0x9AF1E4`, retour inclus.

## ABI de la paire `0x9AEE30`

Entrée fastcall-like :

| Registre | Contrat |
|---|---|
| `ECX` | handle de record vertex, non nul |
| `EDX` | handle de record pixel, non nul |
| `EAX` retour | record de paire ou null |

La factory refuse un handle nul. Elle appelle l’allocateur `0x8E28C0` sur le
manager `[0x2D79694]` et refuse la sentinelle `0x10000`. Le pool contient
65 536 records de 16 octets à partir de `[0x2D79568]`.

| Offset record | Valeur |
|---|---|
| `+0x00` | pointeur de paire backend |
| `+0x04` | refcount, initialisé à 1 |
| `+0x08` | handle vertex |
| `+0x0C` | handle pixel |

La factory incrémente les deux refcounts stage avant de construire la paire
backend. Sous D3D9 (`[0x2D79470]==0`, `[0x2D7951C]!=0`), elle appelle
`0x9BEE80`, puis enregistre les métadonnées via `[0x2D77B28]`.

## Indices et hash

`0x9AF140` calcule :

- vertex : `((handle - [0x2D79574]) >> 3) & 0xFFFF` ;
- pixel : `((handle - [0x2D791D0]) >> 3) & 0xFFFF` ;
- null devient `0xFFFF` ;
- les deux valeurs 16 bits sont entrelacées dans une clé 32 bits.

Le futur gate doit donc vérifier famille, base, alignement 8, index inférieur à
`0x1000`, wrapper non nul et refcount positif avant toute mutation.

## Paire backend D3D9 `0x9BEE80`

`ECX` reçoit le wrapper vertex et `EDX` le wrapper pixel. L’objet retourné
contient les wrappers empruntés en `+0/+4` et deux pointeurs dans un bloc de
métadonnées possédé en `+8/+0xC`. Sa taille est :

`4*(VS[+0xC]+PS[+0xC]) + 8*(VS[+0x8]+PS[+0x8]+2)`.

Les constructeurs internes sont `0x9BED80` et `0x9BEDD0`. Limite importante :
le résultat de l’allocation est déréférencé sans test null. Un OOM n’est donc
pas contenu par la fonction originale.

## Résolution `0x9C22E0`

Entrée : `ECX=backend`.

- handle vertex désiré : `backend+0xAC` (`0x9C30C0`) ;
- handle pixel désiré : `backend+0xA8` (`0x9C3110`) ;
- cache local : `backend+0x36C`, 1 024 buckets de 12 octets ;
- bucket : `hash & 0x3FF` ;
- entrée : `{hash, pair_record*}` ;
- paire courante globale : `[0x2D79520]`.

Sur miss, le resolver appelle `0x9AEE30`, insère son résultat via `0x64F030`
**sans test null**, puis lie `pair[0]` via `0x9BEF40` si la paire diffère de la
paire courante. Enfin, il écrit le record résolu, même null, dans
`[0x2D79520]`.

Le cleanup du cache est identifié : slot vtable backend `+0x9C` à
`0x10E2FCC → 0x9C3160 → 0x9C9EE0 → 0x9AEFE0`.

## Bind D3D9 `0x9BEF40`

`ECX` reçoit l’objet de paire backend. Null est un no-op. Le device est
`[0x2D79428]`.

1. `[[pair+0]+0x10]` est passé à la vtable `+0x170`, index 92,
   `IDirect3DDevice9::SetVertexShader` ;
2. `[[pair+4]+0x10]` est passé à la vtable `+0x1AC`, index 107,
   `IDirect3DDevice9::SetPixelShader`.

Il n’existe ni branche HRESULT ni rollback entre ces appels. Le vertex peut
donc être modifié alors que le pixel échoue. Les callsites n’exploitent pas
`EAX` comme statut agrégé fiable.

## Null, saturation et erreurs

| Cas | Effet observé | Règle future |
|---|---|---|
| deux handles désirés null | retour immédiat, aucun unbind | ne pas l’utiliser comme unbind |
| un seul handle null | factory null, cache null possible, binder no-op, current devient null alors que les anciens shaders restent liés | refus avant setters |
| pool pair saturé | sentinelle `0x10000`, même poison null du cache | prouver un slot libre et sérialiser |
| allocation backend null | déréférencement sans garde | confinement par processus jetable |
| paire passée au binder null | no-op, ne nettoie pas le device | jamais considérer comme succès |
| un Set échoue | les deux Set sont tentés, aucun rollback | getters, vérification et restauration externes |

## Ownership et cleanup

`0x9AEFE0` décrémente le refcount de paire. À zéro, il libère le bloc backend,
met `pair[0]=0`, appelle `0x9AED50` pour le vertex et tail-jump vers `0x9AEDC0`
pour le pixel.

Cette release **ne rappelle jamais `0x8E2980` pour le slot de paire**. Le slot
du bitmap pair reste consommé jusqu’au teardown global/processus, même après
libération de son contenu. Une insertion de paire dans le backend vivant n’est
donc pas entièrement réversible par la seule release.

Ordre de cleanup requis : restaurer les deux shaders D3D et les vérifier,
restaurer les desired/current tant que les records sont vivants, retirer ou
teardown le propriétaire cache, puis seulement libérer les owners producteurs
VS/PS et les références COM acquises par les getters.

## État minimal pour un futur run

- processus hôte x86 **jetable**, PE épinglé, renderer quiescé ;
- branche D3D9 exacte : flags `0` / non-zéro ;
- device `[0x2D79428]`, managers/bases stage et pair, registre métadonnées
  `[0x2D77B28]` valides ;
- backend valide, cache `+0x36C` isolé ;
- deux handles non nuls, bonne famille/alignment/range, wrappers, shaders bruts
  et métadonnées valides ;
- preuve que les deux shaders proviennent du device exact `[0x2D79428]` ;
- un slot pair libre, capacité d’allocation backend ;
- snapshot desired, current, bucket cible, bitmap/refcounts et shaders device.

## Ordre sûr proposé — non exécuté

1. Démarrer uniquement un processus hôte jetable et geler la concurrence.
2. Valider tous les gates ; au premier échec, sortir sans mutation.
3. Capturer desired/current, bucket, pool/refcounts et
   `GetVertexShader/GetPixelShader`.
4. Sans flush concurrent, renseigner les deux desired, puis appeler
   `0x9C22E0` une seule fois. Ne jamais exposer un couple partiellement null.
5. Vérifier immédiatement cache/current, layout/refcounts et identité des deux
   shaders par getters.
6. **S’arrêter avant draw, Present et readback.**
7. Restaurer les deux shaders et les états hôte ; libérer cache/pair avant les
   handles producteurs.
8. Faire le teardown normal du processus jetable afin de récupérer le slot
   pair monotone, puis comparer les snapshots finaux.

## Gaps bloquants

1. `LIVE_PAIR_CACHE_AND_MONOTONIC_POOL_ROLLBACK_NOT_CLOSED` : insertion sur miss
   et slot pair non libérable individuellement.
2. `D3D9_TWO_STAGE_BIND_ATOMICITY_NOT_CLOSED` : deux Set sans contrôle HRESULT
   ni rollback.
3. `PAIR_DEVICE_CORESIDENCY_NOT_COMPOSED` : aucune composition contrôlée ne
   prouve encore producteurs et `[0x2D79428]` dans le même processus/device.
4. `PAIR_FACTORY_FAILURE_CONTAINMENT_NOT_CLOSED` : null de pool cachable et
   allocation backend non gardée.

## Preuves et contrôles

Fenêtres principales :

| Fenêtre | SHA-256 |
|---|---|
| `0x9AEE30..0x9AEFE0` pair factory | `8628a49035770f6bc44f0f8dfe85979fb337515cd3f4573823f075d39a7982f4` |
| `0x9AEFE0..0x9AF04B` pair release | `1b2b8cb13d9c1b9b98445d5e738f28da6a53deb37bc1e33981480695fa74642f` |
| `0x9AF140..0x9AF1E4` hash complet | `13fded2913683dc535305e29d2510c9fccb236583adc19540a58db6f0371e7c4` |
| `0x9BEE80..0x9BEF32` backend pair | `f59dea0e41e3d099355b811e0e250ebcb747f97bedb81ed49e28d49c05f459ef` |
| `0x9BEF40..0x9BEF74` bind | `f6b38deb08c879b497be81bad3cc345ba24624bef206bc0453a1e0936a526067` |
| `0x9C22E0..0x9C239B` resolver | `d86cec8ce20fc0b18b8535f9a134fd45d00376be697ae23471938d83d52f8583` |

Contrôles réellement exécutés : générateur statique puis validateur indépendant
avec écriture explicite du reçu. Le reçu valide le PE, 12 fenêtres, les octets
sentinelles, le pointeur vtable, les pins réutilisés, l’absence d’API
d’exécution dans le générateur et les quatre gaps. Résultat : **PASS**.

Ce lot ne prouve aucune exécution native, aucun rendu et aucune complétude de
jeu. Il ferme uniquement le préflight statique déclaré.
