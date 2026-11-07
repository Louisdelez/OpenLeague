# Revue indépendante V1153 v2 — VFS / streams / includes shader Map10

## Décision

**PASS — QA-OBS-01 est corrigée et reproduite comme résolue.**

Le lot v2 ferme `vfs_stream_and_recursive_include_provider` pour l’adapter/harness local en lecture seule, borné aux neuf fichiers et SHA-256 épinglés. La revue v1 et toutes les anciennes preuves harness v1 sont supersédées ; elles ne doivent plus être utilisées comme preuves courantes.

- Manifeste source v2 : `13/13` tailles et SHA-256 exacts.
- Deux reçus v2 postérieurs au producteur final : exact.
- Deux réexécutions isolées : `PASS`.
- Projection recalculée indépendamment : `ed42955c77294c596b3358d46b072c949f3239de2a9deb0b4eaa3c67851e1922` dans les deux runs.
- Validateur harness réexécuté en isolation : `41/41`.
- Validateur ABI statique réexécuté en isolation : tous les contrôles vrais.
- Cycle synthétique `A → B → A` reproduit directement : `include_cycle`, deux streams fermés une fois, deux buffers libérés une fois, zéro objet vivant.
- Aucun finding bloquant ou résiduel nouveau dans le périmètre qualifié.

Cette décision ne qualifie pas le VFS historique Riot, n’exécute aucune fonction native et ne publie aucun shader.

## Identité courante revue

| Élément v2 | Octets | SHA-256 |
|---|---:|---|
| manifeste source | 4 019 | `18f811838b6af8fcc5997e3b764da6c5ed1ef285596ff4c84e9d45d9b17eb795` |
| producteur harness | 36 530 | `e3e2e7517f9cc5dcb75b43f98c1d468082e20125a3359abca8601c075ec0403a` |
| validateur harness | 16 501 | `1bc00947d62233ce5552876ce87a1ac11f44072a8370c6ccaf6521a2233cb79f` |
| run 1 | 39 179 | `d17dcfa8b2b65101dc0189cfb24381d01e017297a69a6d5eb358b6b6d4a12b6f` |
| run 2 | 39 179 | `53d022d6a4850f0e891092f253a4777ee73aa20c1668835811508176895b48c4` |
| validation harness | 4 664 | `c2462930ce54834c035d716951ec1f9ffb30fa39229bd64e52d86f3eea676f60` |
| rapport source | 9 658 | `a9797eb238fc1bbd84d94910f70ccf72a62ae8b6237d1a0c26adf01578dd29af` |
| preuve ABI statique | 182 644 | `bca87e0034099fbff385b8f97ad032088445d2adf65a957d2e94ede17a87a7bf` |
| validation ABI statique | 4 490 | `7e2df0bce77940f4702886f6b716c6f9b1e4576a90430ba3a9c87c7728823c63` |

Le producteur final date de `2026-11-03T10:03:04.7799100Z`; les reçus v2 datent respectivement de `10:03:18.4405255Z` et `10:03:18.7675375Z`. Les deux reçus ont donc été générés après la dernière édition observée.

## Reproduction indépendante de QA-OBS-01

La revue a importé le producteur v2 sans exécuter son `main`, construit deux sources embarquées et épinglées :

```text
Cycle/A.hls -> #include "B.hls"
Cycle/B.hls -> #include "A.hls"
```

Résultat observé :

| Contrôle | Attendu | Observé |
|---|---:|---:|
| refus | `include_cycle` | `include_cycle` |
| streams ouverts | 2 | 2 |
| streams fermés une fois | 2 | 2 |
| streams vivants | 0 | 0 |
| buffers chargés | 2 | 2 |
| buffers libérés une fois | 2 | 2 |
| buffers vivants | 0 | 0 |

Chaque stream présente la séquence `tell, seek, tell, seek, seek, read, close`. La correction `finally: free(buffer_id)` couvre donc bien la remontée exceptionnelle de la récursion. QA-OBS-01 est fermée.

## Contrôles indépendants

Les scripts et entrées ont été copiés dans un répertoire temporaire, puis les validateurs et deux nouveaux runs ont été exécutés sans réécrire le lot source.

- validation immédiate des reçus sources : `41/41` ;
- deux nouveaux runs isolés : `passed=true`, même décision et même projection ;
- validation des nouveaux runs : `41/41` ;
- validation ABI statique : `pass=true`, douze familles de contrôles vraies ;
- six scripts parsés par `ast` : syntaxe valide ;
- projections des deux reçus sources reconstruites depuis leur contenu et rehashées : exactes ;
- les runs isolés diffèrent des runs sources uniquement par le chemin attendu du fichier volontairement absent dans le détail du refus `missing_file` ;
- PE source : SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`, PE32 x86, image base `0x400000` ;
- neuf sources allowlistées, deux mains, sept arêtes include, sept buffers nominaux et neuf streams nominaux : identités et ownership exacts ;
- dix refus, cycle inclus : distincts et conformes ;
- manifeste source revérifié après les essais : toujours `13/13`, zéro écart.

## Frontière et limites

La frontière reste structurelle : le producteur Python n’importe aucun moteur d’émulation, FFI ou lanceur de processus. Il ne possède aucune capacité producteur, D3DX, device, shader, pool, bind, draw, `Present` ou readback. Les compteurs zéro ne constituent pas une trace du runtime Riot.

Quatre blockers du préflight V1152 restent ouverts :

1. bridge buffers / constant table D3DX ;
2. bridge device `CreateVertexShader` / `CreatePixelShader` ;
3. allocation et libération des pools shader ;
4. cleanup possédé des records et objets backend.

Aucune complétude shader, terrain, Map10 ou jeu n’est déclarée. Cette revue n’a modifié ni le lot source, ni `F:\OpenLeague`, ni le Goal, le Plan, l’interface, les bases, les registres ou les assets.

