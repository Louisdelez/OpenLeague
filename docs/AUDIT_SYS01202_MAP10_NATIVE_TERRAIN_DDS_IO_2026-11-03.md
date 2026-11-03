# SYS-01.2-02 — V1143 — I/O DDS et chaîne CPU native du terrain Map10

Date : 2026-11-03  
Unité : `AUD-SYS-01.2-02-MAP10-TERRAIN-NATIVE-DDS-IO-01`  
Parent : `SYS-01.2-02` / `OLF-3a11ace9-485c-55ae-8dff-2533902a5839`  
Verdict de l'unité : **audit terminé avec preuves jusqu'à la frontière virtuelle backend `+0x60`**  
Verdict fonctionnel : **provider RADS historique, backend D3D, upload GPU et rendu non terminés**  
Acceptation humaine : **non demandée**

## 1. Exigence et frontières

V1142 exécutait les loaders, la factory et l'initialiseur originaux des trois textures terrain, mais remplaçait le corps `0x98A030` par une feuille adaptée. V1143 traite uniquement le maillon suivant : exécuter, pour les trois DDS Map10 réels, le corps original `0x98A030 → 0x98A460`, les appels provider/stream, puis la chaîne CPU `0x989500 → 0x9BB3D0 → 0x9B65E0 → 0x9BB2D0 → 0x9BB220`, jusqu'à l'instruction de l'appel virtuel backend `+0x60` à `0x9BB247`.

Le lot distingue explicitement :

- les instructions du binaire 4.20 réellement exécutées ;
- les feuilles provider/stream readonly adaptées ;
- la mesure D3DX faite par la DLL x86 locale actuelle, puis injectée dans Unicorn par un adaptateur IAT déclaré ;
- la résolution du backend original `+0x60`, sans exécuter cet appel ;
- l'audit clos pour cette frontière, sans déclarer la fonctionnalité graphique terminée.

Sont exclus : sélection/priorité RADS historique, identité de `d3dx9_39.dll` en 2014, création effective d'un périphérique COM/D3D, création ou upload de texture GPU, draw, pixels, validation visuelle et modification du produit.

## 2. Sources, identités et preuves réutilisées

### Binaire et données terrain

- Exécutable 4.20 : `D:/LeagueOfLegendsV2/4.20/Client/League of Legends_UNPACKED/League-of-Legends-4-20/RADS/solutions/lol_game_client_sln/releases/0.0.1.68/deploy/League of Legends.exe` ; 15 973 880 octets ; SHA-256 `402bf2b9d5f09b8dd4f20b312c533a764712f2912cc3807a10fd721638d37862`.

| Fichier sous `LEVELS/Map10` | Taille | Métadonnées D3DX mesurées | SHA-256 |
|---|---:|---|---|
| `terrainHeightScale.dds` | 16 777 344 | 2048×2048, profondeur 1, mip 1, format 21, type 3, fichier 4 | `b84ec5b7a58fec4bb2951a23a1c16ca474f955c88e65591fb99d3d5b5bab4e6b` |
| `compositeColorMap.dds` | 4 194 432 | 1024×1024, profondeur 1, mip 1, format 21, type 3, fichier 4 | `e7955c18b97cefd85e0e85fd89cd758a0d6457cc0c4ca1c0d1bcb0e35e6fc507` |
| `fogLightingMap.dds` | 4 194 432 | 1024×1024, profondeur 1, mip 1, format 21, type 3, fichier 4 | `ef57969ac3c4a5576563eb0789e429439e58a56ec86e4a37877281a5a995f7fa` |

### Preuves existantes réutilisées

