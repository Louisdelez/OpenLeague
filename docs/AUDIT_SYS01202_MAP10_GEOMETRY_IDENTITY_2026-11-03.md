# V1151 — identité historique de la géométrie consommée par `0x95AFC0`

## Verdict borné

Unité : `AUD-SYS-01.2-02-MAP10-V1151-GEOMETRY-IDENTITY-01`.

L’audit statique est terminé pour la question précise suivante : quels producteurs et quelles identités sources alimentent la déclaration de sommets selector 0, le vertex buffer et l’index buffer consommés par `0x95AFC0` ?

Les trois chaînes sont identifiées :

- selector 0 : `0x9596D0` construit la déclaration et fait écrire son wrapper à `terrain context+0x04` par le slot backend `+0x54` ; la cible D3D9 est `0x9C2880` ;
- vertex buffers : `0x958420 → 0x957840` lit les 107 payloads du `room.nvr` exact, crée/remplit leurs wrappers et les insère dans `resource table+0x28/+0x2C` ;
- index buffers : `0x958420 → 0x957940` lit les 107 couples taille/format et payloads, crée/remplit leurs wrappers et les insère dans `resource table+0x34/+0x38`.

`0x95AFC0` sélectionne ensuite ces handles depuis `context+0x04`, `table+0x28` et `table+0x34`, puis les lie par les slots `+0x58/+0x3C/+0x50`.

Ce verdict clôt l’identité statique de cette unité, pas une fonctionnalité de rendu. Aucun objet D3D9/COM, draw, Present ou pixel n’a été créé ou exécuté ici. SYS-01.2-02 et le jeu complet restent ouverts.

## Sources épinglées et preuves réutilisées

Référence originale :

