# SYS-01.2-02 — V1146 — création backend des textures terrain Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-BACKEND-TEXTURE-CREATE-01`  
Parent : `SYS-01.2-02` / `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`  
Verdict de l'unité : **audit terminé pour la création conditionnelle jusqu'à la frontière pré-upload `0x9BB4EC`**  
Verdict fonctionnel : **upload, publication dans `texture+0x90/+0x8C`, chemin nominal historique et rendu non terminés**  
Acceptation humaine : **non demandée**

## 1. Exigence et correction de frontière

V1143 produit les trois requêtes terrain exactes et s'arrête avant l'appel backend à `0x9BB247`. V1145 publie conditionnellement un backend D3D9 à vtable `0x10E2F30`. V1146 traite uniquement le maillon suivant : exécuter, pour ces trois requêtes Map10, la méthode originale `+0x60=0x9C2D40`, son wrapper `0x9C6070` et l'appel `IDirect3DDevice9::CreateTexture` actuel, sans exécuter le transfert des pixels.

Le périmètre initial demandait aussi d'observer le résultat dans `texture+0x90/+0x8C`. L'analyse ABI a démontré que cette demande est incompatible avec l'exclusion stricte de l'upload :

- après la création, le wrapper existe d'abord seulement dans `request+0x38` ;
- la première branche post-création commence à `0x9BB53D → 0x9BB110` ;
- `0x9BB54F → 0x9B6C10` puis `0x9BB557 → 0x9BB190` participent au transfert/libération ;
- `0x9BB76B` ne publie le wrapper vers l'argument `texture+0x90` qu'après ces branches ;
- `0x98961F/0x989624` copie ensuite `texture+0x90` vers `texture+0x8C`.

V1146 applique donc le second critère de sortie du périmètre : il qualifie la création à la feuille exacte `0x9BB4EC`, documente pourquoi les champs propriétaire restent ouverts et ne saute aucun contrôle original pour les remplir artificiellement.

Sont exclus : `LockRect`, `D3DXLoadSurfaceFromMemory`, upload des octets DDS, sampler, draw, `Present`, readback, pixels, réponse pilote nominale 2014, correction produit, client/assets, registres, goal, Plan, application de suivi et bases.

## 2. Sources, identités et preuves réutilisées

### Source native et DDS