- V1142, script `probe_native_terrain_loaders.py`, SHA-256 `17f3ffbf90be398b28425b61085c67649e660c8e5721c08eb6c261c8c3186c59` ; reçu SHA-256 `93bb6a09f0d1953a5ee262dcbfae3a52fc9eace1d7441921fb09bc12aef6d003`. Il qualifie les loaders, les handles et l'entrée dans `0x98A030`, pas son corps.
- V689, script `revision689_native_texture_requests.py`, SHA-256 `4994e3312499c2836079f0cbd30b42a379e6538f9d021d8f6435d648183362bc`. Il qualifie la chaîne CPU DDS sur des portraits, sans provider/stream terrain.
- V689, helper x86 `d3dx_info_probe.exe`, SHA-256 `44c4d17da8c80bb265e384aed383a7e4f33a76c7ecd3385afe0c6693359e194c` ; source Rust SHA-256 `8c1aad8ec8bf184c3ab4bb36404f6a9c285e4dc2e29b90fdde58a36229e8370f`.
- `C:/Windows/SysWOW64/d3dx9_39.dll`, 3 851 784 octets, SHA-256 `5d29988cad858f754ecc62c3d30de555f82cc21b5b26c448b890295e9b7bee82`. C'est la DLL locale actuelle, pas une identité historique 2014 établie.
- V690 corrigé, `revision690_native_backend_requests_checked.py`, SHA-256 `70bd0940f210b6f67c6edbc05078c03faef7de3a71b440412a867c4e76ffffb4` ; reçu SHA-256 `c23d16eb59c656ef6d12f8cff1201b2287ecfc7d9f4372e872c79a7e4f856457`. Il relie la vtable `0x10E2F30`, son slot `+0x60=0x9C2D40` et la frontière COM `CreateTexture`, sans GPU réel.

Cette réutilisation évite de répéter V689/V690 sans piste nouvelle. V1143 apporte la composition terrain qui manquait : loader → I/O → données réelles → chaîne CPU → frontière backend.

## 3. Consommateur original exécuté et adaptateurs

### Route originale observée

Pour chacun des trois cas, le probe exécute l'entrée loader correspondante, puis les corps originaux suivants :

```text
0x959B10 / 0x959BC0 / 0x959C80
  → 0x98A030
  → 0x98A460
  → 0x989500
  → 0x9BB3D0
  → 0x9B65E0
  → 0x9BB2D0
  → 0x9BB220
  → 0x9BB247 : résolution de [vtable+0x60], sans appel
```

Le contrat I/O observé est identique dans les trois cas :

1. provider `+0x14(path,"rb")` ouvre le nom logique exact ;
2. stream `+0x08` renvoie la taille ;
3. stream `+0x1C(0,0)` se repositionne au début ;
4. stream `+0x24(buffer,size,1)` lit l'intégralité ;
5. stream `+0x00(1)` ferme le flux.

Les bytes copiés dans la mémoire invitée sont rehachés. Leur taille et leur SHA-256 sont identiques au fichier physique lié au nom exact.

### Frontière backend atteinte

La vtable déclarée `0x10E2F30` est utilisée. À `0x9BB247`, son slot `+0x60` résout `0x9C2D40`. L'appel est volontairement arrêté avant exécution.

| DDS | Instructions originales distinctes exécutées | Arguments de la requête à `+0x60` | Cible résolue | Appel exécuté |
|---|---:|---|---|---|
| height | 1 701 | 2048×2048, niveaux 1, usage 0, format index 2, pool index 1 | `0x9C2D40` | non |
| colormap | 1 701 | 1024×1024, niveaux 1, usage 0, format index 2, pool index 1 | `0x9C2D40` | non |
| fog lighting | 1 691 | 1024×1024, niveaux 1, usage 0, format index 2, pool index 1 | `0x9C2D40` | non |

Une inspection statique complémentaire borne le raccord encore manquant. `0x9895DF` charge le renderer global `[0x2D79078]`, `0x9895E5` prend son champ `+0x14`, `0x9BB4BD` le place dans la requête `+0x20`, puis `0x9BB247` utilise son slot virtuel `+0x60`. Le constructeur du renderer (`0x960740 → 0x9819E0`) initialise ce champ à zéro ; l'écriture historique qui y publie le backend n'est pas encore tracée. Le backend D3D9 concret construit à `0x9C1430` publie la vtable `0x10E2F30` et conserve son périphérique COM à `+0x14`. Sa création passe par `0x9C3E30`, référencé comme entrée virtuelle à `0x10E2E3C`, mais le raccord de cette factory vers `renderer+0x14` reste ouvert.

La sortie de création remonte dans `texture+0x90`, puis `0x98961F/0x989624` la copie dans `texture+0x8C`. Cela relie le résultat attendu de `+0x60` aux champs de handle de la texture, sans prouver la création COM ni le chargement des pixels.

### Adaptateurs séparés du code original

