# V1153 — Harness VFS / streams / includes du shader terrain Map10

## Décision

**PASS v2 — le contrat `vfs_stream_and_recursive_include_provider` manquant au préflight V1152 est fermé pour un adapter/harness local borné.**

Cette décision qualifie exclusivement un provider lecture seule limité aux neuf fichiers et SHA-256 épinglés. Elle ne prouve ni ne reconstitue le VFS historique Riot, ne publie aucun shader et ne rend pas la fonctionnalité shader complète.

- Deux exécutions indépendantes : `PASS`.
- Projection déterministe commune : `ed42955c77294c596b3358d46b072c949f3239de2a9deb0b4eaa3c67851e1922`.
- Validation indépendante : `PASS`, 41 contrôles.
- Producteur final du reçu : `audit_shader_vfs_harness.py`, 36 530 octets, SHA-256 `e3e2e7517f9cc5dcb75b43f98c1d468082e20125a3359abca8601c075ec0403a`.

### Correction QA-OBS-01 et supersession

La revue indépendante a démontré qu’une exception pendant la récursion des includes pouvait laisser le buffer parent vivant. Le buffer chargé est maintenant libéré dans un `finally`, y compris lorsque la descente détecte un cycle. Un corpus synthétique borné `A → B → A` produit désormais `include_cycle` avec **zéro stream et zéro buffer vivant** dans les deux runs.

Les anciennes preuves v1 ne sont plus courantes et sont explicitement marquées `superseded_not_current` dans les reçus v2 :

- ancien harness : `ffa92a569d0120c8839ebf6a58e6b5d5368f73ddf05dfacdb770167d8272e284` ;
- anciens runs : `ef97a29bd70934c9df4079a808bb80d4884d467721bc0ab01670a5d3744b2984` et `866ae36e50cf2359da9f46fcb4e48bf932f6c43e25e62d8e9a169662a9208dc9` ;
- ancienne validation : `7ba2e35d3126512f380437980d2c12608ce6c76dba83385267d123e0d01962d8` ;
- ancien rapport : `da921064e0970b94047af90fbb7b13a315789c6d0700077e57f06bbf5440ee31` ;
- ancien manifeste : `40bccff8780948d44ed0b1a0c8457b27208ea9fff3b70183775a6b6bfe209748`.

## Source et ABI exactes

Source native : `League of Legends.exe` 4.20, PE32 x86, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

| Entrée / slot | Contrat fermé | Preuve |
|---|---|---|
| `0x8B4FB0` | `ECX=virtual_path`, `EDX=mode`; les callsites shader/include donnent le mode `rb`; appelle le slot provider `+0x00(path, mode)` et retourne le premier stream non nul | `[0x8B4FB0,0x8B5022)`, 114 octets, SHA-256 `29856979759228fbc70ee8a349ea01ac73c56286100a0d333980fe1a8c6849bc` |
| `0x98D4E0` | load include thiscall-like : `ECX=include_object`, arguments `path`, `outData`, `ret 8`, succès dans `AL` | `[0x98D4E0,0x98D71B)`, SHA-256 `cefe0f3137c0fe4d210d1a580f0ec201d796e128b38059e6a30e29e60a83d705` |
| `0x98D720` | free include : argument buffer, `ret 4`, succès dans `AL` | `[0x98D720,0x98D751)`, SHA-256 `8fc0f628f0c29d1d4bd0e29fffded0123e4516a5ea4df86256f10be83cee5435` |
| stream `+0x10` | `(include_callback_object, macro_ptr/null, macro_count)` | callsites pixel `0x98C2AA`, vertex `0x98DB9A` |
| stream `+0x14` | `tell()` | `0x98D5CB`, `0x98D5DF` |
| stream `+0x1C` | `seek(offset, origin)` avec origines 0 et 2 | `0x98D5D8`, `0x98D5EF`, `0x98D608` |
| stream `+0x24` | `read(buffer, size, count)` et retour en nombre d’items | `0x98D613` |
| stream `+0x00` | appel one-shot avec argument `1`; le nom close/release reste l’inférence minimale | callsites include et mains |

Le sous-dossier `static_abi` contient les onze fenêtres, désassemblages complets, vtable include, xrefs, constantes et leur validation indépendante.

## Adapter qualifié

Le provider du harness :

