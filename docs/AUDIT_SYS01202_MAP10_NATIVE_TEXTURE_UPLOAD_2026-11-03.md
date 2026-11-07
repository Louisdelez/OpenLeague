# SYS-01.2-02 — V1147 — upload natif conditionnel des textures terrain Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-TEXTURE-UPLOAD-01`  
Parent : `SYS-01.2-02` / `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`  
Verdict de l'unité : **audit terminé pour l'upload conditionnel et la publication propriétaire jusqu'à `0x98962A`**  
Verdict fonctionnel : **rendu, `Present`, chemin nominal historique et retour complet du loader non terminés**  
Acceptation humaine : **non demandée**

## 1. Objectif et frontière

V1146 avait créé les trois textures terrain Map10 par la chaîne originale `0x9C2D40 → 0x9C6070 → IDirect3DDevice9::CreateTexture`, mais s'arrêtait à la frontière pré-upload `0x9BB4EC`. V1147 traite seulement le maillon suivant :

1. exécuter les branches originales post-création pour les trois DDS identifiés ;
2. transférer leurs payloads de niveau 0 vers les textures D3D9 actuelles ;
3. relire indépendamment les octets et comparer leurs SHA-256 ;
4. observer les stores originaux vers `texture+0x90`, puis `texture+0x8C` ;
5. s'arrêter après publication, avant l'`AddRef` et l'enregistrement appelant non qualifiés.

La frontière finale est `0x98962A`. L'instruction suivante et le contexte d'enregistrement post-publication ne sont pas exécutés. Sont exclus : retour complet du loader, enregistrement dans les conteneurs appelants, sampler/draw, `Present`, pixels de frame, comparaison visuelle, réponse pilote privée nominale, runtime 2014, teardown natif complet, correction produit, assets, registres, goal, Plan, application de suivi et bases.

## 2. Sources, identités et réutilisation

### Binaire et textures