- exécutable 4.20.0.315 : 15 973 880 octets, SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862` ;
- `LEVELS/Map10/scene/room.nvr` : 60 132 968 octets, SHA-256 `89e873ec32356312b53628c9773c803b0e6e864a206ac2aafc6a584c8ae27082` ;
- en-tête NVR : magic `0x52564E`, version `0x10009`, 87 matériaux, 107 VB, 107 IB, 2 351 meshes et 1 365 nodes.

Les validations V1150 ont été relues, non rejouées :

- caller statique : `passed=true`, SHA-256 `ad08b1c7e2ce946e4dc7a0d027b27c24b82896d0f230387100470c9f3e9498db` ;
- frontière runtime : `passed=true`, SHA-256 `060ee57e52188db9fba51414b9ef4dedc1a1442be0d67262e21b50d3b5d8f178` ;
- matrice de réutilisation : `passed=true`, SHA-256 `3fc8a4d7e223a786077a11e58f6ee2bbfd09fb3c3230a1c269252e75b0807a2a`.

Aucun résultat de modèle n’est utilisé comme autorité. Le présent résultat vient des octets de l’exécutable et du NVR épinglés.

## Séparation des deux objets historiques

La preuve distingue deux objets que les notes précédentes pouvaient rapprocher :

- `[0x2D78C2C]` est la table de ressources NVR, construite à `0x575CE3..0x575CFE` puis chargée par l’unique call direct `0x575D03 → 0x958420` ;
- `[0x2D78F48]` est un wrapper de 16 octets construit par `0x9609E0`. Son champ `+0x00` pointe vers le contexte terrain de 128 octets construit par `0x9595D0`, puis configuré par `0x9608D0 → 0x9596D0`.

La déclaration selector 0 appartient au second objet (`context+0x04`). Les vecteurs VB/IB appartiennent au premier (`resource table+0x28/+0x34`).

## Déclaration selector 0

### Producteur

`0x9595D0` initialise les sept champs de déclarations `context+0x04..+0x1C` à zéro. L’unique call direct vers la configuration `0x9596D0` est `0x96097C`. Dans `0x9596D0` :

1. `0x959743..0x959789` construit le descripteur selector 0 sur la pile ;
2. `0x95974F` place `context+0x04` comme pointeur de sortie ;
3. `0x959790` appelle le slot backend `+0x54` ;
4. la vtable D3D9 `0x10E2F30` résout ce slot vers `0x9C2880` ;
5. `0x9C2880` traduit les enums, ajoute `D3DDECL_END`, appelle la frontière de création `0x9C5B20` à `0x9C2A68`, puis construit le wrapper par `0x9C9B70`.

### Identité exacte

Descripteur abstrait source, cinq records de huit octets dont le terminateur :

```text
stream  offset  type       method  usage     index
0       0       FLOAT3     0       POSITION  0
0       12      FLOAT3     0       NORMAL    0
0       24      FLOAT2     0       TEXCOORD  0
0       32      D3DCOLOR   0       COLOR     0
255     0       type 8     0       end       0
```

Octets source :

```text
000000000200000000000c000200030000001800010004000000200004000600ff00000008000000
```

SHA-256 : `d0351bf771b8af94dd6db313e1b2159c7b517ed436442bb91dd607421e58e7e3`.

Après les tables de traduction de `0x9C2880`, TEXCOORD passe de l’enum source 4 à D3D usage 5, COLOR de 6 à D3D usage 10, et le terminateur devient le type D3D 17 :

```text
000000000200000000000c000200030000001800010005000000200004000a00ff00000011000000
```

SHA-256 : `fef33badc93c3d45b4c66794c9319424c78c43d11d7b6967a990b5a68834d624`.

Le stride selector 0 vaut 36 octets à `0x10D9D00[0]`.

### Consommateur

`0x95B05D` charge `[context + batch.selector*4 + 0x04]`. `0x95B063` l’envoie au slot `+0x58`, résolu vers `0x9C2BB0 → 0x9C5F60 → SetVertexDeclaration`.

## Vertex buffers

### Producteur et identité

Dans `0x958420`, `0x9585A1` prend le compteur NVR, `0x9585A4` passe `resource table+0x28`, puis `0x9585A7` appelle l’unique loader direct `0x957840`.

Pour chaque entrée, `0x957840` :

1. lit un `u32 byte_size` par le stream `+0x24` ;
2. appelle le factory backend `+0x38` à `0x9578A6` ; la cible de la vtable D3D9 est `0x9C2570` ;
3. verrouille le wrapper par son slot `+0x10` ;
4. lit exactement `byte_size` octets depuis le NVR dans la mémoire verrouillée ;
5. déverrouille, insère le wrapper dans le vecteur `+0x28/+0x2C`, puis relâche les références temporaires.

Le manifeste livre pour chacune des 107 entrées : index, offset fichier du payload, taille et SHA-256. Total : 48 428 528 octets de payload. SHA-256 canonique du manifeste : `ee08084d8116d6a61b38dc2bdd24dcf3d05f7a8872f1453c37d7d2379c935dc2`.

L’entrée historique index 0 est : offset `259988`, taille `170320`, SHA-256 `c99a0a5f89bd5891137522beb17618719b87a39e1f3c68a72074b32d967720ae`.

### Consommateur

`batch+0x04` fournit l’index. `0x95B077..0x95B082` vérifie la range `table+0x28/+0x2C`; `0x95B09F` charge le wrapper. `0x95B0A4` appelle le slot `+0x3C`, soit `0x9C2C40 → 0x9C5D30 → SetStreamSource`, stream 0, offset 0 et stride choisi dans `0x10D9D00`.

## Index buffers

### Producteur et identité

Dans `0x958420`, `0x9585B5` prend le compteur NVR, `0x9585B8` passe `resource table+0x34`, puis `0x9585BE` appelle l’unique loader direct `0x957940`.

Pour chaque entrée, `0x957940` :

1. lit `u32 byte_size` et `u32 format` ;
2. traduit `0x65 → 0x0B` (16 bits), `0x66 → 0x0C` (32 bits), autre valeur → 0 ;
3. appelle le factory backend `+0x4C` à `0x9579D4` ; la cible D3D9 est `0x9C26E0` ;
4. verrouille, lit le payload exact, déverrouille et insère le wrapper dans `+0x34/+0x38`.

Les 107 entrées Map10 ont toutes le format source `0x65`, donc le chemin 16 bits. Total : 11 153 472 octets de payload. SHA-256 canonique du manifeste : `60846c056e6c5786f2364318f8d6becd9719aeac247df1a6a2dff8ef4779e852`.

L’entrée historique index 0 est : offset `48688948`, taille `18486`, format `0x65`, SHA-256 `d5eaecc301d9bef5086441d4790ac6647b36cfdf27af90771a76c04abebcfe29`.

### Consommateur

`batch+0x08` fournit l’index. `0x95B0B8..0x95B0C3` vérifie `table+0x34/+0x38`; `0x95B0CD` charge le wrapper. `0x95B0D2` appelle le slot `+0x50`, soit `0x9C2B50 → 0x9C5E50 → SetIndices`.

## Lien aux records mesh

Pour la version NVR `0x10009`, `0x958200` lit directement 2 351 records de 100 octets dans `resource table+0x40`. À `record+0x30`, les sept `u32` sont : matériau, index VB, premier sommet, nombre de sommets, index IB, premier index, nombre d’indices.

Les 2 351 records analysés utilisent les indices VB et IB `0..91`, tous dans les ranges de 107 entrées, et chaque record utilise le même numéro VB/IB. Les entrées `92..106` sont néanmoins créées par les loaders. Elles ne sont pas déclarées « inutilisées globalement » : cette unité ne connaît que les références de la table mesh inspectée.

## Résultat attendu et observé

| Point | Attendu | Observé |
|---|---|---|
| selector 0 | producteur, octets, sortie, bind | `0x9596D0`, deux descripteurs exacts, `context+0x04`, `+0x58` |
| VB | origine stable et production | 107 payloads NVR identifiés, `0x957840`, `table+0x28`, `+0x3C` |
| IB | origine stable, format et production | 107 payloads NVR identifiés, tous `0x65`, `0x957940`, `table+0x34`, `+0x50` |
| runtime GPU | ne pas l’inventer | non exécuté ; adresses wrapper/COM process-locales |

## Cas nominal, refus et limites

Cas nominal statique : magic/version exacts, 107/107 entrées parsées, tous les payloads bornés, toutes les références mesh dans les ranges et descriptor selector 0 cohérent avec le stride 36.

Frontières d’échec conservées :

- `0x95855C/0x95856C/0x958574` dirigent un magic/version NVR non supporté vers l’échec `0x958614` ;
- `0x957884` et `0x9578FE` propagent les échecs de lecture du flux VB ;
- `0x957999` et `0x957A69` propagent les échecs de lecture du flux IB ;
- `0x95B080` et `0x95B0C1` conservent les sorties hors limites VB/IB qualifiées par V1150.

Limites :

- V1150 a lié les fixtures explicites déclaration `0x41930000`, VB `0x41930100` et IB `0x41930200`. Le présent audit n’en fait pas rétroactivement des ressources historiques ;
- le batch V1150 utilise les indices 0/0 mais ses handles restaient fournis par le harness. Les manifests décrivent ce que les entrées 0 historiques contiennent lorsque `0x958420` charge le NVR original, pas ce que V1150 a réellement lié ;
- les wrappers/handles numériques n’ont pas d’identité stable entre processus ; l’identité stable retenue est `(source NVR, index, offset, taille, SHA-256)` et, pour la déclaration, ses octets et son producteur ;
- la publication du backend D3D9 vivant dans `renderer+0x14`, la queue complète des batches de 40 octets, les objets shader, le draw, Present et les pixels restent hors périmètre ;
- aucun consommateur Rust actuel ni état d’implémentation produit n’est évalué par cette unité.

## Stop condition et runtime minimal éventuel

Stop : ne pas étendre cette unité vers la queue complète, les shaders, `DrawIndexedPrimitive`, Present, les pixels, l’intégration produit ou une déclaration de jeu terminé. La question statique des trois identités est fermée.

Aucun runtime supplémentaire n’est nécessaire à ce verdict. Si une preuve de continuité dans un même run est demandée plus tard, le plus petit lot est :

1. exécuter `0x9596D0` avec un factory d’enregistrement `+0x54` ;
2. exécuter `0x958420` avec le flux readonly du `room.nvr` exact et des factories d’enregistrement `+0x38/+0x4C` ;
3. dériver un batch d’un record mesh natif et entrer dans `0x95AFC0` ;
4. vérifier que les mêmes wrappers reviennent à `+0x58/+0x3C/+0x50` ;
5. arrêter encore à `0x95B112`, zéro accès invalide, aucun draw/Present/pixel.

Ce runtime prouverait une continuité du code original, mais les factories resteraient des adaptateurs. La création COM réelle exige séparément le raccord backend/device.

## Contrôles réellement exécutés

```text
python -m py_compile inspect_geometry_identity.py
python inspect_geometry_identity.py
python -m py_compile validate_geometry_identity.py
python validate_geometry_identity.py
```

Résultat indépendant : `passed=true`, 38/38 contrôles. Il reparse l’exécutable et le NVR, reconstruit les 214 entrées des deux manifests de buffers, les 2 351 références mesh, puis contrôle les descripteurs, les strides, six slices binaires, la vtable, les xrefs, les preuves V1150 et les limites de portée.

## Livrables

- `inspect_geometry_identity.py` — `e44dc8067ee757849075638a0c4c141ab07ee2800a38294d1c686454d01f8db5` ;
- `geometry_identity_inspection.json` — `a988df4c4f91f43b27148ddb3a2cb465e71d676028e7647a9029ce65e4286755` ;
- `geometry_identity_result.json` — `da48d147a5c977830d47470fa3201c04a84089232fb9b94387e8f79f0e0c6eb2` ;
- `validate_geometry_identity.py` — `84c6bafcf32bb05fc7537703fc7b3d636ec4222395a460b41a7b64bbe868d26b` ;
- `geometry_identity_validation.json` — `2cdfc7b2ccb766f53b0d92730df6c6b7f13c503eaac4f7b01f1c74d21c7d8308`.

Aucun fichier `F:` ou `D:`, Goal, Plan, interface, base, registre ou produit n’a été modifié. Aucun logiciel n’a été installé.