- est strictement lecture seule et refuse tout mode différent de `rb` ;
- ne peut ouvrir que les neuf chemins allowlistés, avec taille et SHA-256 exacts ;
- normalise `/`, `\`, `.`, `..` et la casse avant le lookup, tout en refusant une remontée au-dessus de la racine ;
- lit le fichier physique correspondant à l’entrée épinglée, jamais un chemin utilisateur concaténé librement ;
- expose seulement les méthodes nécessaires aux slots `+0x00`, `+0x10`, `+0x14`, `+0x1C` et `+0x24` ;
- suit explicitement l’ownership des streams et buffers pour interdire double-close et double-free.

Le modèle `+0x10` s’arrête après capture byte-identique de la source et parcours des callbacks d’include. Il ne fabrique aucun retour compilé.

## Cas nominaux observés

| Contrôle | Attendu | Observé |
|---|---|---|
| sources principales | VS `7 825` octets et PS `13 310` octets, SHA épinglés | identité exacte des deux payloads |
| arêtes include | cinq includes pixel et deux vertex | sept arêtes exactes, aucune arête transitive supplémentaire |
| payloads include | sept fichiers, tailles et SHA épinglés | sept identités byte-à-byte exactes |
| séquence de chaque include | `tell → seek(0,END) → tell → seek(original,SET) → seek(0,SET) → read(size,1)==1 → close(1)` | séquence exacte sur les sept streams |
| terminaison | buffer `taille+1`, dernier octet NUL | sept buffers exacts et NUL-terminés |
| ownership buffers | sept allocations, sept frees uniques, zéro vivant | `7 / 7 / 0` |
| ownership streams | deux mains + sept includes, neuf closes uniques, zéro vivant | `9 / 9 / 0` |
| normalisation positive | séparateurs Windows, segment `.`, casse, include relatif `..` restant dans la racine | quatre cas acceptés et résolus vers les chemins épinglés |

Les neuf fichiers effectivement délivrés sont `DeathScreen.hls`, les deux mains `Environment/LIT_{VS,PS}`, `Fog/Fog.hls`, les deux `FogOfWar`, `HeightBlending`, `MipLevels` et `ShadowMap/pcf1.hls`.

## Refus séparés

| Cas | Refus attendu | Refus observé | Cleanup |
|---|---|---|---|
| traversal hors racine | `traversal_escape` | exact | zéro stream/buffer vivant |
| chemin absolu / drive | `absolute_path` | exact | zéro vivant |
| chemin interne non allowlisté | `unlisted_path` | exact | zéro vivant |
| fichier allowlisté mais absent | `missing_file` | exact | zéro vivant |
| mode autre que `rb` | `non_read_mode` | exact | zéro vivant |
| second close du même stream | `double_close` | exact | zéro vivant |
| lecture après close | `stream_closed` | exact | zéro vivant |
| origine de seek non supportée | `invalid_seek_origin` | exact | close de reprise, zéro vivant |
| seconde libération du même buffer | `double_free` | exact | zéro vivant |
| cycle synthétique `A → B → A` | `include_cycle` | exact dans les deux runs | deux streams fermés, deux buffers libérés, zéro vivant |

Un fichier vide demeure hors du corpus épinglé. Le modèle `fread(size=0,count=1)` retourne zéro item, comme l’exige la limite déduite du natif ; il ne peut donc pas être promu silencieusement en succès.

## Borne d’exécution stricte

Les compteurs zéro ci-dessous sont **structurels**, issus de l’absence de ces capacités dans le harness Python ; ils ne sont pas présentés comme une trace du runtime Riot :

- entrées `0x98D960` et `0x98C070` : 0 ;
- `D3DXCompileShader` : 0 ;
- `CreateVertexShader` / `CreatePixelShader` : 0 ;
- device, pool, shader, bind, draw, `Present`, readback : 0 ;
- dispatcher guest natif : absent.

Le validateur parse également l’AST du producteur : aucun import de moteur d’émulation, FFI, subprocess ou appel dynamique n’est disponible.

## Contrôles réellement exécutés

```text
python -m py_compile audit_shader_vfs_harness.py validate_shader_vfs_harness.py
python audit_shader_vfs_harness.py --run-id 1 --output shader_vfs_harness_run1.json
python audit_shader_vfs_harness.py --run-id 2 --output shader_vfs_harness_run2.json
python validate_shader_vfs_harness.py
python build_artifact_manifest.py
```

Résultats finaux après la dernière modification du producteur :

- run 1 v2 : `passed=true`, SHA-256 `d17dcfa8b2b65101dc0189cfb24381d01e017297a69a6d5eb358b6b6d4a12b6f`, projection `ed42955c…1922` ;
- run 2 v2 : `passed=true`, SHA-256 `53d022d6a4850f0e891092f253a4777ee73aa20c1668835811508176895b48c4`, même projection ;
- validateur v2 : `passed=true`, 41/41, SHA-256 du reçu `c2462930ce54834c035d716951ec1f9ffb30fa39229bd64e52d86f3eea676f60` ;
- ABI statique : `pass=true`, tous les contrôles vrais.
- manifeste : 13 livrables, rehash PowerShell indépendant `13/13`, zéro écart.

## Livrables rehashables

- `audit_shader_vfs_harness.py` : producteur du harness ;
- `shader_vfs_harness_run1.json` et `shader_vfs_harness_run2.json` : deux exécutions ;
- `validate_shader_vfs_harness.py` : validateur indépendant ;
- `shader_vfs_harness_validation.json` : validation, pins des deux runs et du producteur final ;
- `artifact_manifest.json` : tailles et SHA-256 des livrables finaux du lot ;
- `static_abi/` : générateur, JSON, validateur et rapport ABI indépendants ;
- `inspect_vfs_disassembly.py` : inspection locale complémentaire.

## Limites et reprise

Ce lot ferme un seul des cinq blockers du préflight V1152. Restent ouverts :

1. bridge `D3DX` buffers / constant table ;
2. bridge device `CreateVertexShader` / `CreatePixelShader` ;
3. allocation et libération des pools shader ;
4. cleanup possédé des records et objets backend.

Condition de reprise : traiter ces contrats dans des lots séparés avec leur propre ownership et leurs stops stricts. L’entrée des producteurs reste interdite tant que les quatre contrats ne sont pas fermés ensemble. Aucune complétude shader, terrain, Map10 ou jeu n’est déclarée ici.

Écritures de ce lot : uniquement sous `E:\mapslol3v3\audit_map10_v1153_shader_vfs_20261103`. Aucun produit, Goal, Plan, interface, base, registre, asset ou fichier sous `F:` / `D:` n’a été modifié par le harness ; ces volumes ont été lus pour rehash seulement.