- Exécutable 4.20 : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe` ; 15 973 880 octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

| DDS sous `LEVELS/Map10` | Taille | SHA-256 |
|---|---:|---|
| `terrainHeightScale.dds` | 16 777 344 | `b84ec5b7a58fec4bb2951a23a1c16ca474f955c88e65591fb99d3d5b5bab4e6b` |
| `compositeColorMap.dds` | 4 194 432 | `e7955c18b97cefd85e0e85fd89cd758a0d6457cc0c4ca1c0d1bcb0e35e6fc507` |
| `fogLightingMap.dds` | 4 194 432 | `ef57969ac3c4a5576563eb0789e429439e58a56ec86e4a37877281a5a995f7fa` |

Les identités servent à lier les métadonnées V1143 à chaque requête. Les octets de pixels ne sont pas transmis à la texture dans V1146.

### Preuves réutilisées sans replay large

- V690 : wrappers `0x9C2D40 → 0x9C6070` et frontière COM, sans corpus terrain.
- V717 : contrat de création de textures avec les API actuelles et upload séparé du seul pixel blanc diagnostique ; il ne qualifie pas les trois DDS Map10.
- V1143 : trois requêtes exactes, dimensions, mip, usage, format et pool.
- V1145 : backend conditionnel publié dans `renderer+0x14`, appel privé pilote intercepté.

Le reçu `reuse_evidence_and_guards.json`, SHA-256 `5fe68ee2e69fc2b45d4f1c7dcb1b4b3fc51636cdb542d4a30a83a962ea7dfc93`, recense douze sources et dix garde-fous. Il confirme qu'aucune preuve antérieure ne créait les trois textures terrain par ce backend ni ne permettait de confondre création et upload.

### Runtime hôte actuel

Les appels COM sont exécutés contre les modules actuels, pas contre un environnement 2014 :

- `C:/WINDOWS/SYSTEM32/d3d9.DLL`, SHA-256 `9c2343d50ab0e219d6526be5c419b2c5dc62e88c30444c936927001e3bdc89e6` ;
- `C:/WINDOWS/System32/USER32.dll`, SHA-256 `f285937030bcb325cad39ee5be4818f6666241229adeadea4ff1ae469dfd7ef3` ;
- `C:/WINDOWS/System32/KERNEL32.DLL`, SHA-256 `e132eba4166256e2f414b91fe7d5386590bc5ea8626aee5af9c9738383cf2ae1` ;
- `C:/WINDOWS/System32/GDI32.dll`, SHA-256 `772c73e294a4c5f5e0d4146288af95287a85c074d3aee3fa9f320dc010d7dbfe`.

Le pont x86 invité vers COM/Win32 64 bits reste un adaptateur V716/V1145. La création actuelle ne prouve ni le pilote ni le comportement de 2014.

## 3. Chaîne originale exécutée et contrat observé

### Requête et conversion backend

À `0x9BB220`, la requête expose : largeur `+0x08`, hauteur `+0x0C`, mip `+0x10`, usage abstrait `+0x14`, index format `+0x18`, index pool `+0x1C`, backend `+0x20`, sélecteur `+0x24` et sortie `+0x38`. Le sélecteur zéro mène au slot `backend.vtable+0x60`, soit `0x9C2D40`.

`0x9C2D40` convertit les valeurs abstraites puis appelle `0x9C6070`. Ce dernier appelle le slot COM `IDirect3DDevice9+0x5C` avec : device, largeur, hauteur, mip, usage, `D3DFORMAT`, `D3DPOOL`, pointeur de sortie et shared handle nul. Cet appel ne possède aucun argument de pixels.

Sur succès, le code original alloue un wrapper de 20 octets : vtable `0x10E3270`, refcount `1`, texture COM à `+0x08`. `0x9C2E8A` écrit ce wrapper via le pointeur de sortie de la requête.

### Trois créations terrain

| Requête | Arguments COM utiles | Résultat COM | Wrapper dans `request+0x38` |
|---|---|---|---|
| `terrainHeightScale.dds` | 2048×2048, mip 1, usage 0, format index 2 → `D3DFORMAT 21`, pool index 1 → `D3DPOOL 1` | `HRESULT 0`, proxy `0x404004A0` | `0x409D64F0`, vtable `0x10E3270`, ref 1 |
| `compositeColorMap.dds` | 1024×1024, mip 1, usage 0, format 21, pool 1 | `HRESULT 0`, proxy `0x404004C0` | `0x409D6560`, même vtable/ref |
| `fogLightingMap.dds` | 1024×1024, mip 1, usage 0, format 21, pool 1 | `HRESULT 0`, proxy `0x404004E0` | `0x409D65D0`, même vtable/ref |

Les treize ancres originales requises sont observées : `0x989500`, `0x989603`, `0x9BB3D0`, `0x9BB412`, `0x9B65E0`, `0x9BB4DF`, `0x9BB2D0`, `0x9BB4E7`, `0x9BB220`, `0x9BB247`, `0x9C2D40`, `0x9C6070` et `0x9BB4EC`. Le parcours totalise 4 412 adresses d'instructions originales.

À la frontière `0x9BB4EC`, les trois wrappers sont non nuls dans `request+0x38`, tandis que `texture+0x90` et `texture+0x8C` valent toujours zéro. C'est le comportement attendu avant upload, pas un échec de `CreateTexture`.

## 4. Contrôles exécutés, attendu et observé

### Exécution isolée

Commande exécutée :

```powershell
python -B E:\mapslol3v3\audit_map10_native_backend_texture_create_20261103\probe_native_backend_texture_create.py
```

Attendu : les trois requêtes V1143 utilisent le backend V1145, passent par `0x9C2D40/0x9C6070`, obtiennent chacune un wrapper natif dans `request+0x38`, puis s'arrêtent à `0x9BB4EC` avant tout transfert de pixels.

Observé : conforme. Le reçu porte `passed=true`, `audit_complete_for_declared_conditional_creation_boundary=true`, `backend_texture_creation_conditionally_observed=true`, `owner_texture_fields_published=false`, `historical_nominal_path_complete=false`, `pixel_upload_complete=false`, `render_complete=false` et `driver_private_escape_executed=false`.

Trois appels nominaux `CreateTexture` réussissent. Le compteur de transfert de pixels vaut zéro, comme les compteurs de rendu ; aucune mémoire invalide n'est observée. L'appel privé à `0x48AC16` n'est jamais transmis.

### Refus borné

Un contrôle négatif appelle directement le COM hôte actuel avec une largeur nulle. Il observe `HRESULT 0x8876086C` et une sortie nulle. Ce contrôle est **un comportement COM de la machine actuelle** : ce n'est ni un refus du wrapper original, ni un contrat Riot, ni une preuve historique 2014.

L'analyse ABI documente aussi le refus d'allocation du wrapper après succès COM : le code original libère alors la texture COM et publie une sortie nulle. Cette branche est une condition de reprise possible, mais elle n'est pas déclarée exécutée dans le reçu final.

### Nettoyage, échec conservé et validation indépendante

Le nettoyage hôte est réussi : textures créées, device et autres objets COM possédés, adaptateur, bibliothèques et fenêtre cachée sont libérés/détruits. `native_full_teardown=false` reste exact : le teardown natif complet du renderer n'est pas exécuté et 36 allocations de l'arène invitée restent recensées au point d'arrêt.

Le premier essai est conservé dans `initial_failure_unqualified_texture_lockrect.json`. Il avait correctement créé la première texture, puis poursuivi au-delà du périmètre et s'était arrêté sur `IDirect3DTexture9::LockRect` non qualifié. La correction ne fournit pas cet appel : elle applique la frontière ABI `0x9BB4EC`, avant `LockRect`, et conserve explicitement l'upload ouvert.

Une relecture PowerShell indépendante vérifie les trois noms/SHA, dimensions, mip, format/pool, trois succès COM, wrappers/vtables/refcounts, champs propriétaire nuls, zéro appel `LockRect`/D3DX, refus largeur zéro et verdicts de portée. Résultat : `INDEPENDENT_V1146_RECEIPT_VALIDATION=PASS`.

## 5. Résolu et ouvert

### Résolu par V1146

1. Les trois requêtes terrain exactes atteignent le backend conditionnel publié par V1145.
2. Les wrappers originaux `0x9C2D40 → 0x9C6070` s'exécutent pour chacune.
3. Les conversions dimensions/mip/usage/format/pool sont observées et concordent avec V1143.
4. Trois appels COM actuels `CreateTexture` réussissent avec des sorties distinctes.
5. Trois wrappers natifs à vtable `0x10E3270`, refcount `1`, sont publiés dans `request+0x38`.
6. La frontière pré-upload `0x9BB4EC` est observée sans mémoire invalide, upload ni rendu.

L'audit est donc terminé pour la création conditionnelle jusqu'à cette frontière.

### Toujours ouvert

1. **Publication propriétaire** : `texture+0x90/+0x8C` restent nuls ; leurs stores originaux sont postérieurs à l'upload exclu.
2. **Pixels** : aucun `LockRect`, `D3DXLoadSurfaceFromMemory` ou octet DDS n'est transféré.
3. **Chemin nominal historique** : le profil reste conditionnel et utilise les API actuelles ; la réponse pilote 2014 à `0x48AC16` n'est pas qualifiée.
4. **Cycle de vie natif** : teardown original incomplet et 36 allocations de l'arène encore recensées.
5. **Rendu** : aucun sampler, draw, `Present`, readback, pixel ni comparaison visuelle.

La création de ressources vides ne termine ni la texture terrain, ni la fidélité graphique, ni le parent `SYS-01.2-02`.

## 6. Conditions de reprise

Les clauses `SYS-02.4-03` et `SYS-02.4-04` restent ouvertes. Aucun correctif produit n'est appliqué.

Reprendre seulement avec une entrée dépassant la frontière actuelle :

1. exécuter le premier maillon post-création `0x9BB53D → 0x9BB110` avec une texture Map10 identifiée et qualifier son contrat de surface/lock ;
2. qualifier séparément `0x9BB54F → 0x9B6C10` puis `0x9BB557 → 0x9BB190`, avec les vrais octets et SHA du DDS, sans appeler une API inconnue par défaut ;
3. observer ensuite seulement `0x9BB76B` publier le wrapper dans `texture+0x90`, puis `0x98961F/0x989624` le copier dans `texture+0x8C` ;
4. ajouter un contrôle de refus natif du wrapper seulement si nécessaire, sans promouvoir le refus COM largeur zéro en contrat historique ;
5. traiter le nominal `0x48AC16`, le teardown et le draw/readback comme trois lots distincts.

Ne pas répéter V690/V717, V1143/V1145, les trois `CreateTexture` ou les mêmes hashes si le PE, les DDS, le runtime hôte et les reçus n'ont pas changé.

## 7. Livrables et décision

Preuves isolées : `E:/mapslol3v3/audit_map10_native_backend_texture_create_20261103/`.

- `perimetre.md` — SHA-256 `2ca6ce6c6585c9c537c9c6fb3e72a6c1e0711e94805fe27deae6935182f20569` ;
- `probe_native_backend_texture_create.py` — `1ce9885e7296b26c633558575afb1f73fd590c3b0ae962cd0a2dc624e0ba5209` ;
- `native_backend_texture_create_execution.json` — `66f6b895d80afdf75b6b945600043fc61395cf8f4f452628edddf81fe32862cd` ;
- `native_backend_texture_create_native_bytes.json` — `578083b82e255eca262a62feeccfb3abe0ed9aa3b969d00dc752adeff9855fbe` ;
- `initial_failure_unqualified_texture_lockrect.json` — `7b5db06d86145b496ebf8daff1240807e91a9bdc20e5ea593f4e90309fc18443` ;
- `inspect_backend_texture_create_abi.py` — `05bf4af71eff23ee2b8a0ad8c4831afc86a6fcb7359df3df635651ac8ca63b26` ;
- `native_backend_texture_create_abi.json` — `2b806176a43db18c5eb482280539ad0ef8b5792c9c614f41a4e2617d5dc795f3` ;
- `reuse_evidence_and_guards.json` — `5fe68ee2e69fc2b45d4f1c7dcb1b4b3fc51636cdb542d4a30a83a962ea7dfc93` ;
- `REUSE_EVIDENCE_AND_GUARDS.md` — `076df4616099d4b170e8c82c1114234793603bc19ed1cb9ba54cd210d1516c07` ;
- ce rapport.

Décision : **V1146 est terminé pour la création conditionnelle de trois textures terrain jusqu'à `0x9BB4EC`. L'upload, la publication `texture+0x90/+0x8C`, le chemin nominal historique, le teardown natif et le rendu restent incomplets.** Le parent, les corrections terrain et l'acceptation humaine restent ouverts.

Aucun fichier F:, client original, source produit, asset, registre, goal, Plan, application de suivi, base de données, logiciel ou migration n'a été modifié par ce lot.