- Provider `+0x28/+0x1C` : accepte uniquement le nom logique actif exact ; aucune priorité ni durée de vie RADS historique n'est revendiquée.
- Provider `+0x14` : accepte uniquement le mode `rb`, lie le nom exact au fichier Map10 exact et vérifie taille/SHA avant de rendre un flux readonly.
- Stream `+0x08/+0x1C/+0x24/+0x00` : implémente le contrat exact taille/seek/read/close et vérifie le SHA des octets invités.
- IAT `0xFA47F8` : l'outil V689 appelle réellement la DLL x86 locale avant l'émulation, mais l'appel au sein d'Unicorn reste un adaptateur qui revalide taille/SHA et injecte les sept mots mesurés avec `HRESULT=0`.
- Backend `+0xF0` : son target original `0x9C3A40` est remplacé par un enregistrement de capacités nul de `0x30` octets ; aucune capacité historique n'est revendiquée.
- Profil V689 « sans catégorie » explicite : `[0x2D79050]+0x0C = 0`. La composition de catégorie optionnelle de `0x98A030` n'est donc pas qualifiée.
- Allocation/libération CRT, `strrchr`, `strcmp`, `strstr`, `memcpy` et feuilles de cookie de sécurité : frontières host déterministes héritées des probes antérieurs.

## 4. Contrôles exécutés, attendu et observé

### Exécution isolée

Commande exécutée :

```powershell
python E:\mapslol3v3\audit_map10_native_dds_io_20261103\probe_native_terrain_dds_io.py
```

Résultat : code de sortie `0`, trois cas réussis.

Attendu : chaque DDS exact doit traverser les corps originaux jusqu'à `0x9BB247`, produire la séquence readonly `open → size → seek → read → close`, conserver le nom, la taille et le SHA des bytes invités, puis résoudre la cible backend sans l'appeler.

Observé : les trois cas satisfont ces critères. Le helper D3DX x86 réel s'est terminé avec le code `0` et a mesuré les métadonnées des trois fichiers avec la DLL locale identifiée. Dans Unicorn, l'import demeure adapté ; le reçu ne le présente pas comme une exécution in-process de la DLL réelle.

| Cas | I/O observé | Taille invitée | SHA invité = SHA physique | Frontière |
|---|---|---:|---|---|
| `terrainHeightScale.dds` | open → size → seek → read → close | 16 777 344 | oui | `+0x60 → 0x9C2D40`, non appelé |
| `compositeColorMap.dds` | open → size → seek → read → close | 4 194 432 | oui | `+0x60 → 0x9C2D40`, non appelé |
| `fogLightingMap.dds` | open → size → seek → read → close | 4 194 432 | oui | `+0x60 → 0x9C2D40`, non appelé |

### Refus et limites contrôlés

| Entrée | Attendu | Observé | Verdict |
|---|---|---|---|
| nom `not-a-map10-source.dds`, mode `rb` | `KeyError` | `KeyError` | réussi |
| `terrainHeightScale.dds`, mode `wb` | `PermissionError` | `PermissionError` | réussi |

Une relecture PowerShell indépendante du reçu a vérifié : verdicts audit/fonctionnel, trois cas, deux refus, noms, tailles, SHA physiques et invités, ordre I/O, cible `0x9C2D40` et `call_executed=false`. Résultat : `INDEPENDENT_RECEIPT_VALIDATION=PASS`.

Artefacts :

- `perimetre.md`, SHA-256 `2e2e4ff363adfb37eaf935ff4f81d54b7049ac702d72d08769572870e8c01ff7` ;
- `probe_native_terrain_dds_io.py`, SHA-256 `3bc67bc079f162efd1cdaf98186ceaf6317d50120f7aa9b57a048caa24ee7ad3` ;
- `native_terrain_dds_io_execution.json`, SHA-256 `0a4dc5b7d80d9147264616dab5429eb3a95078f2c7635940d5219adb1a261b5d`.

## 5. Résolu et ouvert

### Résolu par V1143