- Exécutable 4.20 : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe` ; 15 973 880 octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

| DDS sous `LEVELS/Map10` | Fichier complet | Payload après en-tête DDS de 128 octets |
|---|---|---|
| `terrainHeightScale.dds` | 16 777 344 octets ; `b84ec5b7a58fec4bb2951a23a1c16ca474f955c88e65591fb99d3d5b5bab4e6b` | 16 777 216 octets ; `6d98a9a8aacd4bee2ce1077ea1367bb9c3a7862fc86b1e3316d9a70041d6d199` |
| `compositeColorMap.dds` | 4 194 432 octets ; `e7955c18b97cefd85e0e85fd89cd758a0d6457cc0c4ca1c0d1bcb0e35e6fc507` | 4 194 304 octets ; `98cb9477fe84418dafea41a206db7e927c7341d486ccf310a0476bfbc36ab0a8` |
| `fogLightingMap.dds` | 4 194 432 octets ; `ef57969ac3c4a5576563eb0789e429439e58a56ec86e4a37877281a5a995f7fa` | 4 194 304 octets ; `a540fd476743a80ca0bfc69f5905ea389835d9de6b0801d78d80feb16a1bb35a` |

### Preuves réutilisées sans replay large

- V1143 : I/O readonly, SHA des trois DDS et requêtes CPU jusqu'à `0x9BB247`.
- V1145 : backend D3D9 conditionnel publié dans `renderer+0x14`, requête privée pilote interceptée.
- V1146 : trois `CreateTexture`, wrappers à vtable `0x10E3270` dans `request+0x38`, frontière `0x9BB4EC`.
- V717 : adaptateurs COM à généraliser ; son seul pixel blanc 1×1 ne qualifiait pas Map10.

Le reçu `reuse_upload_evidence_and_guards.json`, SHA-256 `856ed43cfc731e84b4bd4ede6b525f799fa998392b6072da3b69965be2de66eb`, recense 18 sources, trois DDS et douze garde-fous. Il interdit notamment de confondre upload de texture, rendu et fidélité 2014.

### Runtime actuel

Les appels sont liés au runtime de la machine actuelle, notamment `C:/WINDOWS/SYSTEM32/d3d9.DLL` (SHA-256 `9c2343d50ab0e219d6526be5c419b2c5dc62e88c30444c936927001e3bdc89e6`). `D3DXGetImageInfoFromFileInMemory` reste adapté à partir des mots V1143 après contrôle des SHA. `D3DXLoadSurfaceFromMemory` n'est pas appelé dans le chemin des trois DDS. La preuve est conditionnelle au profil `escape_refusal`, pas historique.

## 3. Contrat ABI indépendant

L'analyse des octets originaux établit que les trois DDS sont `A8R8G8B8` (`D3DFORMAT 21`), classe de format 3, catégorie 0 et un mip normalisé. Cette combinaison sélectionne :

1. `0x9BB53D → 0x9BB110` ; wrapper `+0x24=0x9C9550` ; slot COM `IDirect3DTexture9::LockRect` à `vtable+0x4C` ;
2. `0x9BB54F → 0x9B6C10` ; copie CPU du payload, par `memcpy` si `Pitch == rowBytes`, sinon ligne par ligne via `0x9B6770` ;
3. `0x9BB557 → 0x9BB190` ; wrapper `+0x28=0x9C9610` ; slot `UnlockRect` à `vtable+0x50` ;
4. `0x9BB76B` publie le wrapper vers l'argument propriétaire `texture+0x90` ;
5. `0x98961F/0x989624` le copie vers `texture+0x8C`.

La branche alternative `0x9BB600` atteint `0x9B7BB0`, dont l'appel `0x9B8732` cible l'IAT `D3DXLoadSurfaceFromMemory` à `0xFA47FC`. Elle n'est pas sélectionnée pour ces trois sources.

Limite ABI essentielle : la publication propriétaire n'est pas un contrôle d'`HRESULT` de transfert. Les wrappers natifs traitent leur résultat en interne/TLS et la boucle ne le teste pas avant les stores. La preuve runtime doit donc vérifier séparément `pBits` non nul, `Pitch >= rowBytes`, succès d'`UnlockRect` et readback SHA tenant compte du pitch. Le reçu ABI ne revendique aucun upload runtime.

Contrôles ABI réellement exécutés : deux exécutions identiques, assertions internes, `py_compile` et parsing JSON. Résultat : `passed=true`, trois sources. Script SHA-256 `23fd44fc0fa1ad9cf1620d92117229bc1ef97dd66cde2845cbf3c677a0f1cdde` ; reçu SHA-256 `8450c894b635907acac267e68c3d6fcc6ca8308ed79ff4c2008a31129f99e849`.

## 4. Exécution conditionnelle et résultat observé

Commande principale :

```powershell
python -B E:\mapslol3v3\audit_map10_native_texture_upload_20261103\probe_native_texture_upload.py
```

Attendu : trois créations issues de V1146, trois transferts directs `LockRect → copie CPU → UnlockRect`, trois readbacks égaux aux payloads physiques, stores `0x9BB76B` et `0x989624`, puis arrêt à `0x98962A` sans draw ni `Present`.

Observé : conforme.

| Source | Texture et pitch | Readback | Publication propriétaire |
|---|---|---|---|
| `terrainHeightScale.dds` | 2048×2048, pitch 8192, wrapper `0x409D64F0` | 16 777 216 octets, SHA identique `6d98a9a8…d199` | `+0x90=+0x8C=0x409D64F0` |
| `compositeColorMap.dds` | 1024×1024, pitch 4096, wrapper `0x409D6560` | 4 194 304 octets, SHA identique `98cb9477…b0a8` | `+0x90=+0x8C=0x409D6560` |
| `fogLightingMap.dds` | 1024×1024, pitch 4096, wrapper `0x409D65D0` | 4 194 304 octets, SHA identique `a540fd47…b35a` | `+0x90=+0x8C=0x409D65D0` |

Le reçu porte `passed=true`, `audit_complete_for_declared_conditional_upload_boundary=true`, `pixel_upload_complete=true`, `owner_texture_fields_published=true`, `owner_texture_field_publication_complete=true`, `historical_nominal_path_complete=false` et `render_complete=false`.

Compteurs qualifiés : trois `CreateTexture`, six appels `LockRect/UnlockRect`, trois readbacks, zéro `D3DXLoadSurfaceFromMemory`, zéro appel de rendu, 4 809 adresses originales et zéro accès mémoire invalide. L'appel privé pilote n'est pas transmis.

Le nettoyage hôte est complet : textures/objets COM possédés, adaptateur, bibliothèques et fenêtre cachée sont libérés. `native_full_teardown=false` reste exact : le teardown original du renderer n'est pas exécuté et les allocations de l'arène invitée restent recensées à la frontière.

## 5. Refus, échecs conservés et validation indépendante

### Refus borné

Une copie mutée de `terrainHeightScale.dds` produit le SHA `1fb6b4858d9b506195f73170b72b3c945eadf5d275e05fa67e85fca32c30e5aa` au lieu du SHA attendu. Le contrôle refuse avant upload. Il s'agit d'un garde du harness, pas d'un refus natif/Riot.

### Échecs conservés

- `initial_failure_shadow_cursor_collision.json` conserve une collision de la zone shadow du premier adaptateur de lock ; la correction alloue une plage distincte et ne modifie pas les octets originaux.
- `initial_failure_post_publication_registration_context.json` conserve la poursuite non qualifiée après publication ; elle atteint un contexte appelant incomplet. La correction borne le lot à `0x98962A` et laisse l'`AddRef`/enregistrement ouvert.

### Relecture indépendante

Une relecture PowerShell séparée vérifie : trois noms et géométries, SHA des payloads/readbacks, égalité `+0x90/+0x8C`, ordre des stores, frontière `0x98962A`, compteurs COM, zéro rendu/mémoire invalide, refus muté, nettoyage hôte et drapeaux de portée. Résultat : `INDEPENDENT_V1147_RECEIPT_VALIDATION=PASS`.

## 6. Résolu et ouvert

### Résolu par V1147

1. Le chemin original choisi par les trois DDS est `LockRect → copie CPU → UnlockRect`, pas D3DX.
2. Les trois payloads physiques de niveau 0 sont effectivement copiés dans trois textures D3D9 actuelles.
3. Les trois readbacks ligne par ligne correspondent exactement aux SHA des payloads.
4. Chaque wrapper est publié par `0x9BB76B` dans `texture+0x90`, puis par `0x989624` dans `texture+0x8C`.
5. La frontière post-publication `0x98962A` est atteinte sans accès mémoire invalide, draw ni `Present`.

L'audit est donc terminé pour l'upload conditionnel et la publication propriétaire jusqu'à cette frontière.

### Toujours ouvert

1. **Retour du loader** : l'`AddRef` et l'enregistrement post-publication, puis le retour complet au caller, ne sont pas exécutés.
2. **Chemin nominal historique** : réponse privée `0x48AC16`, D3D9/D3DX/pilote/OS de 2014 et provider RADS historique non qualifiés.
3. **Cycle de vie natif** : teardown renderer original et libération de l'arène invitée incomplets.
4. **Consommation graphique** : liaison effective de ces handles aux slots terrain, états sampler complets, shaders, géométrie, draw et `Present`.
5. **Pixels et fidélité** : aucun pixel de frame, capture raster ou comparaison visuelle 4.20.

Un upload exact dans des textures actuelles ne termine ni la texture terrain rendue, ni la carte, ni le parent `SYS-01.2-02`.

## 7. Conditions de reprise

Ne pas rejouer V1143–V1147 si le PE, les trois DDS, les adresses, le runtime hôte et les reçus n'ont pas changé. Reprendre uniquement avec une nouvelle entrée concrète :

1. petit lot `0x98962A` jusqu'au retour complet du loader, avec contexte d'`AddRef`/enregistrement authentifié et preuve de cycle de vie ;
2. lot distinct sur la consommation des trois handles : `SetTexture`, slots exacts, paramètres MAG/MIN/MIP, adresse U/V, LOD bias/max mip et shaders ;
3. lot raster borné : draw identifié, `Present`, readback de pixels et comparaison au même état caméra/maillage ;
4. nominal historique seulement si une réponse sûre et attribuable existe pour `0x48AC16` ; ne jamais transmettre une requête privée inconnue au pilote ;
5. teardown natif dans un lot séparé, sans le confondre avec le nettoyage du bridge hôte.

`SYS-02.4-03`, `SYS-02.4-04` et le parent restent ouverts. Aucun correctif produit n'est autorisé ni appliqué par ce lot.

## 8. Livrables et décision

Preuves isolées : `E:/mapslol3v3/audit_map10_native_texture_upload_20261103/`.

- `perimetre.md` — SHA-256 `279c56f075cccfb423a07aff81406463e59d304faaa86ac5c9e392cb7bb2f7ca` ;
- `probe_native_texture_upload.py` — `bf020e36e2072f5e5baa44c139d9a174f644ca48dbb15fcf0dede9b71b36736b` ;
- `native_texture_upload_execution.json` — `4ae5b0a5a2047c2278d6e1470cd6ec4282768aa5c4805053c9e593d66c119c3d` ;
- `native_texture_upload_native_bytes.json` — `4cf58ee65dad504768a90b7fe6eb487da92b01a41a8c827de7d9a141d7f0921a` ;
- `inspect_native_texture_upload_abi.py` — `23fd44fc0fa1ad9cf1620d92117229bc1ef97dd66cde2845cbf3c677a0f1cdde` ;
- `native_texture_upload_abi.json` — `8450c894b635907acac267e68c3d6fcc6ca8308ed79ff4c2008a31129f99e849` ;
- `reuse_upload_evidence_and_guards.json` — `856ed43cfc731e84b4bd4ede6b525f799fa998392b6072da3b69965be2de66eb` ;
- `REUSE_UPLOAD_EVIDENCE_AND_GUARDS.md` — `c2edb18035f0ad2b1b82001afeee6ea1c1239982140083838aad5cc9faa079e5` ;
- `initial_failure_shadow_cursor_collision.json` — `d41b0befaf877fc93bfb1e5b748681d3cdaa27e2a964796fa1f716358a6f748a` ;
- `initial_failure_post_publication_registration_context.json` — `6a75352232771a52cb67a2c2fcb841da871ac0cfeb59f0d5a3a31898790b3f6b` ;
- ce rapport.

Décision : **V1147 est terminé pour l'upload conditionnel des trois textures Map10 et leur publication propriétaire jusqu'à `0x98962A`. Le retour complet du loader, le nominal 2014, le teardown natif, le draw, `Present`, les pixels de frame, la fidélité visuelle et le parent restent incomplets.**

Seuls ce rapport et les deux documents de reprise `docs/ai` seront ajoutés sur F:. Aucun source produit, asset, registre, goal, Plan, interface, application de suivi ou base de données n'est modifié.