1. Le corps original `0x98A030 → 0x98A460` est exécuté pour les trois DDS terrain exacts ; V1142 ne le faisait pas.
2. Les cinq opérations I/O readonly sont observées dans le bon ordre pour chaque cas.
3. Les bytes effectivement copiés en mémoire invitée ont exactement la taille et le SHA-256 des fichiers physiques de référence.
4. La chaîne CPU originale inférieure est rejouée sur les trois DDS terrain, et non seulement héritée du corpus portraits V689.
5. La requête native atteint `0x9BB247` avec dimensions, mip, usage, format et pool vérifiables ; le slot backend `+0x60` résout `0x9C2D40`.
6. Deux refus pertinents protègent le périmètre readonly et les trois seuls noms autorisés.

### Toujours ouvert

1. **Provider RADS historique** : ordre de recherche, priorité, montage, cache et durée de vie réels du processus 4.20 non exécutés.
2. **Catégorie texture** : seule la branche explicite sans catégorie est qualifiée ; aucune catégorie Flash/terrain historique construite.
3. **D3DX historique** : métadonnées mesurées avec la DLL x86 locale actuelle ; identité et comportement exacts de la DLL 2014 non établis. L'import Unicorn est adapté.
4. **Backend et capacités** : la cible `0x9C2D40` est résolue mais non exécutée ; `+0xF0` utilise un record de capacités nul adapté.
5. **D3D/GPU/rendu** : aucun appel COM réel `CreateTexture`, aucune allocation/upload GPU, aucun draw, pixel ou comparaison visuelle historique.

L'inspection statique précise que `texture+0x94` porte la catégorie de qualité/chemin et non le sélecteur du backend. Les trois chargeurs terrain sont exécutés avant un changement explicite vers une autre catégorie ; en l'absence de trace runtime contraire, le profil `null` employé par le probe est donc le seul profil statiquement défendable, sans être revendiqué comme état historique capturé.

La clôture de l'audit V1143 ne clôt ni les corrections terrain ni la fonctionnalité graphique globale.

## 6. Conditions de reprise

Les clauses `SYS-02.4-03` et `SYS-02.4-04` restent ouvertes. Aucun correctif produit n'est appliqué dans ce lot.

Reprendre seulement avec une entrée qui dépasse la frontière actuelle :

1. capture ou reproduction vérifiée du provider RADS historique, avec ordre/priorité, objet retourné et durée de vie ;
2. objet catégorie historique concret si la branche optionnelle de `0x98A030` doit être qualifiée ;
3. identité binaire 2014 de `d3dx9_39.dll`, ou justification explicite d'une autre référence acceptée ;
4. tracer les xrefs du propriétaire de la vtable `0x10E2E3C` et l'appel factory de `0x9C3E30` jusqu'à l'écriture effective de `[0x2D79078]+0x14`, ou capturer cette écriture en runtime ;
5. backend/device identifié permettant d'exécuter `0x9C2D40` puis ses wrappers jusqu'à la frontière COM `CreateTexture`, sans confondre frontière COM et exécution GPU ;
6. pour l'upload, capturer la chaîne post-création `0x9BB110 → 0x9B6C10 → 0x9BB190 / D3DXLoadSurfaceFromMemory` avec l'un des trois DDS Map10 identifié ;
7. périphérique D3D concret et capture d'upload/draw/pixels si une preuve fonctionnelle ou visuelle est demandée.

Répéter la lecture externe des DDS, V689 portraits, la résolution statique de `+0x60` ou le même probe arrêté avant `0x9BB247` ne constitue pas une piste nouvelle.

## 7. Livrables et décision

Preuves isolées : `E:/mapslol3v3/audit_map10_native_dds_io_20261103/`.

- `perimetre.md`
- `probe_native_terrain_dds_io.py`
- `native_terrain_dds_io_execution.json`
- `AUDIT_SYS01202_MAP10_NATIVE_TERRAIN_DDS_IO_2026-11-03.md`

Décision : **V1143 est terminé pour sa frontière déclarée jusqu'à la résolution du backend virtuel `+0x60`. La fonctionnalité reste incomplète au provider historique, à D3DX 2014, au backend/COM, à l'upload GPU et au rendu.** Le parent `SYS-01.2-02`, les corrections associées et l'acceptation humaine restent ouverts.

Fichiers créés ou modifiés par le lot : le script, le reçu et ce rapport dans le répertoire de preuves E:. Aucun fichier du client original, source produit, asset, registre, goal, Plan, application de suivi, base de données, logiciel ou migration n'a été modifié.
